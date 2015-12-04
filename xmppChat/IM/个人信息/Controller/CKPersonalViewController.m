//
//  CKPersonalViewController.m
//  xmppChat
//
//  Created by user on 15/10/15.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CKPersonalViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"
#import "CKLoginUser.h"
#import "Header.h"
//#import "CKEditViewController.h"

@interface CKPersonalViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic,strong) UITableView *cardTableView;

@end

@implementation CKPersonalViewController
{
    NSMutableArray *nameArray;
    UIImageView *avatarImageView;
    UIImage *image1;
    NSMutableArray *zhiArray;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UILabel *label5;
    UILabel *label6;
    UILabel *label7;
}

- (UITableView *)cardTableView
{
    if (!_cardTableView) {
        _cardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
        _cardTableView.delegate = self;
        _cardTableView.dataSource = self;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _cardTableView.tableFooterView = footerView;
    }
    return _cardTableView;
}

- (AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    nameArray = [[NSMutableArray alloc] initWithObjects:@"头像",@"姓名",@"账号",@"公司",@"部门",@"职务",@"电话",@"邮件", nil];
    
    zhiArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //获取用户个人信息
//    [self getUserMessage];
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didClickEditButton)];
    
    self.navigationItem.leftBarButtonItem = editBarButtonItem;
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getUserMessage];
}

- (void)didClickEditButton
{
//    CKEditViewController *editVC = [[CKEditViewController alloc] initWithNibName:@"CKEditViewController" bundle:nil];
//    
//    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)getUserMessage
{
    //获取当前账号的电子名片
    XMPPvCardTemp *myCard = [[[self appDelegate] xmppvCardModule] myvCardTemp];
    
    //判断当前账号是否有电子名片
    if (myCard == nil) {
        //新建电子名片
        myCard = [XMPPvCardTemp vCardTemp];
        //设置昵称
        myCard.nickname = [[CKLoginUser shareLoginUser] loginUserName];
    }
    
    NSString *nini = [[CKLoginUser shareLoginUser] loginUserName];
    NSLog(@"%@",nini);
    
    //设置jid
    if (myCard.jid == nil) {
        myCard.jid = [XMPPJID jidWithString:[[CKLoginUser shareLoginUser] loginUserJIDName]];
    }
    
    //更新或保存电子名片
    [[[self appDelegate] xmppvCardModule] updateMyvCardTemp:myCard];
    
    //使用myCard的信息设置界面UI显示
    NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:myCard.jid];
    if (photoData) {
        image1 = [UIImage imageWithData:photoData];
    }
    
    if (myCard.nickname) {
        [zhiArray replaceObjectAtIndex:0 withObject:myCard.nickname];
    }
    if (myCard.jid) {
        [zhiArray replaceObjectAtIndex:1 withObject:[myCard.jid full]];
    }
    if (myCard.orgName) {
        [zhiArray replaceObjectAtIndex:2 withObject:myCard.orgName];
    }
    if (myCard.orgUnits) {
        [zhiArray replaceObjectAtIndex:3 withObject:myCard.orgUnits[0]];
    }
    if (myCard.title) {
        [zhiArray replaceObjectAtIndex:4 withObject:myCard.title];
    }
    if (myCard.note) {
        [zhiArray replaceObjectAtIndex:5 withObject:myCard.note];
    }
    if (myCard.mailer) {
        [zhiArray replaceObjectAtIndex:6 withObject:myCard.mailer];
    }
    
    [self.view addSubview:self.cardTableView];
    [self.cardTableView reloadData];
}



- (IBAction)clicklogout:(id)sender {
    
    [[self appDelegate] logout];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"idid";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        if (indexPath.row == 0) {
            
            avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 140, 0, 100, 100)];
            avatarImageView.layer.cornerRadius = 5;
            avatarImageView.layer.masksToBounds = YES;
            [cell addSubview:avatarImageView];
        }
        if (indexPath.row == 1)
        {
            label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 100 - 40, 46)];
            label1.textAlignment = NSTextAlignmentRight;
            [cell addSubview:label1];
        }
        if (indexPath.row == 2)
        {
            label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 100 - 40, 46)];
            label2.textAlignment = NSTextAlignmentRight;
            [cell addSubview:label2];
        }
        if (indexPath.row == 3)
        {
            label3 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 100 - 40, 46)];
            label3.textAlignment = NSTextAlignmentRight;
            [cell addSubview:label3];
        }
        if (indexPath.row == 4)
        {
            label4 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 100 - 40, 46)];
            label4.textAlignment = NSTextAlignmentRight;
            [cell addSubview:label4];
        }
        if (indexPath.row == 5)
        {
            label5 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 100 - 40, 46)];
            label5.textAlignment = NSTextAlignmentRight;
            [cell addSubview:label5];
        }if (indexPath.row == 6)
        {
            label6 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 100 - 40, 46)];
            label6.textAlignment = NSTextAlignmentRight;
            [cell addSubview:label6];
        }if (indexPath.row == 7)
        {
            label7 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width - 100 - 40, 46)];
            label7.textAlignment = NSTextAlignmentRight;
            [cell addSubview:label7];
        }
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [nameArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        avatarImageView.image = image1;
    }
    if (indexPath.row == 1) {
        
        label1.text = [zhiArray objectAtIndex:0];
    }
    if (indexPath.row == 2) {
        label2.text = [zhiArray objectAtIndex:1];
    }
    if (indexPath.row == 3) {
        label3.text = [zhiArray objectAtIndex:2];
    }
    if (indexPath.row == 4) {
        label4.text = [zhiArray objectAtIndex:3];
    }
    if (indexPath.row == 5) {
        label5.text = [zhiArray objectAtIndex:4];
    }
    if (indexPath.row == 6) {
        label6.text = [zhiArray objectAtIndex:5];
    }
    if (indexPath.row == 7) {
        label7.text = [zhiArray objectAtIndex:6];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heitht = 0.0;
    
    if (indexPath.row == 0) {
        heitht = 100;
    }else
    {
        heitht = 46;
    }
    return heitht;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"选择照片", nil];
        
        [sheet showInView:self.view];
    }
}


#pragma mark - ActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // 1. 设置照片源，提示在模拟上不支持相机！
    if (buttonIndex == 0) {
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    // 2. 允许编辑
    [picker setAllowsEditing:YES];
    // 3. 设置代理
    [picker setDelegate:self];
    // 4. 显示照片选择控制器
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 照片选择代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1. 设置头像
    avatarImageView.image = info[UIImagePickerControllerEditedImage];
    // 2. 保存名片
    image1 = info[UIImagePickerControllerEditedImage];
    // 1. 获取电子名片
    XMPPvCardTemp *myCard = [[[self appDelegate] xmppvCardModule] myvCardTemp];
    
    // 2. 设置名片内容
    myCard.photo = UIImagePNGRepresentation(avatarImageView.image);
    
    // 3. 保存电子名片
    [[[self appDelegate] xmppvCardModule] updateMyvCardTemp:myCard];
    
    // 3. 关闭照片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
