//
//  UIImageView+GCDCash.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/31.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "UIImageView+GCDCash.h"

@implementation UIImageView (GCDCash)

+(void)setImageForImageView:(UIImageView *)imageView imageURL:(NSURL *)imageUrl{
    NSURL *url = imageUrl;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:(NSURLRequestReloadIgnoringCacheData) timeoutInterval:10];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = image;
        });
    });
}
@end
