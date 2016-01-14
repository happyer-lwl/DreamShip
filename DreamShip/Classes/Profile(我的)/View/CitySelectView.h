//
//  CitySelectView.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/12.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CitySelectViewDelegate <NSObject>

-(void)confirmPickerViewSelected:(NSString *)addr;

@end

@interface CitySelectView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

+(instancetype)citiSelectView;
@property (nonatomic, weak) id<CitySelectViewDelegate> delegate;
@end
