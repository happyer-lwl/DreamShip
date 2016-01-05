//
//  UICustomTextField.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "UICustomTextField.h"

@implementation UICustomTextField

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    UIColor *lGrayColor = RGBColor(186, 186, 193);
    CGContextSetFillColorWithColor(context, lGrayColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end
