//
//  HomeViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "HomeViewController.h"
#import "MainNavigationController.h"
#import "WBPhotosViewController.h"

#import "HomeDetailVC.h"
#import "ComposeDreamVC.h"
#import "PersonDetailVC.h"

#import "DSHomeViewCell.h"
#import "DSDreamFrame.h"
#import "DSDreamModel.h"
#import "DSUser.h"
#import "UserFrame.h"

#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIBarButtonItem+Extension.h"
#import "UITabBar+littleRedDotBadge.h"

#define kDreamTypeSegHeight 40

@interface HomeViewController()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIBarButtonItem *addDreamBarItem;
@property (nonatomic, weak) UISegmentedControl *dreamTypeSeg;
@property (nonatomic, weak) UIImageView *animationImageView;

@property (nonatomic, strong) NSMutableArray *dreamFrames;

@property (nonatomic, assign) BOOL bScrollUp;
@end

@implementation HomeViewController

-(NSMutableArray *)dreamFrames{
    if (_dreamFrames == nil) {
        _dreamFrames = [NSMutableArray array];
    }
    
    return _dreamFrames;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.bScrollUp = YES;
    
    [NSThread sleepForTimeInterval:kLaunchImageShowSec];
    
    [self setNavigationView];
    [self setDreamTypeSelectView];
    [self setTableViewInfo];
    [self setHeaderRefreshView];
    
    [kNotificationCenter addObserver:self selector:@selector(getNewDreams) name:kNotificationComposed object:nil];
    [kNotificationCenter addObserver:self selector:@selector(updateBadgeNum) name:kNotificationUpdataBadge object:nil];
    [kNotificationCenter postNotificationName:kNotificationUpdataBadge object:nil];
}

/**
 *  设置导航
 */
-(void)setNavigationView{
    UIBarButtonItem *addDreamBarItem = [UIBarButtonItem itemWithAction:@selector(addDream) target:self image:@"navigationbar_add" highImage:@""];
    _addDreamBarItem = addDreamBarItem;
    self.navigationItem.rightBarButtonItem = addDreamBarItem;
}

/**
 *  发表梦想
 */
-(void)addDream{
    ComposeDreamVC *addDreamVC = [[ComposeDreamVC alloc] init];
    addDreamVC.view.backgroundColor = kViewBgColor;
    
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:addDreamVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)setDreamTypeSelectView{
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"全部类型", @"认真做梦", @"组队寻友", @"拉拉投资"]];
    seg.frame = CGRectMake(-2.5, 0, kScreenWidth + 5, kDreamTypeSegHeight);
    seg.backgroundColor = kViewBgColorDarkest;
    seg.tintColor = [UIColor whiteColor];
    seg.selectedSegmentIndex = 0;
    [self.view addSubview:seg];
    [seg addTarget:self action:@selector(dreamTypeSegChanged) forControlEvents:UIControlEventValueChanged];
    _dreamTypeSeg = seg;
}

/**
 *  梦想类型选择回调
 */
-(void)dreamTypeSegChanged{
    [self getNewDreams];
}

/**
 *  设置tableview
 */
-(void)setTableViewInfo{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kDreamTypeSegHeight, kScreenWidth, kScreenHeight - 64 - kDreamTypeSegHeight - 44) style:UITableViewStylePlain];

//    tableView.backgroundColor = kTitleFireColorNormal;// kViewBgColorDarkest;
    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Launchimage4.7"]];
    tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.userInteractionEnabled = YES;
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

// 获取梦想
-(void)getNewDreams{
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = @"getData";
    params[@"dream_type"] = [NSNumber numberWithInteger:self.dreamTypeSeg.selectedSegmentIndex];
    params[@"cur_user_id"] = account.userID;
    
    if (self.dreamRange == DreamRangeSelf) {
        AccountModel *account = [AccountTool account];
        params[@"user_id"] = account.userID;
    }else if (self.dreamRange == DreamRangeFriend){
        params[@"user_id"] = self.dreamModel.user.user_id;
    }else if (self.dreamRange == DreamRangeAll) {
        params[@"user_id"] = @"all";
    }
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {

        NSArray *dreams = [DSDreamModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        NSArray *dreamFrames = [self dreamFramesWithDreams:dreams];

        [self.dreamFrames removeAllObjects];
        self.dreamFrames = [NSMutableArray arrayWithArray:dreamFrames];

        if (dreamFrames.count == 0){
            [CommomToolDefine addNoDataForView:self.view];
        }
        
        [self.tableView reloadData];
        [self.tableView.gifHeader endRefreshing];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD showError:@"网络错误!"];
        [self.tableView.gifHeader endRefreshing];
    }];
}

