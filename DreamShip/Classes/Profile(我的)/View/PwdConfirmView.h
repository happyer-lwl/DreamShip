//
//  PwdConfirmView.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PwdConfirmView : UIView<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *userPwd;
@property (nonatomic, weak) UITextField *userPwdConfirm;

@end
