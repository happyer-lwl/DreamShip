//
//  NSString+Tools.h
//  新浪微博
//
//  Created by 刘伟龙 on 15/11/25.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Tools)

-(CGRect)textRectWithSize: (CGSize)size attributes:(NSDictionary *)attributes;
-(CGSize)sizeWithText:(NSString*)text font:(UIFont*)font;
-(CGRect)textRectWithText:(NSString*)text font:(UIFont*)font;

@end
