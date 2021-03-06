//
//  AppDelegate.m
//  xmppChat
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "AppDelegate.h"
#import "CKLoginUser.h"
#import "NSString+Helper.h"
#import "XMPPReconnect.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPCapabilities.h"
#import "XMPPCapabilitiesCoreDataStorage.h"

#define CKHostName @"192.168.1.101"

@interface AppDelegate ()<XMPPStreamDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate>
{
    Completion _completion;
    FailBlock _failBlock;
    
    // XMPP重新连接XMPPStream
    XMPPReconnect   *_xmppReconnect;
    
    XMPPvCardCoreDataStorage    *_xmppvCardStorage;     // 电子名片的数据存储模块
    
    XMPPCapabilities            *_xmppCapabilities;     // 实体扩展模块
    XMPPCapabilitiesCoreDataStorage *_xmppCapabilitiesCoreDataStorage; // 数据存储模块
    
    //申请加好友的人的信息
    XMPPJID *jid;
    
    NSFetchedResultsController *_fecthdeResultController;
}

//设置xmppstream
- (void)setupstream;

// 销毁XMPPStream并注销已注册的扩展模块
- (void)teardownStream;

//连接到服务器
- (void)connect;

//与服务器断开
- (void)disconnect;

//通知服务器用户上线
- (void)goOnline;

//下线
- (void)goOffline;


@end

@implementation AppDelegate


#pragma mark - 切换storyboard
- (void)changeStoryboardWithBool:(BOOL)IMOrMain
{
    UIStoryboard *storyboard = nil;
    
    if (IMOrMain) {
        
        storyboard = [UIStoryboard storyboardWithName:@"IM" bundle:nil];
        
    }else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 如果在项目属性中，没有指定主界面（启动的Storyboard，self.window不会被实例化）
        // 把Storyboard的初始视图控制器设置为window的rootViewController
//        [self.window setRootViewController:storyboard.instantiateInitialViewController];
        self.window.rootViewController = storyboard.instantiateInitialViewController;
        if (!self.window.isKeyWindow) {
            [self.window makeKeyAndVisible];
        }
        
    });
}


#pragma mark 外部链接调用这个方法
- (void)connectWithSeverWithCompletion:(Completion)completion withFailBlock:(FailBlock)failBlock
{
    _completion = completion;
    _failBlock = failBlock;
    
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    
    [self connect];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //需要添加在没有网络的情况下不能链接
    
    //设置XMPPStream
    [self setupstream];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disconnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self connect];
}

//设置xmppstream
- (void)setupstream
{
//    if (_xmppStream == nil) {
//        //实例化xmppstream
//        _xmppStream = [[XMPPStream alloc] init];
//        
//        //添加代理
//        //因为所有网络请求都是基于网络的数据处理，跟界面UI无关因此可以让代理方法在其他线程中执行从而提高程序的运行性能
//        [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
//    }
    // 0. 方法被调用时，要求_xmppStream必须为nil，否则通过断言提示程序员，并终止程序运行！
    NSAssert(_xmppStream == nil, @"XMPPStream被多次实例化！");
    
    // 1. 实例化XMPPSteam
    _xmppStream = [[XMPPStream alloc] init];
    
    // 让XMPP在真机运行时支持后台，在模拟器上是不支持后台服务运行的
#if !TARGET_IPHONE_SIMULATOR
    {
        // 允许XMPPStream在真机运行时，支持后台网络通讯！
        [_xmppStream setEnableBackgroundingOnSocket:YES];
    }
#endif
    
    //扩展模块
    //2.1重新连接模块
    _xmppReconnect = [[XMPPReconnect alloc] init];
    //2.2电子名片模块
    _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _xmppvCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
    _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardModule];
    // 2.4 花名册模块
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    // 设置自动接收好友订阅请求
    [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:YES];
    // 自动从服务器更新好友记录，例如：好友自己更改了名片
    [_xmppRoster setAutoFetchRoster:YES];
    
    // 2.5 实体扩展模块
    _xmppCapabilitiesCoreDataStorage = [[XMPPCapabilitiesCoreDataStorage alloc] init];
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesCoreDataStorage];
    
    // 2.6 消息归档模块
    _xmppMessageArchivingCoreDataStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    
    
    // 3 将重新连接模块添加到XMPPStream
    [_xmppReconnect activate:_xmppStream];
    [_xmppvCardModule activate:_xmppStream];
    [_xmppvCardAvatarModule activate:_xmppStream];
    [_xmppRoster activate:_xmppStream];
    [_xmppCapabilities activate:_xmppStream];
    [_xmppMessageArchiving activate:_xmppStream];
    
    
    // 4. 添加代理
    // 由于所有网络请求都是做基于网络的数据处理，这些数据处理工作与界面UI无关。
    // 因此可以让代理方法在其他线城中运行，从而提高程序的运行性能，避免出现应用程序阻塞的情况
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

