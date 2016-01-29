//
//  UINavigationBar+BackgroundColor.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/25.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>

@implementation UINavigationBar (BackgroundColor)

static char overlayKey;

-(UIView *)overlay{
    return objc_getAssociatedObject(self, &overlayKey);
}

-(void)setOverlay:(UIView *)overlay{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)nav_setBackgroundColorAlpha:(CGFloat)alpha{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, 64)];
        self.overlay = view;
        self.overlay.userInteractionEnabled = YES;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = [UIColor colorWithRed:240.0/256 green:90.0/256 blue:40/256.0 alpha:alpha];
}
@end

