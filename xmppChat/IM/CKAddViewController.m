//
//  CKAddViewController.m
//  xmppChat
//
//  Created by user on 15/10/16.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CKAddViewController.h"
#import "AppDelegate.h"

@interface CKAddViewController ()

@end

@implementation CKAddViewController
{
    UITextField *textfield;
}

#pragma mark - AppDelegate 的助手方法
- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"添加好友";
    
    textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 30)];
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.placeholder = @"请输入好友的名字";
    [self.view addSubview:textfield];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(80, CGRectGetMaxY(textfield.frame) + 20, self.view.frame.size.width - 160, 100);
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(didClickAddCompanyButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}

- (void)didClickAddCompanyButton
{
    NSString *name = [NSString stringWithFormat:@"%@%@",textfield.text,@"@teacher.local"];
    
    [[[self appDelegate] xmppRoster] subscribePresenceToUser:[XMPPJID jidWithString:name]];
    
    // 6. 提示用户发送成功
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加好友请求已发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}





@end
