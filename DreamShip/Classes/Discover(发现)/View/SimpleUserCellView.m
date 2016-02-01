//
//  SimpleUserListView.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/31.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "SimpleUserCellView.h"

#import "UIImageView+WebCache.h"

#import "DSUser.h"

@interface SimpleUserCellView()

@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel     *nameLabel;

@end

@implementation SimpleUserCellView

-(void)setUserModel:(DSUser *)userModel{
    _userModel = userModel;
    
    [self.iconView sd_setImageWithURL:userModel.image placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    self.nameLabel.text = userModel.userRealName;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    NSString *ID = @"simpleUser";
    
    SimpleUserCellView *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SimpleUserCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSubviewsInfo];
    }
    
    return self;
}

-(void)setSubviewsInfo{
    CGFloat padding = 10.0;
    
    CGFloat cellHeight = kSimpleUserCellHeight;
    CGFloat cellWidth = kScreenWidth;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    _bgView = bgView;
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.frame = CGRectMake(padding, padding, kSimpleUserCellHeight - 20, kSimpleUserCellHeight - 20);
    iconView.layer.cornerRadius = 2;
    [self.bgView addSubview:iconView];
    self.iconView = iconView;
    
    // 名字
    UILabel *nameText = [[UILabel alloc] init];
    nameText.frame = CGRectMake(CGRectGetMaxX(iconView.frame) + padding, 2 * padding, cellWidth - CGRectGetMaxX(iconView.frame) - 2 * padding, 25);
    nameText.font = kDSUserNameFont;
    nameText.textColor = kTitleFireColorNormal;
    [self.bgView addSubview:nameText];
    self.nameLabel = nameText;
}
@end
