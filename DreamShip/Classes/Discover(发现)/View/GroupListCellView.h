//
//  GroupListCellView.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/2/1.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGroupListCellHeight 65

@class UserGroupModel;
@interface GroupListCellView : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UserGroupModel *groupModel;

@end
