//
//  CLCropImageViewController.m
//  CLCropImage
//
//  Created by chuliangliang on 16/1/18.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "CLCropImageViewController.h"
#import "CLCropImageView.h"
#define IOS7_CP [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

@interface CLCropImageViewController ()
@property (strong, nonatomic,readwrite)UIImage *originalImage;
@property (strong, nonatomic) CLCropImageView *cropImageView;
@end

@implementation CLCropImageViewController

- (id)initWithImage:(UIImage *)image
{
    self =[super init];
    if (self) {
        self.originalImage = image;
    }
    return self;
}
- (void)dealloc
{
    self.delegate = nil;
    self.originalImage = nil;
    self.cropImageView = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOS7_CP) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    self.cropImageView = [[CLCropImageView alloc] initWithFrame:self.view.bounds];
    [self.cropImageView setCropSize:CGSizeMake(kScreenWidth - 20, 160)];
    [self.cropImageView setImage:self.originalImage];
    [self.view addSubview:self.cropImageView];    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishCropping)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCropping)];
}

- (void)cancelCropping
{
    
    if ([self.delegate respondsToSelector:@selector(clCropImageViewControllerDidCancel:)]) {
        [self.delegate clCropImageViewControllerDidCancel:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishCropping
{
    UIImage *didEditImg =[_cropImageView cropImage];
    if ([self.delegate respondsToSelector:@selector(clCropImageViewController:didFinish:)]) {
        [self.delegate clCropImageViewController:self didFinish:didEditImg];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
