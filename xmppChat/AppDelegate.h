//
//  AppDelegate.h
//  xmppChat
//
//  Created by user /Users/user/Desktop/企信通/企信通on 15/10/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"

typedef void(^Completion)();

typedef void(^FailBlock)(NSString *fail);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) XMPPStream *xmppStream;

#pragma mark  修改个人名片
/**
 *  全局的xmppvCard模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPvCardTempModule *xmppvCardModule;
/**
 *  全局的XMPPvCardAvatar模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;


#pragma mark 添加好友，获取好友列表
/**
 *  全局的xmppRoster模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPRoster *xmppRoster;
/**
 *  全局的XMPPRosterCoreDataStorage模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;


#pragma mark 关于聊天信息记录
/**
 *  消息存档（归档）模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPMessageArchiving *xmppMessageArchiving;
@property (strong, nonatomic, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

/**
 *  传输文件socket数组
 */
@property (strong, nonatomic) NSMutableArray *socketList;


/**
 *区分是注册还是登录的标识符
 */
@property (nonatomic,assign) BOOL isRegisterUser;


-(NSArray*)getFriends;

- (void)connectWithSeverWithCompletion:(Completion)completion withFailBlock:(FailBlock)failBlock;

//注销登录
- (void)logout;

@end

