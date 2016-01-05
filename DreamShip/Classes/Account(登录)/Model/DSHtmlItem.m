//
//  DSHtmlItem.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "DSHtmlItem.h"

@implementation DSHtmlItem

+(instancetype)htmlWithDict:(NSDictionary *)dict{
    DSHtmlItem *dsHtml = [[DSHtmlItem alloc] init];
    dsHtml.title = dict[@"title"];
    dsHtml.html  = dict[@"html"];
    dsHtml.id    = dict[@"id"];
    
    return dsHtml;
}

@end
