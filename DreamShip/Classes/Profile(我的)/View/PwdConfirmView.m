//
//  PwdConfirmView.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "PwdConfirmView.h"

@implementation PwdConfirmView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupTextFieldNameAndPwd];
    }
    
    return self;
}

/**
 * 设置用户名密码
 */
-(void)setupTextFieldNameAndPwd{
    CGFloat viewWidth = self.width;
    CGFloat cellHeight = (self.height - 2) / 2;
    
    // 用户手机号
    UITextField *name = [[UITextField alloc] init];
    name.frame = CGRectMake(0, 0, viewWidth, cellHeight);
    name.placeholder = @"新密码";
    name.font = [UIFont systemFontOfSize:16];
    name.backgroundColor = [UIColor whiteColor];
    name.clearButtonMode = UITextFieldViewModeWhileEditing;
    name.keyboardType = UIKeyboardTypeDefault;
    name.secureTextEntry = YES;
    name.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userPwd = name;
    [self addSubview:name];
    name.delegate = self;
    
    // 密码
    UITextField *pwd = [[UITextField alloc] init];
    pwd.frame = CGRectMake(0, cellHeight + 1, viewWidth, cellHeight);
    pwd.placeholder = @"重新输入密码";
    pwd.font = [UIFont systemFontOfSize:16];
    pwd.backgroundColor = [UIColor whiteColor];
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwd.keyboardType = UIKeyboardTypeDefault;
    pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwd.secureTextEntry = YES;
    _userPwdConfirm = pwd;
    [self addSubview:pwd];
    pwd.delegate = self;
}

// 分割线
-(void)drawRect:(CGRect)rect{
    CGFloat viewWidth = self.width;
    CGFloat cellHeight = (self.height - 2) / 2;
    
    CGContextRef cts = UIGraphicsGetCurrentContext();
    
    CGPoint line1Start = CGPointMake(0, cellHeight + 1);
    CGPoint line1End = CGPointMake(viewWidth, cellHeight + 1);
    CGPoint line2Start = CGPointMake(0, cellHeight * 2 + 1);
    CGPoint line2End = CGPointMake(viewWidth, cellHeight * 2 + 1);
    
    UIBezierPath *line1 = [UIBezierPath bezierPath];
    [line1 moveToPoint:line1Start];
    [line1 addLineToPoint:line1End];
    CGContextAddPath(cts, line1.CGPath);
    
    UIBezierPath *line2 = [UIBezierPath bezierPath];
    [line2 moveToPoint:line2Start];
    [line2 addLineToPoint:line2End];
    CGContextAddPath(cts, line2.CGPath);
    
    CGContextSetLineWidth(cts, 0.5);
    CGContextSetRGBStrokeColor(cts, 186/255.0, 186/255.0, 193/255.0, 1.0);
    CGContextStrokePath(cts);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.userPwd resignFirstResponder];
    [self.userPwdConfirm resignFirstResponder];
    
    return YES;
}

@end
