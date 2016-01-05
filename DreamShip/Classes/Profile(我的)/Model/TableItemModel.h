//
//  TableItemModel.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/18.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableItemModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, copy) NSString *detailTitle;

+(instancetype)initWithTitle:(NSString *)title;
+(instancetype)initWithTitle:(NSString *)title tag:(NSInteger) tag;
+(instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle tag:(NSInteger)tag;
@end
