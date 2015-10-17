//
//  ViewController.h
//  xmppChat
//
//  Created by user on 15/10/14.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) IBOutlet UITextField *secretTextField;

@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)clickLoginButton:(UIButton *)sender;

@end

