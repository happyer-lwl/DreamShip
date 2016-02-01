//
//  GroupChatVC.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/29.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserGroupModel;
@interface GroupChatVC : RCConversationViewController

@property (nonatomic, strong) UserGroupModel *userGroup;

//+(DSUser *)getGroupWithGroupID:(NSString *)groupID finish:(void(^)(DSUser *user))finish;

@end
