//
//  UserSkillCellView.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/22.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "UserSkillCell.h"
#import "UserSkillModel.h"
#import "UserSkillShowVC.h"
#import "UIImageView+WebCache.h"
#import "DSUser.h"

// 昵称字体
#define kSkillUserNameFont [UIFont boldSystemFontOfSize:20]
// 技能字体
#define kSkillUserSkillTitleFont    [UIFont systemFontOfSize:16]
#define kSkillUserSkillContentFont  [UIFont systemFontOfSize:14]

@interface UserSkillCell()

@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel     *nameLabel;
@property (nonatomic, weak) UILabel     *skillTitleLabel;
@property (nonatomic, weak) UILabel     *skillLabel;

@end

@implementation UserSkillCell

-(void)setUserSkillModel:(UserSkillModel *)userSkillModel{
    _userSkillModel = userSkillModel;
    DSUser *user = _userSkillModel.user;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.nameLabel.text = user.userRealName;
    self.skillLabel.text = _userSkillModel.skills;
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"skill";
    
    UserSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UserSkillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setSubviewsInfo];
    }
    
    return self;
}

-(void)setSubviewsInfo{
    CGFloat padding = 10.0;
    
    CGFloat cellHeight = kSkillCellHeight;
    CGFloat cellWidth = kScreenWidth;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    _bgView = bgView;
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.frame = CGRectMake(padding, padding, kSkillCellHeight - 20, kSkillCellHeight - 20);
    iconView.layer.cornerRadius = 2;
    [self.bgView addSubview:iconView];
    self.iconView = iconView;
    
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(user_icon_click)];
    singleFingerOne.numberOfTapsRequired = 1; //Tap数
    singleFingerOne.numberOfTouchesRequired = 1; // 手指数
    singleFingerOne.delegate = self;
    [self.iconView addGestureRecognizer:singleFingerOne];
    
    // 名字
    UILabel *nameText = [[UILabel alloc] init];
    nameText.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + padding, 1 * padding, cellWidth - CGRectGetMaxX(iconView.frame) - 2 * padding, 25);
    nameText.font = kSkillUserNameFont;
    nameText.textColor = kTitleFireColorNormal;
    [self.bgView addSubview:nameText];
    self.nameLabel = nameText;
    
    // 技能Title
    UILabel *skillLabelTitle = [[UILabel alloc] init];
    skillLabelTitle.frame = CGRectMake(1.02 * nameText.x, CGRectGetMaxY(nameText.frame) + padding, 40, 30);
    skillLabelTitle.font = kSkillUserSkillTitleFont;
    skillLabelTitle.textColor = kTitleFireColorNormal;
    skillLabelTitle.text = @"技能:";
    [self.bgView addSubview:skillLabelTitle];
    self.skillTitleLabel = skillLabelTitle;
    
    // 技能
    UILabel *skillLabel = [[UILabel alloc] init];
    skillLabel.frame = CGRectMake(CGRectGetMaxX(skillLabelTitle.frame), skillLabelTitle.y, cellWidth - CGRectGetMaxX(skillLabelTitle.frame) - padding, 30);
    skillLabel.font = kSkillUserSkillContentFont;
    skillLabel.textColor = [UIColor grayColor];
    [self.bgView addSubview:skillLabel];
    self.skillLabel = skillLabel;
}
@end
