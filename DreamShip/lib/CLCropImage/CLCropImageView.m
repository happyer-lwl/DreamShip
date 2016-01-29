//
//  CLCropImageView.m
//  CLCropImage
//
//  Created by chuliangliang on 16/1/18.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import "CLCropImageView.h"
#import "UIImage+CLAdditions.h"

@interface CLCropImageView ()
{
    UIEdgeInsets        _imageInset;
    CGSize              _cropSize;

}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CLCropImageMaskView *maskView;
@property (strong, nonatomic) UIImage *image;

@end

@implementation CLCropImageView


-(UIImage *)fixOrientation:(UIImage *)aImage {
    if (aImage==nil || !aImage) {
        return aImage;
    }
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    UIImageOrientation orientation=aImage.imageOrientation;
    int orientation_=orientation;
    switch (orientation_) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);

        }
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
        }
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
        }
            break;
    }
    
    switch (orientation_) {
        case UIImageOrientationUpMirrored:
        {
            
        }
        case UIImageOrientationDownMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    //    aImage=img;
    //    img = nil;
    return img;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [[self scrollView] setFrame:self.bounds];
    [[self maskView] setFrame:self.bounds];
    
    if (CGSizeEqualToSize(_cropSize, CGSizeZero)) {
        [self setCropSize:CGSizeMake(100, 100)];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setDelegate:self];
        [_scrollView setBounces:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [[self scrollView] addSubview:_imageView];
    }
    return _imageView;
}

- (CLCropImageMaskView *)maskView {
    if (!_maskView) {
        _maskView = [[CLCropImageMaskView alloc] init];
        [_maskView setBackgroundColor:[UIColor clearColor]];
        [_maskView setUserInteractionEnabled:NO];
        [self addSubview:_maskView];
        [self bringSubviewToFront:_maskView];
    }
    return _maskView;
}

- (void)setImage:(UIImage *)image {
    if (image != _image) {
        _image = nil;
        _image = [self fixOrientation:image];
    }
    [[self imageView] setImage:_image];
    [self updateZoomScale];
}


//获取图片和显示视图宽度的比例系数
- (float)getImgWidthFactor {
    return   _cropSize.width / self.image.size.width;
}
//获取图片和显示视图高度的比例系数
- (float)getImgHeightFactor {
    return  _cropSize.height / self.image.size.height;
}

//获获取尺寸
- (CGSize)newSizeByoriginalSize:(CGSize)orgSize minSize:(CGSize)mSize
{
    if (orgSize.width <= 0 || orgSize.height <= 0) {
        return CGSizeZero;
    }
    
    CGSize newSize = CGSizeZero;
    if (orgSize.width < mSize.width || orgSize.height < mSize.height) {
        //按比例计算尺寸
        float bs = [self getImgWidthFactor];
        float newHeight = orgSize.height * bs;
        newSize = CGSizeMake(mSize.width, newHeight);
        
        if (newHeight < mSize.height) {
            bs = [self getImgHeightFactor];
            float newWidth = orgSize.width * bs;
            newSize = CGSizeMake(newWidth, mSize.height);
        }
    }else {
        
        newSize = orgSize;
    }
    return newSize;
}



- (void)updateZoomScale {
    CGSize img_show_size = [self newSizeByoriginalSize:_image.size minSize:_cropSize];
    CGFloat width = img_show_size.width;
    CGFloat height = img_show_size.height;

    
    
    CGFloat x = (CGRectGetWidth(self.bounds) - _cropSize.width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - _cropSize.height) / 2;
    CGFloat top = y;
    CGFloat left = x;
    CGFloat right = CGRectGetWidth(self.bounds)- _cropSize.width - x;
    CGFloat bottom = CGRectGetHeight(self.bounds)- _cropSize.height - y;
    
    UIEdgeInsets scr_inset = UIEdgeInsetsMake(top, left, bottom, right);
    _imageInset = scr_inset;
    [[self imageView] setFrame:CGRectMake(0, 0, width, height)];
    self.scrollView.contentSize = CGSizeMake(width, height);
    self.scrollView.contentInset = scr_inset;
    
    
    CGFloat xScale = _cropSize.width / width;
    CGFloat yScale = _cropSize.height / height;
    
    CGFloat min = MAX(xScale, yScale);
    CGFloat max = 1.0;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        max = 1.0 / [[UIScreen mainScreen] scale];
    }
    
    if (min > max) {
        min = max;
    }
    
    [[self scrollView] setMinimumZoomScale:min];
    [[self scrollView] setMaximumZoomScale:max + 3.0];
    [[self scrollView] setZoomScale:min animated:NO];
    self.scrollView.contentOffset = CGPointMake(0-scr_inset.left + (self.scrollView.contentSize.width - _cropSize.width) * 0.5, 0-scr_inset.top + (self.scrollView.contentSize.height - _cropSize.height) *0.5);
}

- (void)setCropSize:(CGSize)size {
    _cropSize = size;
    [[self maskView] setCropSize:_cropSize];
    [self updateZoomScale];
    
}

/**
 * 裁剪图片
 **/
- (UIImage *)cropImage {
    

    float widthFactor = _cropSize.width * (self.image.size.width/self.imageView.frame.size.width);
    float heightFactor = _cropSize.height * (self.image.size.height/self.imageView.frame.size.height);
    float factorX = (self.scrollView.contentOffset.x + (self.scrollView.bounds.size.width - _cropSize.width) * 0.5) * (self.image.size.width/self.imageView.frame.size.width);
    float factorY = (self.scrollView.contentOffset.y+ (self.scrollView.bounds.size.height - _cropSize.height) * 0.5) * (self.image.size.height/self.imageView.frame.size.height);
    
    UIImage *image = [_image cropImageWithX:factorX y:factorY width:widthFactor height:heightFactor];
    image = [image resizeToWidth:_cropSize.width height:_cropSize.height];

    
//    ////////////////////////////////////////////
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//            CGRect factoredRect = CGRectMake(factorX,factorY,widthFactor,heightFactor);
//            CGImageRef tmpImage = CGImageCreateWithImageInRect([_sourceImage CGImage], factoredRect);
//            
//            UIImage *cropImage = [UIImage imageWithCGImage:tmpImage];
//            CGImageRelease(tmpImage);
//            UIImage *fixImage = [self fixOrientation:cropImage];
//            self.view.userInteractionEnabled = YES;
//            if(self.doneCallback) {
//                self.doneCallback([fixImage compressedImage], NO);
//            }
//            [self endTransformHook];
//        });
//    });
//
    ////////////////////////////////////////////
    
    
    return image;
}

#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aX {
    return [self imageView];
}

- (void)dealloc {
    if (_scrollView) {
        _scrollView = nil;
    }
    if (_imageView) {
        _imageView = nil;
    }
    if (_maskView) {
        _maskView = nil;
    }
    if (_image ) {
        _image = nil;
    }
}

@end



#pragma KISnipImageMaskView

#define kMaskViewBorderWidth 2.0f

@implementation CLCropImageMaskView

- (void)setCropSize:(CGSize)size {
    CGFloat x = (CGRectGetWidth(self.bounds) - size.width) / 2;
    CGFloat y = (CGRectGetHeight(self.bounds) - size.height) / 2;
    _cropRect = CGRectMake(x, y, size.width, size.height);
    
    [self setNeedsDisplay];
}

- (CGSize)cropSize {
    return _cropRect.size;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 1, 1, 1, .6);
    CGContextFillRect(ctx, self.bounds);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextStrokeRectWithWidth(ctx, _cropRect, kMaskViewBorderWidth);
    
    CGContextClearRect(ctx, _cropRect);
}
@end
