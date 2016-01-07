//
//  SelfInfoSetSexyVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/27.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "SelfInfoSetSexyVC.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"

#import "TableGroupModel.h"
#import "TableItemModel.h"

#define kTableTagMan    01
#define kTableTagWoman  02

@interface SelfInfoSetSexyVC ()

@end

@implementation SelfInfoSetSexyVC

-(id)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self setTableView];
}

-(void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView.hidden = YES;
}

-(void)setNavigationBar{
    self.title = @"性别";
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveInfo:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

-(void)saveInfo:(NSString *)sexInfo{
    AccountModel *model = [AccountTool account];
    
    if ([HttpTool saveUserInfo:model.userPhone mod_key:@"sexy" mod_value:sexInfo]) {
        model.userSex = sexInfo;
        [AccountTool saveAccount:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDelegate / DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    AccountModel *model = [AccountTool account];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"男";
        cell.tag = kTableTagMan;
    }else{
        cell.textLabel.text = @"女";
        cell.tag = kTableTagWoman;
    }
    
    cell.accessoryType = ([cell.textLabel.text isEqualToString:model.userSex] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == kTableTagMan) {
        [self saveInfo: @"男"];
    }else{
        [self saveInfo: @"女"];
    }
}
@end
