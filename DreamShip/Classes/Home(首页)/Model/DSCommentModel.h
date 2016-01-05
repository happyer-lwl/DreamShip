//
//  DSCommentModel.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/31.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSUser;
@interface DSCommentModel : NSObject

@property (nonatomic, copy)     NSString *idStr;
@property (nonatomic, copy)     NSString *text;
@property (nonatomic, assign)   NSInteger favour;
@property (nonatomic, copy)     NSString *time;

@property (nonatomic, strong) DSUser *user;

@end
