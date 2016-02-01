//
//  GroupChatVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/29.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "GroupChatVC.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"
#import "DSUser.h"
#import "UserGroupModel.h"

@interface GroupChatVC()

@end

@implementation GroupChatVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    if (self.userGroup.name.length) {
        self.navigationItem.title = self.userGroup.name;
    }else{
        self.navigationItem.title = @"群聊";
    }
}
//
//-(void)createGroupRongCloud{
//    AccountModel *account = [AccountTool account];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"api_uid"] = @"users";
//    params[@"api_type"]= @"createGroupChat";
//    
//    params[@"appKey"] = kRongCloudAppKey;
//    params[@"appSecret"] = kRongCloudAppSecret;
//    params[@"phone"] = account.userPhone;
//    params[@"groupName"] = self.navigationItem.title;
//    params[@"groupUsers"] = [self getSelectedUserIDsWithArray:self.groupUsers];
//    
//    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
//        DBLog(@"%@", json);
//        
//        } failure:^(NSError *error) {
//        DBLog(@"网络错误 %@", error.description);
//    }];
//}

-(NSMutableString *)getSelectedUserIDsWithArray:(NSArray *)selectedUsers{
    NSMutableString *userIDS = [NSMutableString string];
    
    for (NSInteger i = 0; i < selectedUsers.count - 1; i++) {
        DSUser *user = [selectedUsers objectAtIndex:i];
        [userIDS appendFormat:@"%@;", user.name];
    }
    DSUser *user = [selectedUsers objectAtIndex:selectedUsers.count - 1];
    [userIDS appendString:user.name];
    
    return userIDS;
}

@end
