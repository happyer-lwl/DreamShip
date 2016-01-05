//
//  ToolBarView.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/3.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTagSupport     0
#define kTagUnSupport   1
#define kTagComment     2

@protocol DSToolBarViewDelegate <NSObject>

-(void)DSToolBarClickedWithTag:(NSInteger)tag;

@end

@class DSDreamModel;
@interface ToolBarView : UIView

+(instancetype)toolBar;

@property (nonatomic, strong) DSDreamModel *curDream;

@property (nonatomic, weak) id<DSToolBarViewDelegate> delegate;

@end
