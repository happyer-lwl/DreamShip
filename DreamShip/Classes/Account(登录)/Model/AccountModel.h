//
//  AccountModel.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *userPwd;
@property (nonatomic, copy) NSString *userImage;

@property (nonatomic, copy) NSString *userRealName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *userMail;

+(instancetype)accountWithDictionary:(NSDictionary *)dict;
@end
