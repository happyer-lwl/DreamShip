//
//  DSDreamFrame.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/22.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

// 昵称字体
#define kDSDreamCellNameFont [UIFont boldSystemFontOfSize:16]
// 时间字体
#define kDSDreamCellTimeFont [UIFont systemFontOfSize:13]
// 来源字体
#define kDSDreamCellSourceFont [UIFont systemFontOfSize:13]
// 正文字体
#define kDSDreamCellContentFont [UIFont systemFontOfSize:16]


@class DSDreamModel;
@interface DSDreamFrame : NSObject

@property (nonatomic, assign) CGRect bgViewF;
@property (nonatomic, assign) CGRect nameF;
@property (nonatomic, assign) CGRect imageF;
@property (nonatomic, assign) CGRect timeF;
@property (nonatomic, assign) CGRect typeF;
@property (nonatomic, assign) CGRect textF;

/** 工具条 */
@property (nonatomic, assign) CGRect toolBarF;

@property (nonatomic, strong) DSDreamModel *dream;

@property (nonatomic, assign) CGFloat cellHeight;
@end
