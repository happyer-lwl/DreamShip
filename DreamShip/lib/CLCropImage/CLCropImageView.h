//
//  CLCropImageView.h
//  CLCropImage
//
//  Created by chuliangliang on 16/1/18.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLCropImageView : UIView <UIScrollViewDelegate>
- (void)setImage:(UIImage *)image;
- (void)setCropSize:(CGSize)size;
- (UIImage *)cropImage;

@end

@interface CLCropImageMaskView : UIView
{
    CGRect  _cropRect;
}
- (void)setCropSize:(CGSize)size;
- (CGSize)cropSize;

@end