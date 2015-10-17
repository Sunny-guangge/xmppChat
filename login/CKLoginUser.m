//
//  CKLoginUser.m
//  xmppChat
//
//  Created by user on 15/10/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CKLoginUser.h"
#import "NSString+Helper.h"

#define CKLoginUserName @"CKLoginUserName"

#define CKLoginUserPassword @"CKLoginUserPassword"

static CKLoginUser *loginUser;

@implementation CKLoginUser

+ (CKLoginUser *)shareLoginUser
{
    @synchronized(self)
    {
        if (loginUser == nil) {
            loginUser = [[CKLoginUser alloc] init];
        }
    }
    return loginUser;
}


- (NSString *)loadStringFromDefaultsWithKey:(NSString *)key
{
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    return (str) ? str : @"";
}

- (NSString *)loginUserName
{
    return [self loadStringFromDefaultsWithKey:CKLoginUserName];
}

- (void)setLoginUserName:(NSString *)loginUserName
{
    [loginUserName saveToNSDefaultsWithKey:CKLoginUserName];
}

- (NSString *)loginUserPassword
{
    return [self loadStringFromDefaultsWithKey:CKLoginUserPassword];
}

- (void)setLoginUserPassword:(NSString *)loginUserPassword
{
    [loginUserPassword saveToNSDefaultsWithKey:CKLoginUserPassword];
}

- (NSString *)loginUserJIDName
{
    return [NSString stringWithFormat:@"%@%@",self.loginUserName,@"@teacher.local"];
}


@end
