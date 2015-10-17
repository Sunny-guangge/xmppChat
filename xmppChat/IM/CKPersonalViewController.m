//
//  CKPersonalViewController.m
//  xmppChat
//
//  Created by user on 15/10/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CKPersonalViewController.h"
#import "AppDelegate.h"

@interface CKPersonalViewController ()

@end

@implementation CKPersonalViewController

- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [[UIImage imageNamed:@"rightmessage"] stretchableImageWithLeftCapWidth:21 topCapHeight:13];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////    [button setImage:image forState:UIControlStateNormal];
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    [self.view addSubview:button];
//    button.frame = CGRectMake(60, 100, 100, 100);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, 300, 100)];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)clicklogout:(id)sender {
    
    [[self appDelegate] logout];
    
}
@end
