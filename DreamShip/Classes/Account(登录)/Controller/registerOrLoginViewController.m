//
//  registerOrLoginViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "registerOrLoginViewController.h"
#import "userRegisterInfoView.h"
#import "userLoginInfoView.h"
#import "ForgetPwdViewController.h"
#import "MainNavigationController.h"
#import "RegisterNoticeViewController.h"

#import "DataBaseSharedManager.h"
#import "HttpTool.h"

#import "AccountModel.h"
#import "AccountTool.h"
#import "UIWindow+Extension.h"

#define kRegisterTag 0
#define kLoginTag    1

@interface registerOrLoginViewController()

@property (nonatomic, weak) userRegisterInfoView *userRegisterView;
@property (nonatomic, weak) userLoginInfoView *userLoginView;


@property (nonatomic, weak) UIButton *registerOrLoginButton;
@property (nonatomic, weak) UIButton *changeButton;

@property (nonatomic, weak) UILabel *remind;
@property (nonatomic, weak) UIButton *protocolButton;

@property (nonatomic, assign) BOOL bLogin;

@end
@implementation registerOrLoginViewController

-(id)init{
    self = [super init];
    if (self) {
        if ([AccountTool userTableHasData]) {
            self.bLogin = YES;
        }else{
            self.bLogin = NO;
        }
    }
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [NSThread sleepForTimeInterval:kLaunchImageShowSec];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setSubViews];
}

