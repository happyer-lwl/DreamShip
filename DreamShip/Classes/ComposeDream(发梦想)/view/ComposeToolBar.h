//
//  WBComposeToolBar.h
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/12/6.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    eComposeToolbarButtonTypeCamera, // 拍照
    eComposeToolbarButtonTypePicture, // 相册
    eComposeToolbarButtonTypeEmotion // 表情
} ComposeToolbarButtonType;

@protocol ComposeToolBarDelegate <NSObject>

-(void)ComposeToolBarClickedWithTag:(ComposeToolbarButtonType)tag;

@end

@interface ComposeToolBar : UIView

@property (nonatomic, weak) id<ComposeToolBarDelegate> delegate;

+(instancetype)toolBar;

@end
