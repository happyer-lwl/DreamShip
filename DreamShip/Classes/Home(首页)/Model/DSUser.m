//
//  DSUser.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/22.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "DSUser.h"
#import "AccountModel.h"

@implementation DSUser

+(instancetype)userWithAccountModel:(AccountModel *)account{
    DSUser *userInfo = [[DSUser alloc] init];
    
    userInfo.user_id = account.userID;
    userInfo.userAddr = account.userAddr;
    userInfo.userMail = account.userMail;
    userInfo.userRealName = account.userRealName;
    userInfo.userSex = account.userSex;
    userInfo.userWords = account.userWords;
    userInfo.image = account.userImage;
    userInfo.name = account.userPhone;
    
    return userInfo;
}

@end