-(void)setSubViews{
    // Logo
    UILabel *logoTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, kScreenWidth - 20, 30)];
    logoTitle.text = @"梦扬";
    logoTitle.textColor = kTitleDarkBlueColor;
    logoTitle.font = [UIFont systemFontOfSize:28];
    [logoTitle setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:logoTitle];
    
    UILabel *logoDetail1Title = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(logoTitle.frame) + 20, kScreenWidth - 20, 15)];
    logoDetail1Title.text = @"说出梦想";
    logoDetail1Title.textColor = kTitleDarkBlueColor;
    logoDetail1Title.font = [UIFont systemFontOfSize:14];
    [logoDetail1Title setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:logoDetail1Title];
    
    UILabel *logoDetail2Title = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(logoDetail1Title.frame)+5, kScreenWidth - 20, 15)];
    logoDetail2Title.text = @"我们为它扬帆启航";
    logoDetail2Title.textColor = kTitleDarkBlueColor;
    logoDetail2Title.font = [UIFont systemFontOfSize:14];
    [logoDetail2Title setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:logoDetail2Title];
    
    // 注册用户名和密码
    CGFloat userRegisterX = 30;
    userRegisterInfoView *userRegisterView = [[userRegisterInfoView alloc] initWithFrame:CGRectMake(userRegisterX, CGRectGetMaxY(logoDetail2Title.frame) + 30, kScreenWidth - userRegisterX * 2, 90)];
    [self.view addSubview:userRegisterView];
    _userRegisterView = userRegisterView;
    
    // 登录用户名和密码
    AccountModel *model = [AccountTool account];
    userLoginInfoView *userLoginView = [[userLoginInfoView alloc] initWithFrame:CGRectMake(userRegisterX - kScreenWidth, CGRectGetMaxY(logoDetail2Title.frame) + 50, kScreenWidth - userRegisterX * 2, 90)];
    userLoginView.userName.text = model.userPhone;
    userLoginView.userPwd.text = model.userPwd;
    [self.view addSubview:userLoginView];
    _userLoginView = userLoginView;
    
    // 注册和登录按键
    CGFloat rOlButtonX = 30;
    UIButton *registerOrLoginButton = [[UIButton alloc] initWithFrame: CGRectMake(rOlButtonX, CGRectGetMaxY(userRegisterView.frame) + 25, kScreenWidth - 2 * rOlButtonX, 44)];
    registerOrLoginButton.backgroundColor = kButtonBgDarkBlueColor;
    [registerOrLoginButton setTitle:@"注 册" forState:UIControlStateNormal];
    registerOrLoginButton.layer.cornerRadius = 5;
    registerOrLoginButton.tag = kRegisterTag;
    [registerOrLoginButton addTarget:self action:@selector(registOrLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerOrLoginButton];
    _registerOrLoginButton = registerOrLoginButton;

    UILabel *registerProtocolTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(registerOrLoginButton.frame)+5, kScreenWidth - 20, 15)];
    registerProtocolTitle.text = @"点击【注册】按钮，表示您已阅读并同意";
    registerProtocolTitle.textColor = [UIColor lightGrayColor];
    registerProtocolTitle.font = [UIFont systemFontOfSize:14];
    [registerProtocolTitle setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:registerProtocolTitle];
    _remind = registerProtocolTitle;
    
    // 协议按键
    UIButton *protocolButton = [[UIButton alloc] initWithFrame: CGRectMake(100, CGRectGetMaxY(registerProtocolTitle.frame) + 5, kScreenWidth - 2 * 100, 13)];
    [protocolButton setTitleColor:kButtonBgBlueColor forState:UIControlStateNormal];
    [protocolButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [protocolButton setTitle:@"梦扬的协议" forState:UIControlStateNormal];
    protocolButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [protocolButton addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protocolButton];
    _protocolButton = protocolButton;
    
    // 注册和登录切换按键
    UIButton *changeButton = [[UIButton alloc] initWithFrame: CGRectMake(100, CGRectGetMaxY(registerOrLoginButton.frame) + 70, kScreenWidth - 2 * 100, 44)];
    [changeButton setTitleColor:kTitleBlueColor forState:UIControlStateNormal];
    [changeButton setTitle:@"要不去登录？" forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    _changeButton = changeButton;
    
    [self changeClick];
}

// 注册或者登录
-(void)registOrLoginClick{
    if (self.registerOrLoginButton.tag == kRegisterTag) {
        NSString *userName = self.userRegisterView.userName.text;
        NSString *userPwd = self.userRegisterView.userPwd.text;
        NSString *userPwdMd5 = [CommomToolDefine MD5_16:userPwd];
        
        NSLog(@"Register:   name:%@, pwd:%@", userName, userPwd);
        
        if (userName.length == 0) {
            [MBProgressHUD showError:@"手机号不能为空"];
        }else{
            if ([CommonFunc isPhoneValid:userName]) {    // 是否有效手机号
                
                if (userPwd.length == 0) {  // 密码为空
                    [MBProgressHUD showError:@"密码不能为空!"];
                }else if (userPwd.length < 6){ // 密码位数少于6位
                    [MBProgressHUD showError:@"密码至少为6位!"];
                }else{  // 有效
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"api_uid"] = @"users";
                    params[@"api_type"] = @"regUser";
                    params[@"phone"] = userName;
                    params[@"pwd"] = userPwdMd5;
                    
                    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
                        NSString *result = [json[@"result"] stringValue];
                        
                        if ([result isEqualToString:@"200"]) {
                            [self loginIn:userName pwd:userPwdMd5];  //登录
                        }else if ([result isEqualToString:@"201"]){
                            [MBProgressHUD showError:@"当前用户已经存在，请直接登录!"];
                        }else{
                            [MBProgressHUD showError:@"网络错误!"];
                        }
                    } failure:^(NSError *error) {
                        [MBProgressHUD showError:@"网络错误!"];
                    }];
                }
            }else{
                [MBProgressHUD showError:@"输入的手机号无效!"];
                return;
            }
        }
    }else{
        NSLog(@"Login:      name:%@, pwd:%@", self.userLoginView.userName.text, self.userLoginView.userPwd.text);
        NSString *userName = self.userLoginView.userName.text;
        NSString *userPwd = self.userLoginView.userPwd.text;
        
        NSString *userPwdMd5 = [CommomToolDefine MD5_16:userPwd];
        
        if (userName.length == 0) {
            [MBProgressHUD showError:@"请先输入手机号"];
        }else if (userPwd.length == 0){
            [MBProgressHUD showError:@"请输入密码"];
        }else{
            [self loginIn:userName pwd:userPwdMd5];
        }
    }
}

