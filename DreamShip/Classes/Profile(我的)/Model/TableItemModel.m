//
//  TableItemModel.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/18.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "TableItemModel.h"

@implementation TableItemModel

+(instancetype)initWithTitle:(NSString *)title{
    TableItemModel *item = [[TableItemModel alloc] init];
    item.title = title;
    
    return item;
}

+(instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon{
    TableItemModel *item = [[TableItemModel alloc] init];
    item.title = title;
    item.icon = icon;
    
    return item;
}

+(instancetype)initWithTitle:(NSString *)title tag:(NSInteger)tag{
    TableItemModel *item = [[TableItemModel alloc] init];
    item.title = title;
    item.tag = tag;

    return item;
}

+(instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon tag:(NSInteger)tag{
    TableItemModel *item = [[TableItemModel alloc] init];
    item.title = title;
    item.tag = tag;
    item.icon = icon;
    
    return item;
}

+(instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle tag:(NSInteger)tag{
    TableItemModel *item = [[TableItemModel alloc] init];
    item.title = title;
    item.detailTitle = detailTitle;
    item.tag = tag;
    
    return item;
}

+(instancetype)initWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle icon:(NSString *)icon tag:(NSInteger)tag{
    TableItemModel *item = [[TableItemModel alloc] init];
    item.title = title;
    item.detailTitle = detailTitle;
    item.tag = tag;
    item.icon = icon;
    
    return item;
}
@end