// 设置头和尾刷新
-(void)setHeaderRefreshView{
    //添加下拉的动画图片
    //设置下拉刷新回调
    [self.tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getNewDreams)];
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; ++i) {
        //        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd",i]];
        //        [idleImages addObject:image];
        UIImage *image = [UIImage imageNamed:@"icon_listheader_animation_1"];
        [idleImages addObject:image];
    }
    [self.tableView.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
    
    //设置即将刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    UIImage *image1 = [UIImage imageNamed:@"icon_listheader_animation_1"];
    [refreshingImages addObject:image1];
    UIImage *image2 = [UIImage imageNamed:@"icon_listheader_animation_2"];
    [refreshingImages addObject:image2];
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStatePulling];
    
    //设置正在刷新是的动画图片
    [self.tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
    
    //马上进入刷新状态
    [self.tableView.gifHeader beginRefreshing];
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

#pragma mark  TableViewDelegate/Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dreamFrames.count;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"认真做梦", @"组队寻友", @"拉拉投资"]];
//    seg.frame = CGRectMake(5, 0, kScreenWidth - 10, 30);
//    seg.backgroundColor = kBtnFireColorNormal;
//    seg.selectedSegmentIndex = 0;
//    seg.tintColor = [UIColor whiteColor];
//    //[self.view addSubview:seg];
//    [seg addTarget:self action:@selector(dreamTypeSegChanged) forControlEvents:UIControlEventValueChanged];
//    _dreamTypeSeg = seg;
//    
//    return seg;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DSDreamFrame *dreamF = [self.dreamFrames objectAtIndex:indexPath.row];
    return dreamF.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DSHomeViewCell *cell = [DSHomeViewCell cellWithTableView:tableView];
    cell.dreamFrame = [self.dreamFrames objectAtIndex:indexPath.row];
    //cell.userInteractionEnabled = YES;
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DSDreamFrame *selectedDream = [self.dreamFrames objectAtIndex:indexPath.row];
    
    HomeDetailVC *homeDetailVC = [[HomeDetailVC alloc] init];
    [homeDetailVC setDreamFrame:selectedDream];
    homeDetailVC.bLastPageIn = NO;
    [kNotificationCenter addObserver:self selector:@selector(updateCellInfo) name:kUpdateCellInfoFromCell object:nil];
    
    homeDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeDetailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CATransform3D rotation;
    if (indexPath.row % 2 == 0) {
        rotation                = CATransform3DMakeTranslation(kScreenWidth, 0.0, 0.0);
    }else{
        rotation                = CATransform3DMakeTranslation(kScreenWidth, 0.0, 0.0);
    }
    
    cell.layer.transform    = rotation;
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.5];
    cell.layer.transform    = CATransform3DIdentity;
    [UIView commitAnimations];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static float newx = 0;
    static float oldx = 0;
    newx= scrollView.contentOffset.y ;
    if (newx != oldx ) {
        if (newx - oldx > 5) {
            self.bScrollUp = NO;
            
            [UIView animateWithDuration:0.2 animations:^{
                self.dreamTypeSeg.y = 0;
                self.tableView.y = kDreamTypeSegHeight;
                self.tableView.height = kScreenHeight - 64 - kDreamTypeSegHeight;
            }];
            
        }else if(oldx - newx > 5){
            self.bScrollUp = YES;
            
            [UIView animateWithDuration:0.2 animations:^{
                self.dreamTypeSeg.y = 0 - self.dreamTypeSeg.height;
                self.tableView.y = 0;
                self.tableView.height = kScreenHeight - 64 - 44;
            }];
        }
        oldx = newx;
    }
}

/**
 *  观察者，更新内容
 */
-(void)updateCellInfo{
    self.dreamRange = DreamRangeAll;
    [self getNewDreams];
}

#pragma mark #HomeViewCellDelegate
/**
 *  toolBar按键回调
 *
 *  @param tag        按键类型
 *  @param dreamFrame 返回的数据模型
 */
