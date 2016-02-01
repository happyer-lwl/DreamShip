//
//  NewFeatureViewController.m
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/11/28.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "MainTabbarController.h"

#define kNewFeaturePages 4

@interface NewFeatureViewController()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@end

@implementation NewFeatureViewController

-(UIScrollView *)scrollView{
    
    if (_scrollView == nil) {
        UIScrollView *scroll = [[UIScrollView alloc]init];
        scroll.frame = self.view.bounds;
        
        _scrollView = scroll;
        [self.view addSubview:_scrollView];
        
        CGFloat scrollW = _scrollView.width;
        CGFloat scrollH = _scrollView.height;
        for (int i = 0; i < 4; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.width = scrollW;
            imageView.height = scrollH;
            imageView.x = scrollW * i;
            imageView.y = 0;
            imageView.backgroundColor = kBtnFireColorNormal;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d", i + 1]];
            
            if (i == 3) {
                [self setLastImageView:imageView];
            }
            
            [_scrollView addSubview:imageView];
        }
        
#warning Scroll 里面不只有自己添加的几个图片View，还要系统自带的子控件

        // 设置Scroll的其他属性
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(kNewFeaturePages * scrollW, _scrollView.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
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
        pageControl.centerX =_scrollView.width * 0.5;
        pageControl.y = _scrollView.height - 50;
        pageControl.numberOfPages = 4;
        pageControl.currentPageIndicatorTintColor = RGBColor(253, 98, 42);
        pageControl.pageIndicatorTintColor = RGBColor(189, 189, 189);
        
        _pageControl = pageControl;
        [self.view addSubview:_pageControl];
    }
    
    return _pageControl;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [NSThread sleepForTimeInterval:kLaunchImageShowSec];
    
    [self scrollView];
    [self pageControl];
}

-(void)shareBtnClicked: (UIButton*)button{
    button.selected = !button.isSelected;
}

-(void)finishBtnClicked{
    DBLog(@"finish clicked");
    
    // 切换控制器方式
    // 1.push：依赖导航控制器，push操作控制器切换可逆，前控制器还在内存中
    // 2.Modal：空气切换可逆
    // 3.修改windows的rootViewController
    
    // 不建议，新特性控制器不会销毁
//    MainTabbarController *mainTabVC = [[MainTabbarController alloc]init];
//    [self presentViewController:mainTabVC animated:YES completion:nil];
  
    MainTabbarController *mainTabVC = [[MainTabbarController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = mainTabVC;
}

-(void)setLastImageView:(UIImageView *)imageView{
    // ImageView开启交互功能
    imageView.userInteractionEnabled = YES;

    UIButton *finishBtn = [[UIButton alloc]init];
    finishBtn.width = 150;
    finishBtn.height = 30;
    finishBtn.centerX = imageView.width * 0.7;
    finishBtn.centerY = CGRectGetMaxY(imageView.frame) - 120;
    finishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [finishBtn setBackgroundColor:[UIColor clearColor]];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [finishBtn setTitleColor:kTitleFireColorHighlighted forState:UIControlStateHighlighted];
    [finishBtn setTitle:@"梦 吧  Go" forState:(UIControlStateNormal)];
    
    [finishBtn addTarget:self action:@selector(finishBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [imageView addSubview:finishBtn];
}

#pragma mark - ScrollContorll 代理实现
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 停下来的当前页数
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    // 计算页数
    double page = scrollView.contentOffset.x / scrollView.width;
    _pageControl.currentPage = (int)(page + 0.5);
}

@end
