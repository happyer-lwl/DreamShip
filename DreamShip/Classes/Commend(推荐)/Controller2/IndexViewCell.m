//
//  IndexViewCell.m
//  Door
//
//  Created by 刘伟龙 on 15/12/8.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "IndexViewCell.h"

@interface IndexViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IndexViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 20)];
        imageView.contentMode = UIViewContentModeCenter;
        _imageView = imageView;
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame), frame.size.width, 20);
        label.contentMode = UIViewContentModeBottom;
        [label setTextAlignment:NSTextAlignmentCenter];
        _label = label;
        [self addSubview:label];
    }
    
    return self;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    
    self.imageView.image = image;
}

-(void)setLabel:(UILabel *)label{
    _label = label;
    
    [self.imageView addSubview:label];
}
@end
