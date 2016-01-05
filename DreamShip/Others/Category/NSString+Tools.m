//
//  NSString+Tools.m
//  新浪微博
//
//  Created by 刘伟龙 on 15/11/25.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)

-(CGRect)textRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

-(CGSize)sizeWithText:(NSString*)text font:(UIFont*)font{
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    return [text sizeWithAttributes:attri];
}

-(CGRect)textRectWithText:(NSString*)text font:(UIFont*)font{
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = font;
    return [self boundingRectWithSize:[self sizeWithText:text font:font] options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil];
}
@end
