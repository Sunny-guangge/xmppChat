//
//  CKPersonalViewController.h
//  xmppChat
//
//  Created by user on 15/10/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKPersonalViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutbutton;

- (IBAction)clicklogout:(id)sender;

@end
