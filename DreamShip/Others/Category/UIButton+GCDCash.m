//
//  UIButton+GCDCash.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/31.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "UIButton+GCDCash.h"

@implementation UIButton (GCDCash)

-(void)setImageWithGCDURL:(NSURL *)imageURL forState:(UIControlState)state{
    NSURL *url = imageURL;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:(NSURLRequestReloadIgnoringCacheData) timeoutInterval:10];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:image forState:state];
        });
    });
}
@end
