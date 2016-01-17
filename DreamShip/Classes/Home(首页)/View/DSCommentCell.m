//
//  DSCommentCellTableViewCell.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/8.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DSCommentCell.h"
#import "DSUser.h"
#import "DSCommentModel.h"
#import "DSCommentsFrame.h"
#import "UIImageView+WebCache.h"

@interface DSCommentCell()

@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel     *nameLabel;
@property (nonatomic, weak) UILabel     *timeLabel;
@property (nonatomic, weak) UILabel     *commentLabel;

@end
@implementation DSCommentCell

-(void)setCommentFrame:(CommentsFrame *)commentFrame{
    _commentFrame = commentFrame;
    DSUser *user = commentFrame.comment.user;
    
    self.iconView.frame = commentFrame.imageF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    self.nameLabel.frame = commentFrame.nameF;
    self.nameLabel.text = user.name;

    self.timeLabel.frame = commentFrame.timeF;
    self.timeLabel.text = commentFrame.comment.time;
    
    self.commentLabel.frame = commentFrame.commentF;
    self.commentLabel.text = commentFrame.comment.text;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"comment";
    
    DSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DSCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setCellFrame];
    }
    
    return self;
}

-(void)setCellFrame{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    self.bgView = bgView;
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.bgView addSubview:iconView];
    self.iconView = iconView;
    self.iconView.layer.cornerRadius = 22;
    self.iconView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comment_user_icon_click)];
    singleFingerOne.numberOfTapsRequired = 1; //Tap数
    singleFingerOne.numberOfTouchesRequired = 1; // 手指数
    singleFingerOne.delegate = self;
    [self.iconView addGestureRecognizer:singleFingerOne];
    
    // 名字
    UILabel *nameText = [[UILabel alloc] init];
    nameText.font = kDSUserNameFont;
    nameText.textColor = kTitleDarkBlueColor;
    [self.bgView addSubview:nameText];
    self.nameLabel = nameText;
    self.nameLabel.userInteractionEnabled = YES;
    
    
    // 时间
    UILabel *timeText = [[UILabel alloc] init];
    timeText.font = kDSUserWordsFont;
    timeText.textColor = [UIColor lightGrayColor];
    [timeText setTextAlignment:NSTextAlignmentRight];
    [self.bgView addSubview:timeText];
    self.timeLabel = timeText;
    
    // 评论
    UILabel *wordsLabel = [[UILabel alloc] init];
    wordsLabel.font = kDSUserWordsFont;
    wordsLabel.textColor = [UIColor grayColor];
    [self.bgView addSubview:wordsLabel];
    self.commentLabel = wordsLabel;
}

-(void)comment_user_icon_click{
    DBLog(@"Comment cell user icon");
    if ([self.delegate respondsToSelector:@selector(commentCellUserIconClicked:)]) {
        [self.delegate commentCellUserIconClicked:self.commentFrame];
    }
}
@end
