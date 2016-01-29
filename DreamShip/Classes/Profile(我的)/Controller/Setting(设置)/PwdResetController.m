//
//  PwdResetController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "PwdResetController.h"
#import "PwdConfirmView.h"
#import "DataBaseSharedManager.h"
#import "AccountTool.h"
#import "AccountModel.h"
#import "HttpTool.h"
#import "registerOrLoginViewController.h"

@interface PwdResetController()

@property (nonatomic, strong) PwdConfirmView  *pwdCV;
@property (nonatomic, weak)   UIButton        *finishBtn;

@end

@implementation PwdResetController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"密码重置";
    [self setSubviews];
}

// 设置UI子控件
-(void)setSubviews{
    // 密码和密码确认
    PwdConfirmView *pwdConfirmView = [[PwdConfirmView alloc] initWithFrame:CGRectMake(10, 70, kScreenWidth - 20, 90)];
    [self.view addSubview:pwdConfirmView];
    _pwdCV = pwdConfirmView;
    
    // 修改确认
    UIButton *confirmButton = [[UIButton alloc] initWithFrame: CGRectMake(10, CGRectGetMaxY(pwdConfirmView.frame) + 20, kScreenWidth - 2 * 10, 44)];
    confirmButton.layer.cornerRadius = 5;
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleColor:kTitleFireColorHighlighted forState:UIControlStateHighlighted];
    [confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:kBtnFireColorNormal];
    [confirmButton addTarget:self action:@selector(finishConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    _finishBtn = confirmButton;
}

// 密码确认
-(void)finishConfirm{
    NSString *pwd           = self.pwdCV.userPwd.text;
    NSString *pwdConfirm    = self.pwdCV.userPwdConfirm.text;
    AccountModel *accountModel = [AccountTool account];
    
    NSString *pwdMD5 = [CommomToolDefine MD5_16:pwd];
    
    if (pwd.length <= 6) {
        [MBProgressHUD showError:@"密码长度不能低于6位"];
    }else if (![pwd isEqualToString:pwdConfirm]){
        [MBProgressHUD showError:@"两次输入密码不一致"];
    }else if ([accountModel.userPwd isEqualToString:pwd]){
        [MBProgressHUD showError:@"新密码与旧密码一致"];
    }else{       
        if ([HttpTool saveUserInfo:accountModel.userPhone mod_key:@"pwd" mod_value:pwdMD5]){
            [MBProgressHUD showSuccess:@"修改成功"];
            
            accountModel.userPwd = pwd;
            [AccountTool saveAccount:accountModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
