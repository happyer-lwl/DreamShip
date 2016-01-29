//
//  SingleChatVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/19.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "SingleChatVC.h"
#import "PersonDetailVC.h"

#import "DSUser.h"
#import "HttpTool.h"
@interface SingleChatVC ()

@end

@implementation SingleChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)didTapCellPortrait:(NSString *)userId{
    DBLog(@"Portrait");
    
    PersonDetailVC *detailVC = [[PersonDetailVC alloc] init];
    
    [SingleChatVC getUserWithUserID:userId finish:^(DSUser *user) {
        detailVC.user = user;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
    
}

+(DSUser *)getUserWithUserID:(NSString *)userID finish:(void(^)(DSUser *user))finish{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getUserWithID";
    params[@"user_id"] = userID;
    
    DSUser *user = [[DSUser alloc] init];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        NSString *result = [json[@"result"] stringValue];
        NSDictionary *dataDict = json[@"data"];
        
        DBLog(@"%@", json);
        if ([result isEqualToString:@"200"]) {//登录
            
            user.name = dataDict[@"name"];
            user.userRealName = dataDict[@"userRealName"];
            user.image = dataDict[@"image"];
            user.userMail = dataDict[@"userMail"];
            user.user_id = dataDict[@"user_id"];
            user.userAddr = dataDict[@"userAddr"];
            user.userSex = dataDict[@"sex"];
            user.userWords = dataDict[@"userWords"];
            
            finish(user);
            
        }else if ([result isEqualToString:@"201"]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"当前用户不存在，请确认!"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误!"];
    }];
    
    return user;
}
@end
