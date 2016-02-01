//
//  GroupListCellView.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/2/1.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "GroupListCellView.h"

#import "UserGroupModel.h"

#import "UIImageView+WebCache.h"


@interface GroupListCellView()

@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *briefLabel;

@end

@implementation GroupListCellView

-(void)setGroupModel:(UserGroupModel *)groupModel{
    _groupModel = groupModel;
    
    _iconView.image = [UIImage imageNamed:@"team"];
    
    _nameLabel.text = groupModel.name;
    
    _briefLabel.text = groupModel.brief;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"groupList";
    
    GroupListCellView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[GroupListCellView alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellSubviews];
    }
    
    return self;
}

-(void)initCellSubviews{
    CGFloat padding = 10.0;
    
    CGFloat cellHeight = kGroupListCellHeight;
    CGFloat cellWidth = kScreenWidth;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    _bgView = bgView;
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.frame = CGRectMake(padding, padding, kGroupListCellHeight - 20, kGroupListCellHeight - 20);
    iconView.layer.cornerRadius = 2;
    [self.bgView addSubview:iconView];
    self.iconView = iconView;
    
    // 名字
    UILabel *nameText = [[UILabel alloc] init];
    nameText.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + padding, padding, cellWidth - CGRectGetMaxX(iconView.frame) - 2 * padding, 20);
    nameText.font = kDSUserNameFont;
    nameText.textColor = kTitleFireColorNormal;
    [self.bgView addSubview:nameText];
    self.nameLabel = nameText;
    
    // 技能Title
    UILabel *briefLabel = [[UILabel alloc] init];
    briefLabel.frame = CGRectMake(1.02 * nameText.x, CGRectGetMaxY(nameText.frame) + padding/2, kScreenWidth - self.nameLabel.x - padding, 20);
    briefLabel.font = kDSUserWordsFont;
    briefLabel.textColor = [UIColor grayColor];
    [self.bgView addSubview:briefLabel];
    self.briefLabel = briefLabel;
}

@end
