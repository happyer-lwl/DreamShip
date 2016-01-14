//
//  DSCommentCellTableViewCell.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/8.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentsFrame;
@interface DSCommentCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) CommentsFrame *commentFrame;

@end
