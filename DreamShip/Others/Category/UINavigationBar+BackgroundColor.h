//
//  UINavigationBar+BackgroundColor.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/25.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundColor)

@property (nonatomic, weak) UIView *overlay;

-(void)nav_setBackgroundColorAlpha:(CGFloat)alpha;

@end
