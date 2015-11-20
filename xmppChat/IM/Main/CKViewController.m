//
//  CKViewController.m
//  xmppChat
//
//  Created by user on 15/10/16.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CKViewController.h"

@interface CKViewController ()

@end

@implementation CKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarItem *messageTabbarItem = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *contaceTabbarItem = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *personalTabbarItem = [self.tabBar.items objectAtIndex:2];
    
    UIImage * normalImage1 = [[UIImage imageNamed:@"tabbar1"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * selectImage1 = [[UIImage imageNamed:@"Seltabbar1"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageTabbarItem.image = normalImage1;
    messageTabbarItem.selectedImage = selectImage1;
    
    
    UIImage * normalImage2 = [[UIImage imageNamed:@"tabbar2"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * selectImage2 = [[UIImage imageNamed:@"Seltabbar2"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contaceTabbarItem.image = normalImage2;
    contaceTabbarItem.selectedImage = selectImage2;
    
    
    UIImage * normalImage3 = [[UIImage imageNamed:@"tabbar3"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * selectImage3 = [[UIImage imageNamed:@"Seltabbar3"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalTabbarItem.image = normalImage3;
    personalTabbarItem.selectedImage = selectImage3;
    
    self.hidesBottomBarWhenPushed = YES;
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
