//
//  HomeDetailVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/30.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "HomeDetailVC.h"


#import "DSHomeViewCell.h"
#import "DSDreamFrame.h"
#import "DSDreamModel.h"
#import "DSUser.h"
#import "DSCommentModel.h"

#import "UIBarButtonItem+Extension.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"

#import "HttpTool.h"

@interface HomeDetailVC ()

@property (nonatomic, strong) NSMutableArray *commentArray;

@end

@implementation HomeDetailVC

-(NSMutableArray *)commentArray{
    if (_commentArray == nil) {
        _commentArray = [NSMutableArray array];
    }
    
    return _commentArray;
}

-(void)setDreamFrame:(DSDreamFrame *)dreamFrame{
    if (_dreamFrame == nil) {
        _dreamFrame = dreamFrame;
    }
}

-(id)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationInfo];
    [self setTableViewInfo];
    
    [self updateComments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置导航内容
 */
-(void)setNavigationInfo{
    self.title = self.dreamFrame.dream.user.name;
}

/**
 *  设置TableView信息
 */
-(void)setTableViewInfo{
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 *  获取评论
 */
-(void)updateComments{
    DSDreamModel *dreamModel = self.dreamFrame.dream;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = @"getComments";
    params[@"dream_id"] = dreamModel.idStr;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        NSArray *arry = [DSCommentModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        [self.commentArray addObjectsFromArray:arry];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)backToPre{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.commentArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.dreamFrame.cellHeight;
    }else{
        return 60;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 0.5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DSHomeViewCell *cell = [DSHomeViewCell cellWithTableView:tableView];
        cell.dreamFrame = self.dreamFrame;
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        DSCommentModel *model = [self.commentArray objectAtIndex:indexPath.row];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.user.image] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
        cell.textLabel.text = model.text;
        
        return cell;
    }
}
@end
