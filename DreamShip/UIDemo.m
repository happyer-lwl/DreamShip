//
//  UIDemo.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 UITextField  2   userName & userPwd
 */
//-(id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//        
//        [self setupTextFieldNameAndPwd];
//    }
//    
//    return self;
//}
//
///**
// * 设置用户名密码
// */
//-(void)setupTextFieldNameAndPwd{
//    CGFloat viewWidth = self.width;
//    CGFloat cellHeight = (self.height - 2) / 2;
//    
//    // 用户手机号
//    UITextField *name = [[UITextField alloc] init];
//    name.frame = CGRectMake(0, 0, viewWidth, cellHeight);
//    name.placeholder = @"新密码";
//    name.font = [UIFont systemFontOfSize:16];
//    name.backgroundColor = [UIColor whiteColor];
//    name.clearButtonMode = UITextFieldViewModeWhileEditing;
//    name.keyboardType = UIKeyboardTypePhonePad;
//    _userPwd = name;
//    [self addSubview:name];
//    name.delegate = self;
//    
//    // 密码
//    UITextField *pwd = [[UITextField alloc] init];
//    pwd.frame = CGRectMake(0, cellHeight + 1, viewWidth, cellHeight);
//    pwd.placeholder = @"重新输入密码";
//    pwd.font = [UIFont systemFontOfSize:16];
//    pwd.backgroundColor = [UIColor whiteColor];
//    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
//    pwd.keyboardType = UIKeyboardTypeASCIICapable;
//    pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    _userPwdConfirm = pwd;
//    [self addSubview:pwd];
//    pwd.delegate = self;
//}
//
//// 分割线
//-(void)drawRect:(CGRect)rect{
//    CGFloat viewWidth = self.width;
//    CGFloat cellHeight = (self.height - 2) / 2;
//    
//    CGContextRef cts = UIGraphicsGetCurrentContext();
//    
//    CGPoint line1Start = CGPointMake(0, cellHeight + 1);
//    CGPoint line1End = CGPointMake(viewWidth, cellHeight + 1);
//    CGPoint line2Start = CGPointMake(0, cellHeight * 2 + 1);
//    CGPoint line2End = CGPointMake(viewWidth, cellHeight * 2 + 1);
//    
//    UIBezierPath *line1 = [UIBezierPath bezierPath];
//    [line1 moveToPoint:line1Start];
//    [line1 addLineToPoint:line1End];
//    CGContextAddPath(cts, line1.CGPath);
//    
//    UIBezierPath *line2 = [UIBezierPath bezierPath];
//    [line2 moveToPoint:line2Start];
//    [line2 addLineToPoint:line2End];
//    CGContextAddPath(cts, line2.CGPath);
//    
//    CGContextSetLineWidth(cts, 0.5);
//    CGContextSetRGBStrokeColor(cts, 186/255.0, 186/255.0, 193/255.0, 1.0);
//    CGContextStrokePath(cts);
//}
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.userPwd resignFirstResponder];
//    [self.userPwdConfirm resignFirstResponder];
//    
//    return YES;
//}


/**
 UIButton
 */
//UIButton *changeButton = [[UIButton alloc] initWithFrame: CGRectMake(100, CGRectGetMaxY(registerOrLoginButton.frame) + 70, kScreenWidth - 2 * 100, 44)];
//[changeButton kTitleFireColorNormal forState:UIControlStateNormal];
//[changeButton setTitle:@"要不去登录？" forState:UIControlStateNormal];
//[changeButton addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];
//[self.view addSubview:changeButton];
//_changeButton = changeButton;


//UILabel *logoDetail1Title = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(logoTitle.frame) + 20, kScreenWidth - 20, 15)];
//logoDetail1Title.text = @"说出梦想";
//logoDetail1Title.textColor = kTitleFireColorNormal;
//logoDetail1Title.font = [UIFont systemFontOfSize:14];
//[logoDetail1Title setTextAlignment:NSTextAlignmentCenter];
//[self.view addSubview:logoDetail1Title];



// UIBarButtonItem
//UIBarButtonItem *leftButtonItem = [UIBarButtonItem itemWithAction:@selector(backToPre) target:self image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
//
//UIBarButtonItem *rightButtonItem = [UIBarButtonItem itemWithAction:@selector(backToMain) target:self image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
//
//viewController.navigationItem.leftBarButtonItem = leftButtonItem;
//viewController.navigationItem.rightBarButtonItem = rightButtonItem;


// 带属性的文本
/*
NSString *prefix = @"追逐梦想";
if (name) {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.width = 200;
    titleLabel.height = 50;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    
    NSString *titleStr = [NSString stringWithFormat:@"%@\n%@", @"追逐梦想", name];
    // 创建一个带有属性的字符串
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:titleStr];
    
    // 添加一个属性
    [attriText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range: [titleStr rangeOfString:prefix]];
    [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range: [titleStr rangeOfString:name]];
    [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[titleStr rangeOfString:name]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = kViewBgColor;
    shadow.shadowOffset = CGSizeMake(0.5, 0.5 );
    shadow.shadowBlurRadius = 0.2;
    [attriText addAttribute:NSShadowAttributeName value:shadow range:[titleStr rangeOfString:name]];
    titleLabel.attributedText = attriText;
    
    self.navigationItem.titleView = titleLabel;
}else{
    self.title = prefix;
}
*/
