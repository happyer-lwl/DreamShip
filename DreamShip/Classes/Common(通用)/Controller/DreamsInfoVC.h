//
//  DreamsInfoVC.h
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/13.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DSHomeViewCell.h"

@class DSUser;
@interface DreamsInfoVC : UIViewController<UITableViewDataSource, UITableViewDelegate, DSHomeCellDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) DSUser *user;
@property (nonatomic, copy) NSString *api_type;

@end
