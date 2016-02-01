//
//  UserGroupModel.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/31.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGroupModel : NSObject

@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *brief;

@property (nonatomic, strong) NSArray *groupMembers;

@end
