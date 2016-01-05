//
//  DSHomeViewCell.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/22.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "DSHomeViewCell.h"
#import "DSDreamFrame.h"
#import "DSDreamModel.h"
#import "DSUser.h"
#import "ToolBarView.h"
#import "CommomToolDefine.h"

#import "UIImageView+WebCache.h"

@interface DSHomeViewCell()

@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel     *nameLabel;
@property (nonatomic, weak) UILabel     *timeLabel;
@property (nonatomic, weak) UILabel     *typeLabel;
@property (nonatomic, weak) UILabel     *contentTextLabel;

@property (nonatomic, weak) ToolBarView *toolBar;

@end

@implementation DSHomeViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"home";
    
    DSHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[DSHomeViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    // 背景白
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgImageView];
    self.bgView = bgImageView;
    
    // 头像
    UIImageView *imageV = [[UIImageView alloc] init];
    [self.bgView addSubview:imageV];
    self.iconView.backgroundColor = [UIColor whiteColor];
    self.iconView = imageV;
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = kTitleBlueColor;
    nameLabel.font = kDSDreamCellNameFont;
    [self.bgView addSubview:nameLabel];
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    self.nameLabel = nameLabel;
    
    // 时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = kDSDreamCellTimeFont;
    [self.bgView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 类型
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.textColor = [UIColor grayColor];
    typeLabel.font = kDSDreamCellSourceFont;
    [self.bgView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    // 内容
    UILabel *textL = [[UILabel alloc] init];
    textL.numberOfLines = 0;
    textL.textColor = [UIColor blackColor];
    textL.font = kDSDreamCellContentFont;
    [self.bgView addSubview:textL];
    self.contentTextLabel = textL;
    
    [self.contentView addSubview:self.bgView];
    
    // 工具栏
    ToolBarView *toolBar = [ToolBarView toolBar];
    toolBar.delegate = self;
    self.toolBar = toolBar;
    
    [self.contentView addSubview:self.toolBar];
}

-(void)setDreamFrame:(DSDreamFrame *)dreamFrame{
    _dreamFrame = dreamFrame;
    
    DSDreamModel *dream = dreamFrame.dream;
    DSUser *user = dream.user;
    
    self.bgView.frame = dreamFrame.bgViewF;
    
    self.iconView.frame = dreamFrame.imageF;
    
    if (user.image.length) {
        //[UIImageView setImageForImageView:self.iconView imageURL:[NSURL URLWithString:user.image]];
        [self.iconView sd_setImageWithURL:user.image placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    }else{
        self.iconView.image = [UIImage imageNamed:@"avatar_default_big"];
    }
    
    self.nameLabel.frame = dreamFrame.nameF;
    self.nameLabel.text = user.name;
    
    self.timeLabel.frame = dreamFrame.timeF;
    self.timeLabel.text =  dream.time;
    
    self.typeLabel.frame = dreamFrame.typeF;
    self.typeLabel.text = dream.type;
    
    self.contentTextLabel.frame = dreamFrame.textF;
    self.contentTextLabel.text = dream.text;
    
    self.toolBar.frame = dreamFrame.toolBarF;
    self.toolBar.curDream = dream;
}

-(void)DSToolBarClickedWithTag:(NSInteger)tag {
    if ([self.delegate respondsToSelector:@selector(cellToolBarClickedWithTag:dreamFrame:)]) {
        [self.delegate cellToolBarClickedWithTag:tag dreamFrame: self.dreamFrame];
    }
}
@end
