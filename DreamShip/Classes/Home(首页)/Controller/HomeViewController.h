//
//  HomeViewController.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DSHomeViewCell.h"

@class DSDreamModel;
@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DSHomeCellDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) DreamRange dreamRange;
@property (nonatomic, assign) DSDreamModel *dreamModel;

@end
