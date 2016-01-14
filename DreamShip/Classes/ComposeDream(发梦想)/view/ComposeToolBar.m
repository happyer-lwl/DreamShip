//
//  WBComposeToolBar.m
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/12/6.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "ComposeToolBar.h"

@implementation ComposeToolBar

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
         
        // 初始化按钮
        [self setButtonWithImage:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:eComposeToolbarButtonTypeCamera];

        [self setButtonWithImage:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:eComposeToolbarButtonTypePicture];

        [self setButtonWithImage:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:eComposeToolbarButtonTypeEmotion];
    }
    
    return self;
}

+(instancetype)toolBar{
    return [[self alloc] init];
}

-(void)setButtonWithImage:(NSString *)image highImage:(NSString *)highImage type:(ComposeToolbarButtonType)type{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    btn.tag = type;
    [btn addTarget:self action:@selector(btnClickedWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)btnClickedWithTag:(UIButton*)button{
    if ([self.delegate respondsToSelector:@selector(ComposeToolBarClickedWithTag:)]) {
        [self.delegate ComposeToolBarClickedWithTag:button.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    /**
     *  设置layout
     */
    NSInteger count = self.subviews.count;
    NSInteger btnW = self.width / count;
    NSInteger btnH = self.height;
    
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
}

@end
