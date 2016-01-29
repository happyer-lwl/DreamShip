//
//  UITabBar+littleRedDotBadge.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/20.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (littleRedDotBadge)

- (void)showBadgeOnItemIndex:(int)index;
- (void)removeBadgeOnItemIndex:(int)index;
- (void)hideBadgeOnItemIndex:(int)index;
@end
