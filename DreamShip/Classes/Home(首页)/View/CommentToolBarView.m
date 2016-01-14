//
//  CommentToolBarView.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/6.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "CommentToolBarView.h"


@interface CommentToolBarView()

@property (nonatomic, weak) UIButton *commentButton;

@end

@implementation CommentToolBarView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.3;
        
        UITextField *input = [[UITextField alloc] init];
        input.backgroundColor = kViewBgColor;
        input.keyboardType = UIKeyboardTypeDefault;
        input.borderStyle = UITextBorderStyleRoundedRect;
        input.placeholder = @"大侠,请指教点什么吧...";
        _inputTextField = input;
        [self addSubview:input];
        
        UIButton *comment = [[UIButton alloc] init];
        [comment setTitleColor:kTitleBlueColor forState:UIControlStateNormal];
        [comment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [comment setTitle:@"指点" forState:UIControlStateNormal];
        [comment addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:comment];
        _commentButton = comment;
        
    }
    return self;
}

+(instancetype)CommentToolBar{
    return [[self alloc] init];
}

-(void)commentClick{
    if ([self.delegate respondsToSelector:@selector(commitTheComments:)]) {
        [self.delegate commitTheComments:self.inputTextField.text];
        self.inputTextField.text = @"";
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat commentButtonW = 60;
    CGFloat inputX = 10;
    CGFloat padding = 8;
    UITextField *input = [self.subviews objectAtIndex:0];
    input.frame = CGRectMake(inputX, padding, kScreenWidth - inputX - commentButtonW, kToolBarHeight - 2 * padding);
    
    UIButton *commentButon = [self.subviews objectAtIndex:1];
    commentButon.frame = CGRectMake(CGRectGetMaxX(input.frame), padding, commentButtonW, kToolBarHeight - 2 * padding);
}
@end
