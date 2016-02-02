//
//  SelfInfoSetViewController.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySelectView.h"
#import "RSKImageCropViewController.h"

#define kUpdateUserImage @"UPDATE_USER_IMAGE"

@interface SelfInfoSetViewController : UITableViewController<UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CitySelectViewDelegate, RSKImageCropViewControllerDelegate>

@end
