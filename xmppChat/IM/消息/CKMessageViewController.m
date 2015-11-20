//
//  CKMessageViewController.m
//  xmppChat
//
//  Created by user on 15/10/16.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CKMessageViewController.h"

@interface CKMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CKMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"111"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"111"];
    }
    
    cell.textLabel.text = @(indexPath.row).description;
    
    return cell;
}

@end
