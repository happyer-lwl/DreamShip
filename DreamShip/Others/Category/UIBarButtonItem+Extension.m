//
//  UIBarButtonItem+Extension.m
//  HMW
//
//  Created by 刘伟龙 on 15/10/20.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

/**
 *  创建一个BarButtonItem
 *
 *  @param action       点击Item响应对象的哪个方法
 *  @param target       点击Item响应哪个对象的方法
 *  @param image        正常状态图片
 *  @param highImage    高亮状态图片
 *
 *  @return barButtonItem
 */
+ (UIBarButtonItem*)itemWithAction:(SEL)action target:(id)target image:(NSString *)image highImage:(NSString*)highImage
{
    UIButton* barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 添加事件
    [barButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 设置图片
    [barButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [barButton setBackgroundImage:[UIImage imageNamed:highImage ] forState:UIControlStateHighlighted];
    
    // 设置尺寸,使用了扩展
    barButton.size = barButton.currentBackgroundImage.size;
    
    return [[UIBarButtonItem alloc] initWithCustomView:barButton];
}

@end
