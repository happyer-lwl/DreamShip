//
//  ToolBarView.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/3.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "ToolBarView.h"
#import "DSDreamModel.h"

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
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        
        self.supportButton = [self setToolButtonWithTitle:@"赞" icon:@"timeline_icon_unlike" tag:kTagSupport];
        self.unSupportButton = [self setToolButtonWithTitle:@"喷" icon:@"timeline_icon_unsupport" tag:kTagUnSupport];
        self.commentButton = [self setToolButtonWithTitle:@"指点" icon:@"timeline_icon_comment" tag:kTagComment];
    }
    
    return self;
}

-(UIButton *)setToolButtonWithTitle:(NSString *)title icon:(NSString *)icon tag:(NSInteger)tag{
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.tag = tag;
    
    //btn.backgroundColor = color;
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(toolBarClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolButtons addObject:btn];
    
    [self addSubview:btn];
    
    return btn;
}

-(void)toolBarClicked:(UIButton *)button{
    DBLog(@"%ld", button.tag);
    if ([self.delegate respondsToSelector:@selector(DSToolBarClickedWithTag:)]) {
        [self.delegate DSToolBarClickedWithTag:button.tag];
    }
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
