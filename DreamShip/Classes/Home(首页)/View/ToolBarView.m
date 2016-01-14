//
//  ToolBarView.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/3.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "ToolBarView.h"
#import "DSDreamModel.h"
#import "DSDreamFrame.h"

#import "AccountTool.h"
#import "AccountModel.h"
#import "HttpTool.h"
#import "MJExtension.h"

@interface ToolBarView()

@property (nonatomic, strong) NSMutableArray *toolButtons;

@property (nonatomic, weak) UIButton *supportButton;
@property (nonatomic, weak) UIButton *unSupportButton;
@property (nonatomic, weak) UIButton *commentButton;

@end

@implementation ToolBarView

+(instancetype)toolBar{
    return [[self alloc] init];
}

-(NSMutableArray *)toolButtons{
    if (_toolButtons == nil) {
        _toolButtons = [NSMutableArray array];
    }
    
    return _toolButtons;
}

-(void)setCurDream:(DSDreamModel *)curDream{
    _curDream = curDream;
    
    [self setButtonCount:_curDream.support_count button:self.supportButton title:@"赞"];
    [self setButtonCount:_curDream.unsupport_count button:self.unSupportButton title:@"喷"];
    [self setButtonCount:_curDream.comment_count button:self.commentButton title:@"指点"];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        self.backgroundColor = kViewBgColor;
        
        self.supportButton = [self setToolButtonWithTitle:@"赞" icon:@"toolbar_icon_like" tag:kTagSupport];
        self.unSupportButton = [self setToolButtonWithTitle:@"喷" icon:@"toolbar_icon_unlike" tag:kTagUnSupport];
        self.commentButton = [self setToolButtonWithTitle:@"指点" icon:@"timeline_icon_comment" tag:kTagComment];
    }
    
    return self;
}
/**
 *  设置按键标题和icon tag
 *
 *  @param title 标题
 *  @param icon  icon
 *  @param tag   tag
 *
 *  @return <#return value description#>
 */
-(UIButton *)setToolButtonWithTitle:(NSString *)title icon:(NSString *)icon tag:(NSInteger)tag{
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", icon]] forState:UIControlStateSelected];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    btn.tag = tag;
    
    //btn.backgroundColor = color;
//    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(toolBarClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolButtons addObject:btn];
    
    [self addSubview:btn];
    
    return btn;
}
/**
 *  ToolBar按下
 *
 *  @param button <#button description#>
 */
-(void)toolBarClicked:(UIButton *)button{
    DBLog(@"toolButton  %ld", button.tag);
    
    switch (button.tag) {
        case kTagSupport:
            [self supportDreamWithType:kTagSupport];
            break;
        case kTagUnSupport:
            [self supportDreamWithType:kTagUnSupport];
            break;
        case kTagComment:
            if ([self.delegate respondsToSelector:@selector(DSToolBarClickedWithTag:dreamModel:)]) {
                [self.delegate DSToolBarClickedWithTag:button.tag dreamModel:self.curDream];
            }
            break;
        default:
            break;
    }
}
/**
 *  赞或喷
 *
 *  @param type 类型
 */
-(void)supportDreamWithType:(NSInteger)type{
    AccountModel *accounter = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"comments";
    if (type == kTagSupport) {
        params[@"api_type"] = @"support";
        self.supportButton.selected = YES;
        self.unSupportButton.selected = NO;
    }else{
        params[@"api_type"] = @"unsupport";
        self.supportButton.selected = NO;
        self.unSupportButton.selected = YES;
    }
    params[@"dream_id"] = self.curDream.idStr;
    params[@"user_id"] = accounter.userID;
    params[@"time"] = [CommomToolDefine currentDateStr];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        DBLog(@"support  %@", json);
        
        NSArray *dreams = [DSDreamModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *dreamFrames = [self dreamFramesWithDreams:dreams];
        
        DSDreamFrame* dreamFrame = [dreamFrames objectAtIndex:0];
        self.curDream = dreamFrame.dream;
        
        [self setButtonCount:dreamFrame.dream.support_count button:self.supportButton title:@"赞"];
        [self setButtonCount:dreamFrame.dream.unsupport_count button:self.unSupportButton title:@"喷"];
        
        if ([self.delegate respondsToSelector:@selector(DSToolBarClickedWithTag:dreamModel:)]) {
            [self.delegate DSToolBarClickedWithTag:type dreamModel:self.curDream];
        }
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
    }];
}

/**
 *  转换模型
 *
 *  @param dreams 数据模型
 *
 *  @return frame模型
 */
-(NSArray *)dreamFramesWithDreams:(NSArray*)dreams{
    // 将WBStatus数组转为 WBStatusFrame数组
    NSMutableArray *newFrames = [NSMutableArray array];
    for (DSDreamModel *dream in dreams) {
        DSDreamFrame *frame = [[DSDreamFrame alloc]init];
        frame.dream = dream;
        [newFrames addObject:frame];
    }
    
    return newFrames;
}

-(void)setButtonCount:(NSInteger)count button:(UIButton *)button title:(NSString *)title{
    if (count != 0) {
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%ld", count];
        }else{
            title = [NSString stringWithFormat:@"%.1lf万", count / 10000.0];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }

    [button setTitle:title forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger count = [self.subviews count];
    CGFloat btnWidth = kScreenWidth / count;
    CGFloat btnHeight = self.height;
    
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = i * btnWidth;
        btn.y = 0;
        btn.width = btnWidth;
        btn.height = btnHeight;
    }
}
@end
