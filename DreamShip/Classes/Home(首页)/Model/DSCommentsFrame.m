//
//  UserFrame.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/6.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DSCommentsFrame.h"
#import "DSUser.h"
#import "DSCommentModel.h"
#import "NSString+Tools.h"

@implementation CommentsFrame

-(void)setComment:(DSCommentModel *)comment{
    _comment = comment;
    
    [self setCommentsFrame:comment];
}

-(void)setCommentsFrame:(DSCommentModel *)comment{
    DSUser *user = comment.user;
    
    CGFloat padding = 10;
    CGFloat bgPadding = 0;
    
    CGFloat imageXY = padding;
    CGFloat imageWH = 44;
    self.imageF = CGRectMake(imageXY, imageXY, imageWH, imageWH);
    
    CGFloat nameX = CGRectGetMaxX(self.imageF) + padding;
    CGFloat nameY = imageXY;
    CGSize  nameSize = [user.name sizeWithFont:kDSUserNameFont];
    self.nameF = (CGRect){{nameX, nameY}, nameSize};
    
    CGFloat timeX = CGRectGetMaxX(self.nameF) + padding;
    CGFloat timeY = imageXY + padding / 2;
    CGSize  timeSize = [comment.time sizeWithFont:kDSUserWordsFont];
    timeSize.width = kScreenWidth - timeX - padding;
    self.timeF = (CGRect){{timeX, timeY}, timeSize};
    
    CGFloat commentX = CGRectGetMaxX(self.imageF) + padding;
    CGFloat commentY = CGRectGetMaxY(self.nameF) + padding/2;
    CGSize  commentSize = [comment.text sizeWithFont:kDSUserWordsFont];
    self.commentF = (CGRect){{commentX, commentY}, commentSize};
    
    CGFloat bgX = 0;
    CGFloat bgY = 0;
    CGFloat bgWidth = kScreenWidth;
    self.bgViewF = CGRectMake(bgX, bgY, bgWidth, MAX(CGRectGetMaxY(self.commentF), CGRectGetMaxY(self.imageF)) + padding);
    
    self.cellHeight = CGRectGetMaxY(self.bgViewF) + bgPadding;
}
@end
