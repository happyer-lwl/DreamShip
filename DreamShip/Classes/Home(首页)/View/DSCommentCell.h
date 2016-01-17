//
//  DSCommentCellTableViewCell.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/8.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentsFrame;

@protocol CommentModelCellDelegate <NSObject>
-(void)commentCellUserIconClicked:(CommentsFrame*)commentsFrame;
@end


@interface DSCommentCell : UITableViewCell

@property (nonatomic, strong) CommentsFrame *commentFrame;
@property (nonatomic, weak) id<CommentModelCellDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
