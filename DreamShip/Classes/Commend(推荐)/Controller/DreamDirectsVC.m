//
//  DreamDirectsVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/11.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DreamDirectsVC.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "DirectionModel.h"
#import "DirectionDetailVC.h"

@interface DreamDirectsVC ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *directionsArray;

@end

@implementation DreamDirectsVC

-(NSMutableArray *)directionsArray{
    if (_directionsArray == nil) {
        _directionsArray = [NSMutableArray array];
    }
    
    return _directionsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"逐梦令";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = kViewBgColor;
    
    [self setTableViewInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableViewInfo{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height - 64) style:UITableViewStyleGrouped];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    
    [self getFocusedUsers];
}

-(void)getFocusedUsers{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = @"getDirections";
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        DBLog(@"%@", json);
        NSArray *directions = [DirectionModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        
        [self.directionsArray removeAllObjects];
        [self.directionsArray addObjectsFromArray:directions];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.directionsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    DirectionModel *directionModle = [self.directionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = directionModle.title;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DirectionDetailVC *detailVC = [[DirectionDetailVC alloc] init];
    detailVC.directionModel = [self.directionsArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
