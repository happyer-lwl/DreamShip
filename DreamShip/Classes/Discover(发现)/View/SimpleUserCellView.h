//
//  SimpleUserListView.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/31.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSimpleUserCellHeight 65

@class DSUser;
@interface SimpleUserCellView : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) DSUser *userModel;

@end
