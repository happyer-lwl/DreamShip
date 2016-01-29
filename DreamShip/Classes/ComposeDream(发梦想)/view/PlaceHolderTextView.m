//
//  PlaceHolderTextView.m
//  LoseYourTemper
//
//  Created by 刘伟龙 on 15/12/3.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView

-(void)setPlacehoder:(NSString *)placehoder{
    _placehoder = [placehoder copy];
    
    [self setNeedsDisplay];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

// 如果代码修改文字  不会调DrawRect
-(void)setText:(NSString *)text{
    [super setText:text];
    
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font{
    [super setFont:font];
    
    [self setNeedsDisplay];
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 不要设置自己的delegate
        
        // object 被监听的对象，如果设置self会无限循环
        // 如果是代码设置text的话，不会发通知
        [kNotificationCenter addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

// 画文字
-(void)drawRect:(CGRect)rect{
    
    if (self.hasText) {
        return;
    }
    
    // 文字属性
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = self.font;
    attri[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor lightGrayColor];// 字典不能为空
    
    // 画文字
    //[self.placehoder drawAtPoint:CGPointMake(5, 8) withAttributes:attri];  换行不正确
    
    // 控件rect中换行没问题
    CGRect placeHolderRect = CGRectMake(0, 8, rect.size.width, rect.size.height - 2 * 8);
    [self.placehoder drawInRect:placeHolderRect withAttributes:attri];
}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}

-(void)textDidChanged{
//    DrawRect中方法更简单
//    DBLog(@"textDidChanged");
//    if (![self.text isEqualToString:@""]) {
//        self.placehoder = @"";
//    }else{
//        self.placehoder = @"分享新鲜事...";
//    }
    
    // 重绘 充新调用drawRect
    [self setNeedsDisplay];
}

@end
