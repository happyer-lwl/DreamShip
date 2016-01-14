//
//  HttpTool.m
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/12/2.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "HttpTool.h"
#import "AccountModel.h"
#import "AccountTool.h"

@implementation HttpTool

+(void)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 设置请求和回复的序列化
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
        //DBLog(@"%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)posWithUrl:(NSString *)url params:(NSDictionary *)params data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName type:(NSString *)type success:(void(^)(id))success failuer:(void(^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    manager set
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 保存用户信息
 */
+(BOOL)saveUserInfo:(NSString *)phone mod_key:(NSString *)mod_key mod_value:(NSString *)mod_value{
    AccountModel *model = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"modUser";
    params[@"phone"] = model.userPhone;
    params[@"mod_key"] = mod_key;
    params[@"mod_value"] = mod_value;
    
    __block BOOL updateState = YES;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(id json) {
        DBLog(@"%@", @"successfull");
    } failure:^(NSError *error) {
        DBLog(@"%@", @"Failed");
        updateState = NO;
    }];
    
    return updateState;
}

@end
