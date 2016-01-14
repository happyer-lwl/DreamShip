//
//  DSUser.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/22.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountModel;
@interface DSUser : NSObject

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *userRealName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *userMail;

@property (nonatomic, copy) NSString *userWords;
@property (nonatomic, copy) NSString *userAddr;

+(instancetype)userWithAccountModel:(AccountModel *)account;
@end
