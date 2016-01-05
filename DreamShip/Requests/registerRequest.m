//
//  registerRequest.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/22.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "registerRequest.h"

@implementation registerRequest

-(NSString *)getRegisterRequestURL{
    return [NSString stringWithFormat:@"api_uid=Login&"];
}

@end
