//
//  DreamInvestorsVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/11.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DreamInvestorsVC.h"

@interface DreamInvestorsVC ()

@end

@implementation DreamInvestorsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"投资家";
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
