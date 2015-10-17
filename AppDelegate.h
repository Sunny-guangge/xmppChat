//
//  AppDelegate.h
//  xmppChat
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"

typedef void(^Completion)();

typedef void(^FailBlock)(NSString *fail);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) XMPPStream *xmppStream;

/**
 *  全局的xmppRoster模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPRoster *xmppRoster;
/**
 *  全局的XMPPRosterCoreDataStorage模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;


/**
 *区分是注册还是登录的标识符
 */
@property (nonatomic,assign) BOOL isRegisterUser;




- (void)connectWithSeverWithCompletion:(Completion)completion withFailBlock:(FailBlock)failBlock;

//注销登录
- (void)logout;

@end

