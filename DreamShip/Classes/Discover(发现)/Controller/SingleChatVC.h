//
//  SingleChatVC.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/19.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@class DSUser;
@interface SingleChatVC : RCConversationViewController<RCConversationCellDelegate>

+(DSUser *)getUserWithUserID:(NSString *)userID finish:(void(^)(DSUser *user))finish;

@end
