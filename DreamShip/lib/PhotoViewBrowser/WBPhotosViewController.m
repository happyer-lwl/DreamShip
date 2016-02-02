//
//  NewFeatureViewController.m
//  SinaWeibo
//
//  Created by 刘伟龙 on 15/11/28.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "WBPhotosViewController.h"
#import "UIImageView+WebCache.h"

#define kNewFeaturePages 4

@interface WBPhotosViewController()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, assign) int curIndex;

@end

@implementation WBPhotosViewController

-(void)setPhotos:(NSArray *)photos{
    _photos = [NSArray arrayWithArray:photos];
}

-(NSMutableArray *)imageViews{
    if (_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        UIScrollView *scroll = [[UIScrollView alloc]init];
        scroll.backgroundColor = [UIColor blackColor];
        scroll.frame = self.view.bounds;
        
        _scrollView = scroll;
        [self.view addSubview:_scrollView];
        
        int countPhoto = _photos.count;
        
        CGFloat scrollW = _scrollView.width;
        CGFloat scrollH = _scrollView.height;
        for (int i = 0; i < countPhoto; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.width = scrollW;
            imageView.height = scrollH;
            imageView.x = scrollW * i;
            imageView.y = 0;
            //imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d", i + 1]];
            NSString *url = [_photos objectAtIndex:i];
            url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            if (i == 3) {
//                [self setLastImageView:imageView];
//            }
            
            [self.imageViews addObject:imageView];
            [_scrollView addSubview:imageView];
        }
        
#warning Scroll 里面不只有自己添加的几个图片View，还要系统自带的子控件

        // 设置Scroll的其他属性
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(countPhoto * scrollW, _scrollView.height  *3);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
        // 设置监听
        _scrollView.delegate = self;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollTouched)];
        gesture.numberOfTouchesRequired = 1;
        gesture.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:gesture];
        
        UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollDoubleTouched)];
        gesture2.numberOfTouchesRequired = 1;
        gesture2.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:gesture2];
        [gesture requireGestureRecognizerToFail:gesture2];
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
        pageControl.y = _scrollView.height - 20;
        pageControl.numberOfPages = _photos.count;
        pageControl.currentPageIndicatorTintColor = RGBColor(253, 98, 42);
        pageControl.pageIndicatorTintColor = RGBColor(189, 189, 189);
        
        _pageControl = pageControl;
        [self.view addSubview:_pageControl];
    }
    
    return _pageControl;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[SDWebImageManager sharedManager].imageCache clearDisk];
    
    self.view.userInteractionEnabled = YES;
    
    [self scrollView];
    [self pageControl];
}

-(void)scrollTouched{
    DBLog(@"One Clicked!");
    [UIView animateWithDuration:0.5 animations:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    } completion:nil];
    
}

-(void)scrollDoubleTouched{
    DBLog(@"Double Clicked!");
    static BOOL isScaled = NO;
    
    UIImageView *curImageView = [self.imageViews objectAtIndex:self.curIndex];
    
    if (!isScaled) {
        DBLog(@"Before %@", curImageView.frame);
        [UIView beginAnimations:nil context:@"Scale"];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseIn)];
        // 可以组合出现更多的效果
        // 放大
        self.view.transform = CGAffineTransformMakeScale(3, 3);
        // 旋转
        //[UIView setAnimationRepeatCount:10];
        //self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
        // 移动
        //self.view.transform = CGAffineTransformMakeTranslation(-50, -50);
        [UIView commitAnimations];
    }else{
        DBLog(@"After %@", curImageView.frame);
        [UIView beginAnimations:nil context:@"Scale"];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:(UIViewAnimationCurveEaseIn)];
        self.view.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
    }
    
    isScaled = !isScaled;
}

-(void)showPageViewAtIndex:(int)index{
    self.curIndex = index;
    
    CGPoint point = CGPointMake(index * kScreenWidth, 0);
    [self.pageControl setCurrentPage:index];
    [self.scrollView setContentOffset:point animated:YES];
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
  
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setLastImageView:(UIImageView *)imageView{
    // ImageView开启交互功能
    imageView.userInteractionEnabled = YES;
    
    // CheckBox 分享大家
    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    shareBtn.width = 150;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = CGRectGetMaxY(imageView.frame) - 200;
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//    shareBtn.titleEdgeInsets    影响文字
//    shareBtn.imageEdgeInsets    影响Image
//    shareBtn.contentEdgeInsets  影响按钮内部的所有内容 Image和Label
    
    
    UIButton *finishBtn = [[UIButton alloc]init];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:(UIControlStateNormal)];
    [finishBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:(UIControlStateHighlighted)];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [finishBtn setTitle:@"开始微博" forState:(UIControlStateNormal)];

    finishBtn.centerX = shareBtn.centerX - 50;
    finishBtn.centerY = _scrollView.height * 0.75;
    finishBtn.size = finishBtn.currentBackgroundImage.size;
    
    [finishBtn addTarget:self action:@selector(finishBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [imageView addSubview:finishBtn];
}

#pragma mark - ScrollContorll 代理实现
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.view.transform = CGAffineTransformIdentity;
    
    // 停下来的当前页数
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    // 计算页数
    double page = scrollView.contentOffset.x / scrollView.width;
    _pageControl.currentPage = (int)(page + 0.5);
}

@end
