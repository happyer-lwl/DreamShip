//
//  PlaceHolderTextView.h
//  LoseYourTemper
//
//  Created by 刘伟龙 on 15/12/3.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView<UITextViewDelegate>

@property (nonatomic, copy)     NSString *placehoder;
@property (nonatomic, strong)   UIColor *placeholderColor;

@end
