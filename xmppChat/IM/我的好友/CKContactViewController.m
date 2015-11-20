//
//  CKContactViewController.m
//  xmppChat
//
//  Created by user on 15/10/16.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CKContactViewController.h"
#import "CKAddViewController.h"
#import "AppDelegate.h"
#import "Header.h"

@interface CKContactViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fecthdeResultController;
    
    XMPPJID *jid;
}

@property (nonatomic,strong) UITableView *contactTableView;


@end

@implementation CKContactViewController

- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didClickAddMycompany)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.contactTableView];
    
//    [self setupFetchedController];
    
    NSArray *array = [NSMutableArray array];
    
    array = [[self appDelegate] getFriends];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self queryRoster];
}

- (UITableView *)contactTableView
{
    if (!_contactTableView) {
        _contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0 - 49)];
        _contactTableView.delegate = self;
        _contactTableView.dataSource = self;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
        _contactTableView.tableFooterView = headerView;
    }
    return _contactTableView;
}

- (void)didClickAddMycompany
{
    CKAddViewController *addVC = [[CKAddViewController alloc] init];
    
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)setupFetchedController
{
    //
    NSManagedObjectContext *context = [[[self appDelegate] xmppRosterStorage] mainThreadManagedObjectContext];
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
//    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    [request setSortDescriptors:@[sort1]];
    
    _fecthdeResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:@"sectionNum" cacheName:nil];
    
    [_fecthdeResultController setDelegate:self];
}


- (void)queryRoster {
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    
    XMPPStream *xmppstream = [[self appDelegate] xmppStream];
    XMPPJID *myJID = xmppstream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
    [iq addAttributeWithName:@"id" stringValue:@"zhangsan@teacher.local"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [xmppstream sendElement:iq];
}



- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            for (NSXMLElement *item in items) {
                NSString *jid = [item attributeStringValueForName:@"jid"];
                XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                
            }
        }
    }
    return YES;
}








#pragma mark - NSFetchedResultsController代理方法
#pragma mark 控制器数据发生改变（因为Roster是添加了代理的）
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.contactTableView reloadData];
}




#pragma mark - UITableView数据源方法
#pragma mark 表格分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 返回查询结果的分组数量
    
    NSLog(@"---------%lu-----------",(unsigned long)_fecthdeResultController.sections.count);
    
    return _fecthdeResultController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //取出控制器中的所有分组
    NSArray *array = [_fecthdeResultController sections];
    //根据section值取出对应的分组信息对象
    id <NSFetchedResultsSectionInfo> info = array[section];
    
    NSString *stateName = nil;
    NSInteger state = [[info name] integerValue];
    
    switch (state) {
        case 0:
            stateName = @"在线";
            break;
        case 1:
            stateName = @"离开";
            break;
        case 2:
            stateName = @"下线";
            break;
        default:
            stateName = @"未知";
            break;
    }
    
    return stateName;
}

#pragma mark 对应分组中表格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionData = [_fecthdeResultController sections];
    
    if (sectionData.count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = sectionData[section];
        
        return [sectionInfo numberOfObjects];
    }
    
    return 0;
}

#pragma mark 加载用户头像
- (UIImage *)loadUserImage:(XMPPUserCoreDataStorageObject *)user
{
    // 1. 判断user中是否包含头像，如果有，直接返回
    if (user.photo) {
        return user.photo;
    }
    
    // 2. 如果没有头像，从用户的头像模块中提取用户头像
    NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
    
    if (photoData) {
        return [UIImage imageWithData:photoData];
    }
    
    return [UIImage imageNamed:@"DefaultProfileHead"];
}

#pragma mark 表格行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"RosterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    // 设置单元格
    XMPPUserCoreDataStorageObject *user = [_fecthdeResultController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = user.displayName;
    cell.imageView.image = [self loadUserImage:user];
    
    return cell;
}





@end
