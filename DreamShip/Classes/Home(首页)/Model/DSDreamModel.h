//
//  DSDreamModel.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/22.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSUser;
@interface DSDreamModel : NSObject

@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger support_count;
@property (nonatomic, assign) NSInteger unsupport_count;
@property (nonatomic, assign) NSInteger comment_count;

@property (nonatomic, copy) NSString *collection;

@property (nonatomic, strong) DSUser *user;

@end
