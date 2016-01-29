//
//  UserSkillCellView.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/22.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSkillCellHeight 80

@class UserSkillModel;

@interface UserSkillCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UserSkillModel *userSkillModel;

@end
