//
//  PersonOtherNameVC.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/21.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUpdateUserRemark @"kUpdateUserRemark"

@class DSUser;
@interface PersonOtherNameVC : UITableViewController<UITextFieldDelegate>

@property (nonatomic, strong) DSUser *user;
@property (nonatomic, copy) NSString *otherName;
@end
