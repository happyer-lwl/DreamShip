//
//  UserModelCell.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/6.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "UserModelCell.h"
#import "UserFrame.h"
#import "DSUser.h"
#import "UIImageView+WebCache.h"

@interface UserModelCell()

@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel     *nameLabel;
@property (nonatomic, weak) UILabel     *wordsLabel;

@end

@implementation UserModelCell

-(void)setUserFrame:(UserFrame *)userFrame{
    _userFrame = userFrame;
    
    self.bgView.frame = userFrame.bgViewF;
    
    self.iconView.frame = userFrame.imageF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString: userFrame.user.image] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    
    self.nameLabel.frame = userFrame.nameF;
    self.nameLabel.text = userFrame.user.userRealName;
    
    self.wordsLabel.frame = userFrame.wordsF;
    self.wordsLabel.text = userFrame.user.userWords;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"user";
    
    UserModelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UserModelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    self.bgView = bgView;
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = 22;
    [self.bgView addSubview:iconView];
    self.iconView = iconView;
    
    // 名字
    UILabel *nameText = [[UILabel alloc] init];
    nameText.font = kDSUserNameFont;
    nameText.textColor = kTitleBlueColor;
    [self.bgView addSubview:nameText];
    self.nameLabel = nameText;
    
    // 签名
    UILabel *wordsLabel = [[UILabel alloc] init];
    wordsLabel.font = kDSUserWordsFont;
    wordsLabel.textColor = [UIColor grayColor];
    [self.bgView addSubview:wordsLabel];
    self.wordsLabel = wordsLabel;
}
@end
