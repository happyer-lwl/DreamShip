//
//  userRegisterLoginInfo.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/18.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userRegisterInfoView : UIView<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *userName;
@property (nonatomic, weak) UITextField *userPwd;

@end
