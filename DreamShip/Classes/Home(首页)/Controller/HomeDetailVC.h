//
//  HomeDetailVC.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/30.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSDreamFrame;
@interface HomeDetailVC : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DSDreamFrame *dreamFrame;

-(void)setDreamFrame:(DSDreamFrame *)dreamFrame;

@end