// 销毁XMPPStream并注销已注册的扩展模块
- (void)teardownStream
{
    // 1. 删除代理
    [_xmppStream removeDelegate:self];
    [_xmppRoster removeDelegate:self];
    
    // 2. 取消激活在setupStream方法中激活的扩展模块
    [_xmppReconnect deactivate];
    [_xmppvCardModule deactivate];
    [_xmppvCardAvatarModule deactivate];
    [_xmppRoster deactivate];
    [_xmppCapabilities deactivate];
    [_xmppMessageArchiving deactivate];
    
    // 3. 断开XMPPStream的连接
    [_xmppStream disconnect];
    
    // 4. 内存清理
    _xmppStream = nil;
    _xmppReconnect = nil;
    _xmppvCardModule = nil;
    _xmppvCardAvatarModule = nil;
    _xmppvCardStorage = nil;
    _xmppRoster = nil;
    _xmppRosterStorage = nil;
    _xmppCapabilities = nil;
    _xmppCapabilitiesCoreDataStorage = nil;
    _xmppMessageArchiving = nil;
    _xmppMessageArchivingCoreDataStorage = nil;
}

- (void)dealloc
{
    // 释放XMPP相关对象及扩展模块
    [self teardownStream];
}


#pragma mark 通知服务器上线
- (void)goOnline
{
    //实例化一个“展现”
    XMPPPresence *presence = [XMPPPresence presence];
    
    //发送presence给服务器
    //服务器知道“我”上线后，通知我的好友，而无需通知我
    [_xmppStream sendElement:presence];
}

#pragma mark 通知服务器下线
- (void)goOffline
{
    //实例化一个“展现”
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    //发送presence给服务器
    //服务器知道“我”下线后，通知我的好友，而无需通知我
    [_xmppStream sendElement:presence];
}


#pragma mark   连接到服务器
- (void)connect
{
    if ([_xmppStream isConnected]) {
        return;
    }
    
    //指定用户名、密码、主机  teacher.local是服务器域名  hostname使用localhost能链接到服务器但是登录密码验证不通过
    NSString *userName = [[CKLoginUser shareLoginUser] loginUserJIDName];
    NSString *password = [[CKLoginUser shareLoginUser] loginUserPassword];
    NSString *hostName = CKHostName;
    
    if ([userName isEmptyString] || [password isEmptyString]) {
        
        [self changeStoryboardWithBool:NO];
        
        return;
    }
    
    //设置XMPPStream的JID和主机
    [_xmppStream setMyJID:[XMPPJID jidWithString:userName]];
    [_xmppStream setHostName:hostName];
    
    //开始链接
    NSError *error = nil;
    
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    
    if (error) {
        NSLog(@"链接请求发送出错 － %@",error.localizedDescription);
    }else
    {
        NSLog(@"链接请求发送成功");
    }
    
}
#pragma mark    与服务器断开连接
- (void)disconnect
{
    NSLog(@"用户下线！");
    //通知服务器下线
    [self goOffline];
    
    //断开连接
    [_xmppStream disconnect];
}

