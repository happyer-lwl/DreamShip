//
//  UIImage+CLAdditions.h
//  CLCropImage
//
//  Created by chuliangliang on 16/1/18.
//  Copyright © 2016年 chuliangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CLAdditions)
/*垂直翻转*/
- (UIImage *)flipVertical;

/*水平翻转*/
- (UIImage *)flipHorizontal;

/*改变size*/
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

/*裁切*/
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

@end
