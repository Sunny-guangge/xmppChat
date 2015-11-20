//
//  ViewController.m
//  xmppChat
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Helper.h"
#import "CKLoginUser.h"
#import "AppDelegate.h"


@interface ViewController ()<UITextFieldDelegate>



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.nameTextField.delegate = self;
    self.secretTextField.delegate = self;
    
//    self.nameTextField.layer;
}

- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//去除字符串的空白字符（将字符串前后的空格去掉）
- (NSString *)trimString:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameTextField) {
        [_nameTextField becomeFirstResponder];
    } else if (textField == _secretTextField ) {
//        [_hostNameText becomeFirstResponder];
    } else {
//        [self userLoginAndRegister:nil];
    }
    
    return YES;
}


- (IBAction)clickLoginButton:(UIButton *)sender {
    //检查用户输入是否完整,在商业的软件中，处理用户输入时，通常会截断字符串前后的空格（密码除外），从而最大程度降低用户输入错误
    [self.nameTextField.text trimString];
    
    //检测输入的是不是空
    if ([self.nameTextField.text isEmptyString] || [self.secretTextField.text isEmptyString]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入信息不完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    [[CKLoginUser shareLoginUser] setLoginUserName:self.nameTextField.text];
    [[CKLoginUser shareLoginUser] setLoginUserPassword:self.secretTextField.text];
    
    if (sender.tag == 10) {
        
        [self appDelegate].isRegisterUser = YES;
        
    }else
    {
        
    }
    
    
    [[self appDelegate] connectWithSeverWithCompletion:^{
        
        NSLog(@"");
        
    } withFailBlock:^(NSString *fail) {
        
    }];
    
    //让appdelegate开始链接
    //链接成功或失败提示用户
    //
    
}
@end
