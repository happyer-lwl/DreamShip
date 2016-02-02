//
//  DreamInvestorsVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/11.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DreamInvestorsVC.h"
#import "TableItemModel.h"

@interface DreamInvestorsVC ()

@property (nonatomic, strong) NSArray *investorsArray;
@property (nonatomic, weak)   UITableView *tableView;

@end

@implementation DreamInvestorsVC

-(NSArray *)investorsArray{
    if (_investorsArray == nil) {
        TableItemModel *item1 = [TableItemModel initWithTitle:@"AA基金" detailTitle:@"200次" tag:0];
        TableItemModel *item2 = [TableItemModel initWithTitle:@"BB基金" detailTitle:@"10次" tag:0];
        TableItemModel *item3 = [TableItemModel initWithTitle:@"CC基金" detailTitle:@"220次" tag:0];
        TableItemModel *item4 = [TableItemModel initWithTitle:@"DD基金" detailTitle:@"120次" tag:0];
        TableItemModel *item5 = [TableItemModel initWithTitle:@"EE基金" detailTitle:@"330次" tag:0];
        TableItemModel *item6 = [TableItemModel initWithTitle:@"FF基金" detailTitle:@"33次" tag:0];
        TableItemModel *item7 = [TableItemModel initWithTitle:@"GG基金" detailTitle:@"21次" tag:0];
        TableItemModel *item8 = [TableItemModel initWithTitle:@"HH基金" detailTitle:@"14次" tag:0];
        TableItemModel *item9 = [TableItemModel initWithTitle:@"II基金" detailTitle:@"22次" tag:0];
        
        _investorsArray = @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
    }
    
    return _investorsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"助梦人";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = kViewBgColor;
    
    [self setTableViewInfo];
}

-(void)setTableViewInfo{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height - 64) style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = kViewBgColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.investorsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = @"skill";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    TableItemModel *item = [self.investorsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detailTitle;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    PersonDetailVC *detailVC = [[PersonDetailVC alloc] init];
    //    UserFrame *userFrame = [self.userFrames objectAtIndex:indexPath.row];
    //    detailVC.user = userFrame.user;
    //
    //    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