// 登录一下
-(void)loginIn:(NSString *)name pwd:(NSString *)pwd{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"loginIn";
    params[@"phone"] = name;
    params[@"pwd"] = pwd;
    DBLog(@"%@", Host_Url);
    DBLog(@"%@", params);
    
    [MBProgressHUD showMessage:@"正在登录"];
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        NSString *result = [json[@"result"] stringValue];
        NSDictionary *dataDict = json[@"data"];
        
        DBLog(@"%@", json);
        if ([result isEqualToString:@"200"]) {//登录
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:name forKey:@"userPhone"];
            [dict setObject:pwd forKey:@"userPwd"];
            [dict setObject:dataDict[@"mail"] forKey:@"userMail"];
            [dict setObject:dataDict[@"name"] forKey:@"userRealName"];
            [dict setObject:dataDict[@"image"] forKey:@"userImage"];
            [dict setObject:dataDict[@"sex"] forKey:@"userSex"];
            [dict setObject:dataDict[@"id"] forKey:@"userID"];
            [dict setObject:dataDict[@"words"] forKey:@"userWords"];
            [dict setObject:dataDict[@"addr"] forKey:@"userAddr"];
            
            AccountModel *model = [AccountModel accountWithDictionary:dict];
            [AccountTool saveAccount:model];
            
            [self.userLoginView.userName resignFirstResponder];
            [self.userLoginView.userPwd resignFirstResponder];
            [MBProgressHUD hideHUD];
            [kKeyWindow switchRootViewController];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if ([result isEqualToString:@"201"]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"当前用户不存在，请确认!"];
        }else if ([result isEqualToString:@"202"]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"密码错误!"];
        }else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"数据错误!"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

// 扬梦协议
-(void)protocolClick{
    if (self.registerOrLoginButton.tag == kRegisterTag) {
        RegisterNoticeViewController *noticeVC = [[RegisterNoticeViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:noticeVC];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
        ForgetPwdViewController *forgetVC = [[ForgetPwdViewController alloc] init];
        MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:forgetVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

// 切换注册或登录
-(void)changeClick{
    if (self.registerOrLoginButton.tag == kRegisterTag) {
        self.registerOrLoginButton.tag = kLoginTag;
        
        [self.registerOrLoginButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.changeButton setTitle:@"还是注册吧..." forState:UIControlStateNormal];
        [self.protocolButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        self.remind.hidden = YES;
    }else{
        self.registerOrLoginButton.tag = kRegisterTag;
        
        [self.registerOrLoginButton setTitle:@"注册" forState:UIControlStateNormal];
        [self.changeButton setTitle:@"要不去登录？" forState:UIControlStateNormal];
        [self.protocolButton setTitle:@"梦扬的协议" forState:UIControlStateNormal];
        self.remind.hidden = NO;
    }
    
    [self changeRegisterOrLoginView:self.registerOrLoginButton.tag];
}

-(void)changeRegisterOrLoginView:(NSInteger)tag{
    CGFloat offsetX = 0.0;
    if (tag == kRegisterTag) {
        offsetX = 0;
    }else{
        offsetX = kScreenWidth;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.userLoginView.transform = CGAffineTransformMakeTranslation(offsetX, 0);
        self.userRegisterView.transform = CGAffineTransformMakeTranslation(offsetX, 0);
    }];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userRegisterView.userName resignFirstResponder];
    [self.userRegisterView.userPwd resignFirstResponder];
    
    [self.userLoginView.userName resignFirstResponder];
    [self.userLoginView.userPwd resignFirstResponder];
}
@end
