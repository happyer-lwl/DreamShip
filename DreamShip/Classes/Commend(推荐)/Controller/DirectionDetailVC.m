//
//  DirectionDetailVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/12.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DirectionDetailVC.h"
#import "DirectionModel.h"

@interface DirectionDetailVC ()

@property (nonatomic, weak) UITextView *textView;

@end

@implementation DirectionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBgColor;
    self.title = @"梦想就在那儿";
    
    UITextView *textView = [[UITextView alloc] init];
    textView.frame = self.view.frame;
    textView.height = textView.height - 64;
    textView.text = self.directionModel.text;
    textView.font = [UIFont systemFontOfSize:18];
    _textView = textView;
    [self.view addSubview:textView];
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
