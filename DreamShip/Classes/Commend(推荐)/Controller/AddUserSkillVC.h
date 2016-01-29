//
//  AddUserSkillVC.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/27.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLCropImageViewController.h"

#define kGetUserSkills @"kGetUserSkills"

@class UserSkillModel;

@interface AddUserSkillVC : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, clCropImageViewControllerDlegate>

@property (nonatomic, strong) UserSkillModel *userSkillModel;

@end
