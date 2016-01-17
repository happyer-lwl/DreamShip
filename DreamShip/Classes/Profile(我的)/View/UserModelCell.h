//
//  UserModelCell.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/6.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserFrame;

@protocol UserModelCellDelegate <NSObject>

-(void)cellUserIconClickedWithUserFrame:(UserFrame*)userFrame;

@end

@interface UserModelCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UserFrame *userFrame;
@property (nonatomic, weak) id<UserModelCellDelegate> delegate;

@end
