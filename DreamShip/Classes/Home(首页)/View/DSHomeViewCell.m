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
@property (nonatomic, weak) UIImageView *picView;

@property (nonatomic, weak) UIButton    *collectionView;

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
    bgImageView.layer.cornerRadius = 5;
    bgImageView.userInteractionEnabled = YES;
    self.bgView = bgImageView;
    
    // 头像
    UIImageView *imageV = [[UIImageView alloc] init];
    [self.bgView addSubview:imageV];
    self.iconView = imageV;
    self.iconView.backgroundColor = [UIColor whiteColor];
    self.iconView.userInteractionEnabled = YES;
   
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(user_icon_click)];
    singleFingerOne.numberOfTapsRequired = 1; //Tap数
    singleFingerOne.numberOfTouchesRequired = 1; // 手指数
    singleFingerOne.delegate = self;
    [self.iconView addGestureRecognizer:singleFingerOne];
    
    // 昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = kTitleDarkBlueColor;
    nameLabel.font = kDSDreamCellNameFont;
    [self.bgView addSubview:nameLabel];
    self.nameLabel.backgroundColor = [UIColor whiteColor];
    self.nameLabel = nameLabel;
    
    // 收藏
    UIButton *collectionBtn = [[UIButton alloc] init];
    [collectionBtn setImage:[UIImage imageNamed:@"dream_collection"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"dream_collection_selected"] forState:UIControlStateSelected];
    [collectionBtn addTarget:self action:@selector(collectionClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:collectionBtn];
    self.collectionView = collectionBtn;
    
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
    
    // 图片
    UIImageView *pic = [[UIImageView alloc] init];
    pic.backgroundColor = kViewBgColor;
    [self.bgView addSubview:pic];
    self.picView = pic;
    pic.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleFingerOnePhotoView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoView_click)];
    singleFingerOnePhotoView.numberOfTapsRequired = 1; //Tap数
    singleFingerOnePhotoView.numberOfTouchesRequired = 1; // 手指数
    singleFingerOnePhotoView.delegate = self;
    [self.picView addGestureRecognizer:singleFingerOnePhotoView];

    
    [self.contentView addSubview:self.bgView];
    
    // 工具栏
    ToolBarView *toolBar = [ToolBarView toolBar];
    toolBar.delegate = self;
    self.toolBar = toolBar;
    self.toolBar.layer.cornerRadius = 5;
    [self.contentView addSubview:self.toolBar];
}

-(void)setDreamFrame:(DSDreamFrame *)dreamFrame{
    _dreamFrame = dreamFrame;
    
    DSDreamModel *dream = dreamFrame.dream;
    DSUser *user = dream.user;
    
    self.bgView.frame = dreamFrame.bgViewF;
    
    self.iconView.frame = dreamFrame.imageF;
    
    if (user.image.length) {
        [self.iconView sd_setImageWithURL:user.image placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    }else{
        self.iconView.image = [UIImage imageNamed:@"avatar_default_big"];
    }
    
    self.nameLabel.frame = dreamFrame.nameF;
    self.nameLabel.text = user.userRealName;
    
    self.collectionView.frame = dreamFrame.collectionF;
    if ([dream.collection isEqualToString:@"1"]) {
        self.collectionView.selected = YES;
    }else{
        self.collectionView.selected = NO;
    }
    
    self.timeLabel.frame = dreamFrame.timeF;
    self.timeLabel.text =  dream.time;
    
    self.typeLabel.frame = dreamFrame.typeF;
    self.typeLabel.text = dream.type;
    
    self.contentTextLabel.frame = dreamFrame.textF;
    self.contentTextLabel.text = dream.text;
    
    self.picView.frame = dreamFrame.picF;
    if (dream.pic_url.length) {
        [self.picView sd_setImageWithURL:[NSURL URLWithString:dream.pic_url] placeholderImage:[UIImage imageNamed:@"actionbar_picture_icon@3x"]];
    }
    
    self.toolBar.frame = dreamFrame.toolBarF;
    self.toolBar.curDream = dream;
}

/**
 *  toolbar按键回调
 *
 *  @param tag        按键tag
 *  @param dreamModel 数据模型
 */
-(void)DSToolBarClickedWithTag:(NSInteger)tag dreamModel:(DSDreamModel *)dreamModel {
    DBLog(@"cellToolButton  %ld", tag);
    self.dreamFrame.dream = dreamModel;
    
    if ([self.delegate respondsToSelector:@selector(cellToolBarClickedWithTag:dreamFrame:)]) {
        [self.delegate cellToolBarClickedWithTag:tag dreamFrame: self.dreamFrame];
    }
}

/**
 *  头像回调
 */
-(void)user_icon_click{
    DBLog(@"User Icon");
    if ([self.delegate respondsToSelector:@selector(cellUserIconClicked:)]) {
        [self.delegate cellUserIconClicked:self.dreamFrame];
    }
}

-(void)photoView_click{
    DBLog(@"photo");
    if ([self.delegate respondsToSelector:@selector(cellPhotoViewClicked:)]) {
        [self.delegate cellPhotoViewClicked:self.dreamFrame];
    }
}

-(void)collectionClick:(UIButton *)sender{
    if (sender.selected) {
        DBLog(@"collection yes");
    }else{
        DBLog(@"collection no");
    }
    if ([self.delegate respondsToSelector:@selector(cellCollectionClicked:state:)]) {
        [self.delegate cellCollectionClicked:self.dreamFrame state:sender.selected];
    }
}
@end
