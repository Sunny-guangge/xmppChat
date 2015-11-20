//
//  CKChatNavigationViewController.m
//  xmppChat
//
//  Created by user on 15/11/20.
//  Copyright © 2015年 user. All rights reserved.
//

#import "CKChatNavigationViewController.h"
#import "Header.h"

@interface CKChatNavigationViewController ()

@end

@implementation CKChatNavigationViewController

//+ (void)initialize
//{
//    UINavigationBar *navigationBar = [UINavigationBar appearance];
//    
//    navigationBar.barTintColor = DEFAULT_NAVBAR_COLOR;
//    
//    navigationBar.tintColor = [UIColor whiteColor];
//    
//    navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
//                                          
//                                          NSForegroundColorAttributeName:[UIColor whiteColor]};
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar setBarTintColor:DEFAULT_NAVBAR_COLOR];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:DEFAULT_BACKGROUND_COLOR];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

#pragma mark 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    // 白色样式
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
