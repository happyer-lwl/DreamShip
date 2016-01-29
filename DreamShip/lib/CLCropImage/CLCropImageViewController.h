//
//  CLCropImageViewController.h
//  CLCropImage
//
//  Created by chuliangliang on 16/1/18.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLCropImageViewController;
@protocol clCropImageViewControllerDlegate <NSObject>
@optional
- (void)clCropImageViewController:(CLCropImageViewController *)cropImageViewController didFinish:(UIImage *)image;
- (void)clCropImageViewControllerDidCancel:(CLCropImageViewController *)cropImageViewController;
@end


@interface CLCropImageViewController : UIViewController
@property (strong, nonatomic, readonly) UIImage *originalImage;
@property (assign, nonatomic) id<clCropImageViewControllerDlegate> delegate;
- (id)initWithImage:(UIImage *)image;
@end

