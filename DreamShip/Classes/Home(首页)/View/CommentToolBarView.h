//
//  CommentToolBarView.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/6.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kToolBarHeight 50

@protocol CommentToolBarDelegate <NSObject>

-(void)commitTheComments:(NSString *)comments;

@end

@interface CommentToolBarView : UIView

@property (nonatomic, weak) id<CommentToolBarDelegate> delegate;
@property (nonatomic, weak) UITextField *inputTextField;

+(instancetype)CommentToolBar;

@end
