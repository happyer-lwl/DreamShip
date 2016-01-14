//
//  DSHomeViewCell.h
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/22.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolBarView.h"

@class DSDreamFrame;

@protocol DSHomeCellDelegate <NSObject>

-(void)cellToolBarClickedWithTag:(NSInteger)tag dreamFrame:(DSDreamFrame*)dreamFrame;
-(void)cellUserIconClicked:(DSDreamFrame *)dreamFrame;
-(void)cellPhotoViewClicked:(DSDreamFrame *)dreamFrame;
-(void)cellCollectionClicked:(DSDreamFrame *)dreamFrame state:(BOOL)selected;

@end


@interface DSHomeViewCell : UITableViewCell<DSToolBarViewDelegate>

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) DSDreamFrame *dreamFrame;

@property (nonatomic, weak) id<DSHomeCellDelegate> delegate;
@end
