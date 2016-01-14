//
//  HomeDetailVC.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/30.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSHomeViewCell.h"
#import "CommentToolBarView.h"

#define kUpdateCellInfoFromCell @"UpdateCellInfoFromCell"

@class DSDreamFrame;
@interface HomeDetailVC : UIViewController<UITableViewDataSource, UITableViewDelegate, DSHomeCellDelegate, CommentToolBarDelegate>

@property (nonatomic, strong) DSDreamFrame *dreamFrame;

-(void)setDreamFrame:(DSDreamFrame *)dreamFrame;

@end
