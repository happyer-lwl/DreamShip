//
//  HttpTool.h
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/12/2.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpTool : NSObject

+(void)getWithUrl:(NSString*)url params:(NSDictionary*)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+(void)postWithUrl:(NSString*)url params:(NSDictionary*)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+(BOOL)saveUserInfo:(NSString *)phone mod_key:(NSString *)mod_key mod_value:(NSString *)mod_value;
@end
