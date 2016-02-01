//
//  NewFeatureViewController.h
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/11/28.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPhotosViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *photos;

-(void)showPageViewAtIndex:(int)index;
@end
