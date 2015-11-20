//
//  CKViewController.m
//  xmppChat
//
//  Created by user on 15/10/16.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CKViewController.h"
#import "Header.h"

@interface CKViewController ()

@end

@implementation CKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarItem *messageTabbarItem = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *contaceTabbarItem = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *personalTabbarItem = [self.tabBar.items objectAtIndex:2];
    
    UIImage * normalImage1 = [[UIImage imageNamed:@"tabbar_mainframe"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * selectImage1 = [[UIImage imageNamed:@"tabbar_mainframeHL"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageTabbarItem.image = normalImage1;
    messageTabbarItem.selectedImage = selectImage1;
    
    
    UIImage * normalImage2 = [[UIImage imageNamed:@"tabbar_contacts"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * selectImage2 = [[UIImage imageNamed:@"tabbar_contactsHL"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    contaceTabbarItem.image = normalImage2;
    contaceTabbarItem.selectedImage = selectImage2;
    
    
    UIImage * normalImage3 = [[UIImage imageNamed:@"tabbar_me"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * selectImage3 = [[UIImage imageNamed:@"tabbar_meHL"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personalTabbarItem.image = normalImage3;
    personalTabbarItem.selectedImage = selectImage3;
    
    [self.tabBar setBackgroundColor:DEFAULT_SEARCHBAR_COLOR];
    [self.tabBar setTintColor:DEFAULT_GREEN_COLOR];
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
