//
//  CommendViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "CommendViewController.h"

#import "DreamDirectsVC.h"
#import "DreamPersonsVC.h"
#import "DreamTeamsVC.h"
#import "DreamInvestorsVC.h"

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}
/**
 *  设置列表相关内容
 */
-(void)setTableViewInfo{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.backgroundColor = kViewBgColor;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(140, 0, 0, 0);
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    //UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DreamAndMoon" ofType:@"jpg"]];
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numOfRow = 0;
    switch (section) {
        case 0:
            numOfRow = 4;
            break;
        case 1:
            numOfRow = 4;
            break;
        case 2:
            numOfRow = 4;
            break;
        default:
            break;
    }
    
    return numOfRow;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 44;
    switch (indexPath.section) {
        case 0:
            cellHeight = 100;
            break;
        case 1:
            cellHeight = 100;
            break;
        case 2:
            cellHeight = 100;
            break;
        default:
            break;
    }
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

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

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *title = @"";
//    switch (section) {
//        case 0:
//            title = @"梦想指导";
//            break;
//        case 1:
//            title = @"梦想达人";
//            break;
//        case 2:
//            title = @"梦想港湾";
//            break;
//        default:
//            break;
//    }
//    
//    return title;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        NSString *imageName = [NSString stringWithFormat:@"DreamIndex%ld%ld", indexPath.section, indexPath.row];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        imageView.image = [UIImage imageNamed:imageName];;
        [cell.contentView addSubview:imageView];
    }else if (indexPath.section == 1){
        NSString *imageName = [NSString stringWithFormat:@"DreamIndex%ld%ld", indexPath.section - 1, indexPath.row];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        imageView.image = [UIImage imageNamed:imageName];;
        [cell.contentView addSubview:imageView];
    }else if (indexPath.section == 2){
        NSString *imageName = [NSString stringWithFormat:@"DreamIndex%ld%ld", indexPath.section - 2, indexPath.row];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        imageView.image = [UIImage imageNamed:imageName];;
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = nil;
    
    if (indexPath.row == 0) {
        vc = [[DreamDirectsVC alloc] init];
    }else if (indexPath.row == 1){
        vc = [[DreamPersonsVC alloc] init];
    }else if (indexPath.row == 2){
        vc = [[DreamTeamsVC alloc] init];
    }else if (indexPath.row == 3){
        vc = [[DreamInvestorsVC alloc] init];
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
