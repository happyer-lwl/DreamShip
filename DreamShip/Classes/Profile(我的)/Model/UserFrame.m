//
//  UserFrame.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/6.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "UserFrame.h"
#import "DSUser.h"
#import "NSString+Tools.h"

@implementation UserFrame

-(void)setUser:(DSUser *)user{
    _user = user;
    
    [self setUserFrame:user];
}

-(void)setUserFrame:(DSUser *)user{
    CGFloat padding = 10;
    CGFloat bgPadding = 0;
    
    CGFloat imageXY = padding;
    CGFloat imageWH = 44;
    self.imageF = CGRectMake(imageXY, imageXY, imageWH, imageWH);
    
    CGFloat nameX = CGRectGetMaxX(self.imageF) + padding;
    CGFloat nameY = imageXY;
    CGSize  nameSize = [user.name sizeWithFont:kDSUserNameFont];
    self.nameF = (CGRect){{nameX, nameY}, nameSize};
    
    CGFloat wordsX = CGRectGetMaxX(self.imageF) + padding;
    CGFloat wordsY = CGRectGetMaxY(self.nameF) + padding/2;
    CGSize  wordsSize = [user.userWords sizeWithFont:kDSUserWordsFont];
    self.wordsF = (CGRect){{wordsX, wordsY}, wordsSize};
    
    CGFloat bgX = 0;
    CGFloat bgY = 0;
    CGFloat bgWidth = kScreenWidth;
    self.bgViewF = CGRectMake(bgX, bgY, bgWidth, MAX(CGRectGetMaxY(self.wordsF), CGRectGetMaxY(self.imageF)) + padding);
    
    self.cellHeight = CGRectGetMaxY(self.bgViewF) + bgPadding;
}
@end
