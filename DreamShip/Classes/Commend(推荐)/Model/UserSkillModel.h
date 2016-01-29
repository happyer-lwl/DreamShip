//
//  UserSkillModel.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/22.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DSUser;
@interface UserSkillModel : NSObject

@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *skills;

@property (nonatomic, assign) CGFloat   price;
@property (nonatomic, assign) NSInteger canBeBuy;

@property (nonatomic, strong) DSUser *user;

@end
