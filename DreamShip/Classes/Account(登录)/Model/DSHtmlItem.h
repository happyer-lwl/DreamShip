//
//  DSHtmlItem.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSHtmlItem : NSObject
/*
 
 "title" : "如何提现？",
 "html" : "help.html",
 "id" : "howtowithdraw"
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *html;
@property (nonatomic, copy) NSString *id;

+(instancetype)htmlWithDict:(NSDictionary*)dict;

@end
