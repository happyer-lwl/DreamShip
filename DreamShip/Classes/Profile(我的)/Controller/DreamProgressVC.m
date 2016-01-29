//
//  DreamProgressVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/27.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DreamProgressVC.h"

@implementation DreamProgressVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"梦想进度";
    self.view.backgroundColor = kViewBgColor;
    
    [self setSubviews];
}

-(void)setSubviews{
    UILabel *label = [[UILabel alloc] init];
    label.x = 0;
    label.y = kScreenHeight / 2 - 100;
    label.width = kScreenWidth;
    label.height = 30;
    label.text = @"ಥ_ಥ";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kTitleFireColorNormal;
    label.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.x = 0;
    label1.y = CGRectGetMaxY(label.frame) + 10;
    label1.width = kScreenWidth;
    label1.height = 30;
    label1.text = @"暂无此地";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = kTitleFireColorNormal;
    label1.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:label1];
}

@end
