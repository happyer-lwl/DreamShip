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
#import "DreamChangeVC.h"
#import "DreamShowVC.h"

#define kScrollImagePages   5
#define kPartCellHeight     (kScreenHeight - 44) / 4

@interface DreamNaviVC()

@property (nonatomic, weak) UIImageView *headerView;
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *collectionImageArray;
@property (nonatomic, strong) NSArray *collectionContentArray;
@property (nonatomic, strong) NSArray *collectionClassArray;

@property (nonatomic, strong) NSTimer *timer;
@end

static NSString *ID = @"indexCell";

@implementation DreamNaviVC

-(NSArray *)collectionContentArray{
    if (_collectionContentArray == nil) {
        NSArray *section0 = @[@"逐梦令",@"追梦人",@"寻梦团"];
        NSArray *section1 = @[@"助梦人",@"技能交换吧",@"梦游吧"];
        _collectionContentArray = @[section0, section1];
    }
    
    return _collectionContentArray;
}

-(NSArray *)collectionClassArray{
    if (_collectionClassArray == nil) {
        NSArray *sectionClass0 = @[@"DreamDirectsVC", @"DreamPersonsVC", @"DreamTeamsVC"];
        NSArray *sectionClass1 = @[@"DreamInvestorsVC", @"DreamChangeVC", @"DreamShowVC"];
        _collectionClassArray = @[sectionClass0, sectionClass1];
    }
    
    return _collectionClassArray;
}

-(NSArray *)collectionImageArray{
    if (_collectionImageArray == nil) {
        NSArray *sectionClass0 = @[@"help", @"person", @"team"];
        NSArray *sectionClass1 = @[@"angle", @"change", @"successful"];
        _collectionImageArray = @[sectionClass0, sectionClass1];
    }
    
    return _collectionImageArray;
}

-(UIScrollView *)scrollView{
    
    if (_scrollView == nil) {
        UIScrollView *scroll = [[UIScrollView alloc]init];
        CGFloat scrollX = 0;
        CGFloat scrollY = 0;
        scroll.frame = CGRectMake(scrollX, scrollY, kScreenWidth- 2 * scrollX, kPartCellHeight);
        
        _scrollView = scroll;
        [self.view addSubview:_scrollView];
        
        CGFloat scrollW = _scrollView.width;
        CGFloat scrollH = _scrollView.height;
        for (int i = 0; i < kScrollImagePages; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.width = scrollW;
            imageView.height = kPartCellHeight;
            imageView.x = scrollW * i;
            imageView.y = 0;
            imageView.backgroundColor = kViewBgColor;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Dream%d", i%4]];
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
        pageControl.x = _scrollView.width - 50;
        pageControl.y = _scrollView.height - 10;
        pageControl.numberOfPages = kScrollImagePages - 1;
        pageControl.currentPageIndicatorTintColor = kPageControlCurColor;
        pageControl.pageIndicatorTintColor = kPageControlColor;
        
        _pageControl = pageControl;
        [self.view addSubview:_pageControl];
        [self.view bringSubviewToFront:_pageControl];
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
    
    //_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updataNextImageList) userInfo:nil repeats:YES];
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

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headerView.frame) + 10, kScreenWidth - 20, kPartCellHeight * 2) collectionViewLayout:flowLayout];
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
    //NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
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
    return self.collectionContentArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *sectionArr  = [self.collectionContentArray objectAtIndex:section];
    return sectionArr.count;
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
    NSArray *imageSection = [self.collectionImageArray objectAtIndex:indexPath.section];
    cell.image = [UIImage imageNamed:[imageSection objectAtIndex:indexPath.row]];
    
    NSArray *sectionArray = [self.collectionContentArray objectAtIndex:indexPath.section];
    
    cell.label.text = [sectionArray objectAtIndex:indexPath.row];
    cell.label.textColor = kViewTabbarNormal;
    cell.label.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = nil;
    
    NSArray *section = [self.collectionClassArray objectAtIndex:indexPath.section];
    Class obj = NSClassFromString([section objectAtIndex:indexPath.row]);
    if ([obj isSubclassOfClass:[UIViewController class]]) {
        vc = [[obj alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
