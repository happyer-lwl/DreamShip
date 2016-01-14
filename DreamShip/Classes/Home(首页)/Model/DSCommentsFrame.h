//
//  UserFrame.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/6.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

// 昵称字体
#define kDSUserNameFont [UIFont boldSystemFontOfSize:16]
// 时间字体
#define kDSUserWordsFont [UIFont systemFontOfSize:13]

@class DSCommentModel;
@interface CommentsFrame : NSObject

@property (nonatomic, assign) CGRect bgViewF;
@property (nonatomic, assign) CGRect nameF;
@property (nonatomic, assign) CGRect timeF;
@property (nonatomic, assign) CGRect imageF;
@property (nonatomic, assign) CGRect commentF;


@property (nonatomic, strong) DSCommentModel *comment;

@property (nonatomic, assign) CGFloat cellHeight;

@end
