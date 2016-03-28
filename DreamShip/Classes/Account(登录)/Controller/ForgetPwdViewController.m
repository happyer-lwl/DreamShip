//
//  ForgetPwdViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "UICustomTextField.h"
#import <SMS_SDK/SMSSDK.h>
#import "PwdResetController.h"

@interface ForgetPwdViewController()

@property (nonatomic, weak) UITextField *userName;
@property (nonatomic, weak) UITextField *userCode;
@property (nonatomic, weak) UIButton    *sendCodeBtn;
@property (nonatomic, weak) UIButton    *confirmBtn;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ForgetPwdViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"忘记密码";
    [self setSubviews];
}

-(void)setSubviews{
    [self setupTextFieldNameAndPwd];
}

/**
 * 设置用户名密码
 */
-(void)setupTextFieldNameAndPwd{
    CGFloat viewWidth = self.view.width;
    CGFloat cellHeight = 44;
    
    // 用户手机号
    UICustomTextField *name = [[UICustomTextField alloc] init];
    name.frame = CGRectMake(10, 10, viewWidth - 20, cellHeight);
    name.placeholder = @"您的手机号";
    name.font = [UIFont systemFontOfSize:16];
    name.backgroundColor = [UIColor whiteColor];
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    name.keyboardType = UIKeyboardTypePhonePad;
    _userName = name;
    [self.view addSubview:name];
    name.delegate = self;
    
    // 验证码
    UICustomTextField *pwd = [[UICustomTextField alloc] init];
    pwd.frame = CGRectMake(10, CGRectGetMaxY(name.frame) + 1, viewWidth - 160, cellHeight);
    pwd.placeholder = @"验证码";
    pwd.font = [UIFont systemFontOfSize:16];
    pwd.backgroundColor = [UIColor whiteColor];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwd.keyboardType = UIKeyboardTypePhonePad;
    pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userCode = pwd;
    [self.view addSubview:pwd];
    pwd.delegate = self;
    
    // 发送验证码
    UIButton *sendCodeButton = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMaxX(pwd.frame) + 20, CGRectGetMaxY(name.frame) + 6, 120, cellHeight - 10)];
    sendCodeButton.layer.cornerRadius = 5;
    [sendCodeButton setBackgroundColor:kBtnFireColorNormal];
    [sendCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendCodeButton setTitleColor:kTitleFireColorHighlighted forState:UIControlStateHighlighted];
    [sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendCodeButton addTarget:self action:@selector(sendCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendCodeButton];
    _sendCodeBtn = sendCodeButton;
    
    // 确认
    UIButton *confirmButton = [[UIButton alloc] initWithFrame: CGRectMake(10, CGRectGetMaxY(pwd.frame) + 40, kScreenWidth - 20, cellHeight)];
    confirmButton.layer.cornerRadius = 5;
    [confirmButton setBackgroundColor:kBtnFireColorNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleColor:kTitleFireColorHighlighted forState:UIControlStateHighlighted];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    _confirmBtn = confirmButton;
}

// 发送验证码
-(void)sendCodeClick{
    NSString *userName = self.userName.text;
//    NSString *userCode = self.userCode.text;
    if (userName.length == 0) {
        [MBProgressHUD showError:@"手机号为空"];
    }else if (![CommonFunc isPhoneValid:userName]){
        [MBProgressHUD showError:@"手机号无效"];
    }else {
        [SMSSDK getVerificationCodeByMethod:(SMSGetCodeMethodSMS) phoneNumber:userName zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                DBLog(@"获取验证码成功");
//                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
                _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate:)userInfo:nil repeats:YES];
                [[NSRunLoop  currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            } else {
                DBLog(@"错误描述：%@",error.debugDescription);
                [MBProgressHUD showError:@"获取验证码失败"];
            }
        }];
    }
}

// 时间更新
-(void)timerUpdate:(NSTimer *)timer{
    static NSInteger count = 60;
    NSString *strCount = [NSString stringWithFormat:@"%ld秒", (long)count];
    if (count-- > 0) {
        [self.sendCodeBtn setTitle:strCount forState:UIControlStateNormal];
    }else{
        [self.sendCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.timer invalidate];
    }
}

// 确认
-(void)confirmClick{
    PwdResetController *pwdVC = [[PwdResetController alloc] init];
    [self.navigationController pushViewController:pwdVC animated:nil];
}
-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