-(void)cellToolBarClickedWithTag:(NSInteger)tag dreamFrame:(DSDreamFrame *)dreamFrame{
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
    
    for (NSInteger i = 0; i < self.dreamFrames.count; i++) {
        DSDreamFrame *frame = self.dreamFrames[i];
        if ([frame.dream.idStr isEqualToString:dreamFrame.dream.idStr]) {
            self.dreamFrames[i] = dreamFrame;
        }
    }
}
/**
 *  点击评论按键
 *
 *  @param dreamFrame <#dreamFrame description#>
 */
-(void)commentDream:(DSDreamFrame*)dreamFrame{
    HomeDetailVC *homeDetailVC = [[HomeDetailVC alloc] init];
    [homeDetailVC setDreamFrame:dreamFrame];
    
    homeDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeDetailVC animated:YES];
}

-(void)cellUserIconClicked:(DSDreamFrame *)dreamFrame{
    DBLog(@"User icon clicked");
    
    PersonDetailVC *detailVC = [[PersonDetailVC alloc] init];
    detailVC.user = dreamFrame.dream.user;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)cellPhotoViewClicked:(DSDreamFrame *)dreamFrame view:(UIImageView *)view{
    DSDreamModel *dreamModel = dreamFrame.dream;
    NSArray *urlArray = @[dreamModel.pic_url];
    
    WBPhotosViewController *photosVC = [[WBPhotosViewController alloc] init];
    photosVC.photos = [NSMutableArray arrayWithArray:urlArray];
    [self presentViewController:photosVC animated:YES completion:nil];
}

-(void)cellCollectionClicked:(DSDreamFrame *)dreamFrame state:(BOOL)selected view:(id)view{
    DBLog(@"Collection Clicked");
    
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = selected ? @"cancelCollectedDream" : @"collectDream";
    params[@"user_id"] = account.userID;
    params[@"dream_id"] = dreamFrame.dream.idStr;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(id json) {
        NSString *msg = json[@"msg"];
        
        [self modifyDreamFrames:dreamFrame collectState:!selected];
        
        [self.tableView reloadData];
        [MBProgressHUD showSuccess:msg];
    } failure:^(NSError *error) {
        DBLog(@"error %@", error.description);
    }];
}

-(void)animationWithView:(UIView *)view{
    CGPoint endPoint = CGPointMake(0, 0);
    //CGPoint endPoint = CGPointMake(330, 300);
    CGRect rc = [view.superview convertRect:view.frame toView:self.view];
    CGFloat rcCenterX = rc.origin.x + rc.size.width / 2;
    CGFloat rcCenterY = rc.origin.y + rc.size.height / 2;
    CGPoint startPoint = [self.view convertPoint:CGPointMake(rcCenterX, rcCenterY) toView:self.view];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(startPoint.x, startPoint.y, 30, 30);
    imageView.image = [UIImage imageNamed:@"card_icon_favorite_highlighted"];
    //_animationImageView = imageView;
    
    CALayer *layer = [[CALayer alloc] init];
    layer.contents = imageView.layer.contents;
    layer.frame = imageView.frame;
    layer.opacity = 1;
    [self.view.layer addSublayer:layer];
    
    CAKeyframeAnimation *CHAnimation=[CAKeyframeAnimation animationWithKeyPath:@"collection"];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    
    //贝塞尔曲线中间点
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endPoint.x;
    float ey = endPoint.y;
    float x = sx+(ex-sx)/3;
    float y = sy+(ey-sy)*0.5-300;
    CGPoint centerPoint = CGPointMake(x,y);
    [path addQuadCurveToPoint:endPoint controlPoint:centerPoint];
    
    CHAnimation.path = path.CGPath;
    CHAnimation.removedOnCompletion = NO;
    CHAnimation.fillMode = kCAFillModeBoth;
    CHAnimation.duration = 1.5;
    CHAnimation.delegate = self;
    
    [layer addAnimation:CHAnimation forKey:@"collection"];
}

-(void)modifyDreamFrames:(DSDreamFrame *)dreamFrame collectState:(BOOL)collectState{
    for (DSDreamFrame *dreamFrameIn in self.dreamFrames) {
        if (dreamFrameIn == dreamFrame) {
            dreamFrame.dream.collection = collectState ? @"1" : @"0";
        }
    }
}

-(void)updateBadgeNum{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger badgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badgeNum != 0) {
//            [self.tabBarController.tabBar showBadgeOnItemIndex:2];
            [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat: @"%ld", (long)badgeNum]];
        }else{
//            [self.tabBarController.tabBar hideBadgeOnItemIndex:2];
            [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
        }
    });
}
@end
