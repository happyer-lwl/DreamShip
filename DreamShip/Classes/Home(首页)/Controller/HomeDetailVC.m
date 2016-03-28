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

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"

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
    self.navigationItem.title = self.dreamFrame.dream.user.userRealName;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStyleDone target:self action:@selector(rejectTheContent:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

/**
 *  设置TableView信息
 */
-(void)setTableViewInfo{
    //UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kToolBarHeight - 64) style:UITableViewStylePlain];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kToolBarHeight - 64) style:UITableViewStylePlain];
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
    commentToolBar.frame = CGRectMake(0, self.view.y + self.view.height - kToolBarHeight - 64, kScreenWidth, kToolBarHeight);
    _commentToolBar = commentToolBar;
    [kNotificationCenter addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.commentToolBar.delegate = self;
    
    DBLog(@"height %f  y %f", self.view.height, self.view.y);
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
        DBLog(@"%f, %f", self.commentToolBar.y, keyboradF.origin.y);
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
        cell.textLabel.textColor = kTitleFireColorNormal;
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

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"分享";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DSDreamModel *model = _dreamFrame.dream;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [self.view addSubview:hud];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"举报成功，我们会在24小时内处理";
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:1];

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *weibo = [UIAlertAction actionWithTitle:@"微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"album" ofType:@"png"];
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"分享"
                                               defaultContent:@""
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"ShareSDK"
                                                          url:@"http://www.mob.com"
                                                  description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                                    mediaType:SSPublishContentMediaTypeNews];
            [ShareSDK clientShareContent:publishContent
                                    type:ShareTypeSinaWeibo
                           statusBarTips:YES
                                  result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                      
                                      if (state == SSPublishContentStateSuccess)
                                      {
                                          NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功!"));
                                      }
                                      else if (state == SSPublishContentStateFail)
                                      {
                                          NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败!"), [error errorCode], [error errorDescription]);
                                      }
                                  }];
            
        }];
        UIAlertAction *wechat = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImage *shareimage =  [self imageFromView:self.view];
            
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                               defaultContent:@"测试一下"
                                                        image:[ShareSDK pngImageWithImage:shareimage]
                                                        title:@"ShareSDK"
                                                          url:@"http://www.mob.com"
                                                  description:@"这是一条测试信息"
                                                    mediaType:SSPublishContentMediaTypeImage];
            
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:NO
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            //
            [authOptions setPowerByHidden:YES];
            //
            id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享循迹地图" shareViewDelegate:nil];
            
            [ShareSDK clientShareContent:publishContent type:ShareTypeWeixiSession authOptions:authOptions shareOptions:shareOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                
                if (state == SSResponseStateSuccess)
                {
                    NSLog(@"分享成功");
                }
                else if (state == SSResponseStateFail)
                {
                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                }
                
            }];
            
        }];
        UIAlertAction *qq = [UIAlertAction actionWithTitle:@"Q Q" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"qq_login" ofType:@"png"];
            
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:model.type
                                               defaultContent:@"梦想"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:model.user.userRealName
                                                          url:@"http://www.mob.com"
                                                  description:model.text
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:NO
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            //
            [authOptions setPowerByHidden:YES];
            //
            id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享循迹地图" shareViewDelegate:nil];
            
            [ShareSDK clientShareContent:publishContent type:ShareTypeQQ authOptions:authOptions shareOptions:shareOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
               
                if (state == SSResponseStateSuccess)
                {
                    NSLog(@"分享成功");
                }
                else if (state == SSResponseStateFail)
                {
                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                }
                
            }];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:weibo];
        [alert addAction:wechat];
        [alert addAction:qq];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        [tableView setEditing:NO animated:YES];
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

-(void)cellCollectionClicked:(DSDreamFrame *)dreamFrame state:(BOOL)selected view:(UIView *)view{
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

- (void)rejectTheContent:(id)sender{
    UIAlertController *alert = [CommomToolDefine alertWithTitle:@"举报成功，我们会在24小时内审核并处理，感谢您的支持!" message:nil ok:^{
    } cancel:^{
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// iphone 截屏方法
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //[theView.layer renderInContext: context];
    [self.navigationController.view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
