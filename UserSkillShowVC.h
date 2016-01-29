//
//  UserSkillShowVC.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/22.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserSkillModel;
@interface UserSkillShowVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UserSkillModel *userSkill;

@end
