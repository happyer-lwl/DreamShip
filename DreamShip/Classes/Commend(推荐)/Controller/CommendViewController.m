//
//  CommendViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "CommendViewController.h"

@interface CommendViewController()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *headerView;

@end

@implementation CommendViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    [self setTableViewInfo];
}

/**
 *  设置列表相关内容
 */
-(void)setTableViewInfo{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.backgroundColor = kViewBgColor;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(140, 0, 0, 0);
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    //UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dream_wings" ofType:@"jpg"]];
    //[headerView addSubview:imageView];
    //headerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:imageView];
    self.headerView = imageView;
}

#pragma mark KVO 回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (offset.y <= 0 && -offset.y >= 64) {
            
            if (-offset.y <= 160) {
                CGRect newFrame = CGRectMake(0, 0, kScreenWidth, -offset.y);
                self.headerView.frame = newFrame;
                self.tableView.contentInset = UIEdgeInsetsMake(-offset.y, 0, 0, 0);
            }
        }else{
            CGRect newFrame = CGRectMake(0, 0, kScreenWidth, 64);
            self.headerView.frame = newFrame;
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
    }
}

#pragma mark TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 40;
//}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    static NSString *headerID = @"header";
//    
//    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
//    
//    if (headerView == nil) {
//        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerID];
//    }
//    
//    UILabel *la = [[UILabel alloc] init];
//    la.text = @"hello";
//    la.frame = CGRectMake(0, 0, kScreenWidth, 40);
//    
//    [headerView addSubview:la];
//    
//    return headerView;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
@end
