//
//  DSDreamFrame.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/22.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "DSDreamFrame.h"
#import "DSDreamModel.h"
#import "DSUser.h"
#import "NSString+Tools.h"

@implementation DSDreamFrame

-(void)setDream:(DSDreamModel *)dream{
    _dream = dream;
    
    [self setDreamFrame:dream];
}

-(void)setDreamFrame:(DSDreamModel *)dream{
    DSUser *user = dream.user;
    CGFloat padding = 10;
    CGFloat bgPadding = 10;
    
    CGFloat imageXY = padding;
    CGFloat imageWH = 44;
    self.imageF = CGRectMake(imageXY, imageXY, imageWH, imageWH);
    
    CGFloat nameX = CGRectGetMaxX(self.imageF) + padding;
    CGFloat nameY = imageXY;
    CGSize  nameSize = [user.name sizeWithFont:kDSDreamCellNameFont];
    self.nameF = (CGRect){{nameX, nameY}, nameSize};
    
    CGFloat timeX = CGRectGetMaxX(self.imageF) + padding;
    CGFloat timeY = CGRectGetMaxY(self.nameF) + padding/2;
    CGSize  timeSize = [dream.time sizeWithFont:kDSDreamCellTimeFont];
    self.timeF = (CGRect){{timeX, timeY}, timeSize};
    
    CGFloat typeX = CGRectGetMaxX(self.timeF) + padding;
    CGFloat typeY = timeY;
    CGSize  typeSize = [dream.type sizeWithFont:kDSDreamCellSourceFont];
    self.typeF = (CGRect){{typeX, typeY}, typeSize};
    
    CGFloat textX = padding;
    CGFloat textY = MAX(CGRectGetMaxY(self.imageF), CGRectGetMaxY(self.timeF)) + padding / 2;
    NSMutableDictionary *attriText = [NSMutableDictionary dictionary];
    attriText[NSFontAttributeName] = kDSDreamCellContentFont;
    CGRect textRect = [dream.text textRectWithSize:CGSizeMake(kScreenWidth - 2*bgPadding, MAXFLOAT) attributes:attriText];
    textRect.origin.x = textX;
    textRect.origin.y = textY;
    self.textF = textRect;
    
    CGFloat toolBarX = 0;
    CGFloat toolBarY = CGRectGetMaxY(self.textF) + padding;
    CGFloat toolBarW = kScreenWidth;
    CGFloat toolBarH = 35;
    self.toolBarF = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    CGFloat bgX = 0;
    CGFloat bgY = 0;
    CGFloat bgWidth = kScreenWidth;
    self.bgViewF = CGRectMake(bgX, bgY, bgWidth, CGRectGetMaxY(self.toolBarF));
    
    self.cellHeight = CGRectGetMaxY(self.bgViewF) + 10;
}
@end
