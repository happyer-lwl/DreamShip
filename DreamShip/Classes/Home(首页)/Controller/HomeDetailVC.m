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
#import "UserFrame.h"
#import "UserModelCell.h"
#import "PersonDetailVC.h"
#import "DSCommentModel.h"
#import "DSCommentsFrame.h"

#import "UIBarButtonItem+Extension.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "HttpTool.h"
#import "AccountModel.h"
#import "AccountTool.h"

#import "CommentToolBarView.h"
#import "DSCommentCell.h"

@interface HomeDetailVC ()

@property (nonatomic, strong) NSMutableArray *commentFrameArray;
@property (nonatomic, weak) CommentToolBarView *commentToolBar;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation HomeDetailVC

-(NSMutableArray *)commentFrameArray{
    if (_commentFrameArray == nil) {
        _commentFrameArray = [NSMutableArray array];
    }
    
    return _commentFrameArray;
}

-(void)setDreamFrame:(DSDreamFrame *)dreamFrame{
    _dreamFrame = dreamFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBgColor;
    
    [self setNavigationInfo];
    [self setTableViewInfo];
    [self setCommentToolBar];
    [self updateComments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height - kToolBarHeight - 64) style:UITableViewStylePlain];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
}

/**
 *  获取评论
 */
-(void)updateComments{
    DSDreamModel *dreamModel = self.dreamFrame.dream;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"comments";
    params[@"api_type"] = @"getComments";
    params[@"dream_id"] = dreamModel.idStr;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        NSArray *comments = [DSCommentModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *commentFrames = [self commentFramesWithComments:comments];
        
        [self.commentFrameArray removeAllObjects];
        [self.commentFrameArray addObjectsFromArray:commentFrames];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {

    }];
}

-(NSArray *)commentFramesWithComments:(NSArray*)comments{
    // 将WBStatus数组转为 WBStatusFrame数组
    NSMutableArray *newFrames = [NSMutableArray array];
    for (DSCommentModel *comment in comments) {
        CommentsFrame *frame = [[CommentsFrame alloc]init];
        frame.comment = comment;
        [newFrames addObject:frame];
    }
    
    return newFrames;
}

-(void)setCommentToolBar{
    CommentToolBarView *commentToolBar = [CommentToolBarView CommentToolBar];
    commentToolBar.frame = CGRectMake(0, self.view.height - kToolBarHeight - 64, kScreenWidth, kToolBarHeight);
    _commentToolBar = commentToolBar;
    [kNotificationCenter addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.commentToolBar.delegate = self;
    
    [self.view addSubview:commentToolBar];
}

-(void)backToPre{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)keyboardChanged:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboradF = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.commentToolBar.y = keyboradF.origin.y - self.commentToolBar.height - 64;
    }];
}

-(void)commitTheComments:(NSString *)comments{
    AccountModel *accountModel = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"comments";
    params[@"api_type"] = @"commit";
    params[@"text"] = comments;
    params[@"dream_id"] = self.dreamFrame.dream.idStr;
    params[@"user_id"] = accountModel.userID;
    params[@"time"] = [CommomToolDefine currentDateStr];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(id json) {
        DBLog(@"%@", json);
        [self.view endEditing:YES];
        [self updateComments];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
    }];
    
}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}

// 获取梦想
-(void)getNewDreams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = @"getData";

    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        
        NSArray *dreams = [DSDreamModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *dreamFrames = [self dreamFramesWithDreams:dreams];
        
        for (DSDreamFrame *frame in dreamFrames) {
            if ([frame.dream.idStr isEqualToString:self.dreamFrame.dream.idStr]) {
                self.dreamFrame = frame;
            }
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        DBLog(@"刷新成功");
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

-(NSArray *)dreamFramesWithDreams:(NSArray*)dreams{
    // 将WBStatus数组转为 WBStatusFrame数组
    NSMutableArray *newFrames = [NSMutableArray array];
    for (DSDreamModel *dream in dreams) {
        DSDreamFrame *frame = [[DSDreamFrame alloc]init];
        frame.dream = dream;
        [newFrames addObject:frame];
    }
    
    return newFrames;
}

#pragma mark - ScrollDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section != 2) {
        return 1;
    }else{
        return self.commentFrameArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return self.dreamFrame.cellHeight;
    }else if (indexPath.section == 1){
        return 35;
    }
    else{
        CommentsFrame *frame = [self.commentFrameArray objectAtIndex:indexPath.row];
        return frame.cellHeight;
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
        cell.delegate = self;
        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"评论";
        cell.textLabel.textColor = kTitleBlueColor;
        return cell;
    }
    else{
        DSCommentCell *cell = [DSCommentCell cellWithTableView:tableView];
        cell.commentFrame = [self.commentFrameArray objectAtIndex:indexPath.row];
        cell.delegate = self;
        cell.userInteractionEnabled = YES;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //DBLog(@"Comment cell clicked");
    }
}

-(void)supportDream:(DSDreamFrame*)dreamFrame{
    DSDreamModel *dreamModel = dreamFrame.dream;
    
    AccountModel *accounter = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"comments";
    params[@"api_type"] = @"support";
    params[@"dream_id"] = dreamModel.idStr;
    params[@"user_id"] = accounter.userID;
    params[@"time"] = [CommomToolDefine currentDateStr];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        DBLog(@"support  %@", json);
        
        NSArray *dreams = [DSDreamModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *dreamFrames = [self dreamFramesWithDreams:dreams];
        
        self.dreamFrame = [dreamFrames objectAtIndex:0];

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
    }];
}

-(void)unsupportDream:(DSDreamFrame*)dreamFrame{
    DSDreamModel *dreamModel = dreamFrame.dream;
    
    AccountModel *accounter = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"comments";
    params[@"api_type"] = @"unsupport";
    params[@"dream_id"] = dreamModel.idStr;
    params[@"user_id"] = accounter.userID;
    params[@"time"] = [CommomToolDefine currentDateStr];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        DBLog(@"unsupport  %@", json);
        
        NSArray *dreams = [DSDreamModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *dreamFrames = [self dreamFramesWithDreams:dreams];
        
        self.dreamFrame = [dreamFrames objectAtIndex:0];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
    }];
}

-(void)commentDream:(DSDreamFrame*)dreamFrame{
    [self.commentToolBar.inputTextField becomeFirstResponder];
}

-(void)cellToolBarClickedWithTag:(NSInteger)tag dreamFrame:(DSDreamFrame*)dreamFrame{
    switch (tag) {
        case kTagSupport:
        case kTagUnSupport:
            break;
        case kTagComment:
            [self commentDream:dreamFrame];
            break;
        default:
            break;
    }
    
    [kNotificationCenter postNotificationName:kUpdateCellInfoFromCell object:nil];
}

-(void)cellCollectionClicked:(DSDreamFrame *)dreamFrame state:(BOOL)selected{
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = selected ? @"cancelCollectedDream" : @"collectDream";
    params[@"user_id"] = account.userID;
    params[@"dream_id"] = dreamFrame.dream.idStr;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(id json) {
        NSString *msg = json[@"msg"];
        
        self.dreamFrame.dream.collection = selected ? @"0" : @"1";
        [self.tableView reloadData];
        [MBProgressHUD showSuccess:msg];
        
        [kNotificationCenter postNotificationName:kUpdateCellInfoFromCell object:nil];
    } failure:^(NSError *error) {
        DBLog(@"error %@", error.description);
    }];
}

-(void)commentCellUserIconClicked:(CommentsFrame *)commentsFrame{
    PersonDetailVC *detailVC = [[PersonDetailVC alloc] init];
    detailVC.user = commentsFrame.comment.user;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