#pragma mark     注销登录
- (void)logout
{
    [self disconnect];
    
    [self changeStoryboardWithBool:NO];
}

#pragma mark - 代理方法
//链接完成（如果服务器地址不对，就不会调用此方法）
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接建立");
    
    //开始发送身份验证请求
    NSString *password = [[CKLoginUser shareLoginUser] loginUserPassword];
    
    if (_isRegisterUser) {
        
        [_xmppStream registerWithPassword:password error:nil];
        
    }else
    {
        [_xmppStream authenticateWithPassword:password error:nil];
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if (_failBlock != nil) {
        _failBlock(@"服务器地址不对！");
    }
    [self changeStoryboardWithBool:NO];
    NSLog(@"连接失败");
}

#pragma mark - 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    _isRegisterUser = NO;
    
    //注册成功，直接发送验证身份请求，从而触发后续的操作
    [_xmppStream authenticateWithPassword:[[CKLoginUser shareLoginUser] loginUserPassword] error:nil];
}

#pragma mark 注册失败(用户名已经存在)
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    _isRegisterUser = NO;
    if (_failBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failBlock(@"");
        });
    }
}

#pragma mark - 验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    if (_completion != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _completion();
        });
    }
    
    NSLog(@"身份验证通过");
    
    [self goOnline];
    
    
    [self changeStoryboardWithBool:YES];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    
    if (_failBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failBlock(@"");
        });
    }
    
    NSLog(@"身份验证失败");
    
    [self changeStoryboardWithBool:NO];
}

////收到有人添加好友的消息
//- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
//{
//    //取得好友状态
//    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
//    //请求的用户
//    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
//    NSLog(@"presenceType:%@",presenceType);
//    
//    NSLog(@"presence2:%@  sender2:%@",presence,sender);
//    
//    jid = [XMPPJID jidWithString:presenceFromUser];
//    
//    NSString *message = [NSString stringWithFormat:@"%@请求加您为好友！",presenceFromUser];
//    
//    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
//    alertview.delegate = self;
//    [alertview show];
//    
//    //    [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex == 0)
//    {
//        [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:NO];
//    }else
//    {
//        [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
//    }
//}

//收到好友请求 代理函数
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSString * presenceType = [presence type];
    NSLog(@"presenceType = %@",presenceType);
    XMPPJID * fromJid = presence.from;
    if ([presenceType isEqualToString:@"subscribe"]) {//是订阅请求  直接通过
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:fromJid andAddToRoster:YES];
    }
}

-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
{
    NSString *subscription = [item attributeStringValueForName:@"subscription"];
    NSLog(@"%@",subscription);
    if ([subscription isEqualToString:@"both"]) {
        NSLog(@"双方成为好友！");
    }
    NSLog(@"");
}


//获取好友列表
-(NSArray*)getFriends
{
    NSManagedObjectContext *context = _xmppRosterStorage.mainThreadManagedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //筛选本用户的好友
    NSString *userinfo = [NSString stringWithFormat:@"%@@%@",[[CKLoginUser shareLoginUser] loginUserName],@"teacher.local"];
    
    NSLog(@"userinfo = %@",userinfo);
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@" streamBareJidStr = %@ ",userinfo];
    request.predicate = predicate;
    
    //排序
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    _fecthdeResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _fecthdeResultController.delegate = self;
    NSError *error;
    [_fecthdeResultController performFetch:&error];
    
    //返回的数组是XMPPUserCoreDataStorageObject  *obj类型的
    //名称为 obj.displayName
    NSLog(@"%lu",(unsigned long)_fecthdeResultController.fetchedObjects.count);
    return  _fecthdeResultController.fetchedObjects;
}

//数据库有变化
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    NSManagedObject *obj = anObject;
    if([obj isKindOfClass:[XMPPMessageArchiving_Message_CoreDataObject class]])
    {
//        NSLog(@"<span style="font-family:">聊天的信息的数据库发生变化</span>");
    }//</xmppstreamdelegate,xmpprosterdelegate,nsfetchedresultscontrollerdelegate>

}
@end