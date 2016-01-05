//
//  AccountModel.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

+(instancetype)accountWithDictionary:(NSDictionary *)dict{
    AccountModel *model = [[AccountModel alloc] init];
    model.userID = dict[@"userID"];
    model.userPhone = dict[@"userPhone"];
    model.userPwd = dict[@"userPwd"];
    model.userImage = dict[@"userImage"];
    
    model.userRealName = dict[@"userRealName"];
    model.userMail = dict[@"userMail"];
    model.userSex = dict[@"userSex"];
    return model;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.userPhone forKey:@"userPhone"];
    [aCoder encodeObject:self.userPwd forKey:@"userPwd"];
    [aCoder encodeObject:self.userImage forKey:@"userImage"];
    
    [aCoder encodeObject:self.userRealName forKey:@"userName"];
    [aCoder encodeObject:self.userMail forKey:@"userMail"];
    [aCoder encodeObject:self.userSex forKey:@"userSex"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.userPhone = [aDecoder decodeObjectForKey:@"userPhone"];
        self.userPwd = [aDecoder decodeObjectForKey:@"userPwd"];
        self.userImage = [aDecoder decodeObjectForKey:@"userImage"];
        
        self.userRealName = [aDecoder decodeObjectForKey:@"userName"];
        self.userMail = [aDecoder decodeObjectForKey:@"userMail"];
        self.userSex = [aDecoder decodeObjectForKey:@"userSex"];
    }
    return self;
}
@end
