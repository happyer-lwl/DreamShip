//
//  DreamShowVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/19.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DreamShowVC.h"

@interface DreamShowVC ()

@end

@implementation DreamShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"梦游吧";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = kViewBgColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
