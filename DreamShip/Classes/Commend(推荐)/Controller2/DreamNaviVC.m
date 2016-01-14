//
//  DreamNaviVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/12.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "DreamNaviVC.h"
#import "IndexViewCell.h"

#import "DreamDirectsVC.h"
#import "DreamPersonsVC.h"
#import "DreamTeamsVC.h"
#import "DreamInvestorsVC.h"

#define kScrollImagePages 5

@interface DreamNaviVC()

@property (nonatomic, weak) UIImageView *headerView;
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *collectionContentArray;

@property (nonatomic, strong) NSTimer *timer;
@end

static NSString *ID = @"indexCell";

@implementation DreamNaviVC

-(NSArray *)collectionContentArray{
    if (_collectionContentArray == nil) {
        _collectionContentArray = [NSArray arrayWithObjects:@"梦想鸡汤",@"梦想达人",@"梦想团队", nil];
    }
    
    return _collectionContentArray;
}

-(UIScrollView *)scrollView{
    
    if (_scrollView == nil) {
        UIScrollView *scroll = [[UIScrollView alloc]init];
        CGFloat scrollX = 0;
        CGFloat scrollY = 1;
        scroll.frame = CGRectMake(scrollX, scrollY, kScreenWidth- 2 * scrollX, 130);
        
        _scrollView = scroll;
        [self.view addSubview:_scrollView];
        
        CGFloat scrollW = _scrollView.width;
        CGFloat scrollH = _scrollView.height;
        for (int i = 0; i < kScrollImagePages; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.width = scrollW;
            imageView.height = scrollH;
            imageView.x = scrollW * i;
            imageView.y = 0;
            imageView.backgroundColor = kViewBgColor;
            imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[ NSString  stringWithFormat:@"Dream%d", i%4] ofType:@"jpg"]];
            [_scrollView addSubview:imageView];
        }
        
#warning Scroll 里面不只有自己添加的几个图片View，还要系统自带的子控件
        
        // 设置Scroll的其他属性
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kScrollImagePages * scrollW, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        // 设置监听
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        // 添加PageControll 分页，展示目前看的是第几页
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        //    pageControl.width = 100;
        //    pageControl.height = 50;    // 如果没有高度，则没有背景，但子控件可以显示
        //    pageControl.userInteractionEnabled = NO;    //禁止点击，height设置为0，一样不能点击
        pageControl.x = _scrollView.width - 50;
        pageControl.y = _scrollView.height - 10;
        pageControl.numberOfPages = kScrollImagePages - 1;
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageControl.pageIndicatorTintColor = RGBColor(189, 189, 189);
        
        _pageControl = pageControl;
        [self.view addSubview:_pageControl];
    }
    
    return _pageControl;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBgColor;
    
    [self scrollView];
    [self pageControl];
    [self setHeaderView];
    [self setCollectionViewInfo];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updataNextImageList) userInfo:nil repeats:YES];
}

-(void)updataNextImageList{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + kScreenWidth, 0) animated:YES];
}
/**
 *  设置控制器头
 */
-(void)setHeaderView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), kScreenWidth, 0)];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DreamAndMoon" ofType:@"jpg"]];
    [self.view addSubview:imageView];
    self.headerView = imageView;
}

/**
 *  设置导航部分
 */
-(void)setCollectionViewInfo{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, kScreenWidth - 20, 130) collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    
    self.collectionView.backgroundColor = kViewBgColor;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[IndexViewCell class] forCellWithReuseIdentifier:ID];
    
    [self collectionContentArray];
    [self.collectionView reloadData];
}

#pragma mark UIScrollViewDelegate
#pragma mark - ScrollContorll 代理实现
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 停下来的当前页数
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    // 计算页数
    double page = scrollView.contentOffset.x / scrollView.width;
    _pageControl.currentPage = (int)(page + 0.5);
    
    if (scrollView.contentOffset.x == 4 * 375){
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }else if (scrollView.contentOffset.x == 3 * 375){
       [scrollView setContentOffset:CGPointMake(3 * 375, 0)];
    }
}

#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionContentArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWH = (kScreenWidth - 80) / 3;
    return CGSizeMake(cellWH, cellWH);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IndexViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.image = [UIImage imageNamed:@"help"];
//        cell.backgroundColor = [UIColor redColor];
    }else if (indexPath.row == 1){
        cell.image = [UIImage imageNamed:@"person"];
//        cell.backgroundColor = [UIColor blueColor];
    }else{
        cell.image = [UIImage imageNamed:@"team"];
//        cell.backgroundColor = [UIColor greenColor];
    }
    cell.label.text = [self.collectionContentArray objectAtIndex:indexPath.row];
    cell.label.textColor = kTitleDarkBlueColor;
    cell.label.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = nil;
    
    if (indexPath.row == 0) {
        vc = [[DreamDirectsVC alloc] init];
    }else if (indexPath.row == 1){
        vc = [[DreamPersonsVC alloc] init];
    }else if (indexPath.row == 2){
        vc = [[DreamTeamsVC alloc] init];
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
