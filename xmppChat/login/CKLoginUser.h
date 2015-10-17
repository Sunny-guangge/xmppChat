//
//  CKLoginUser.h
//  xmppChat
//
//  Created by user on 15/10/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKLoginUser : NSObject
+ (CKLoginUser *)shareLoginUser;

@property (nonatomic,strong) NSString *loginUserName;

@property (nonatomic,strong) NSString *loginUserPassword;


@property (nonatomic,copy,readonly) NSString *loginUserJIDName;

@end
