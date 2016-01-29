//
//  DiscoverViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "DiscoverViewController.h"
#import "SingleChatVC.h"
#import "PersonDetailVC.h"
#import "UITabBar+littleRedDotBadge.h"

#import <RongIMKit/RongIMKit.h>

@implementation DiscoverViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_DISCUSSION)]];
    
    self.view.backgroundColor = [UIColor redColor];
}

-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    
    SingleChatVC *conVC = [[SingleChatVC alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
    
    conVC.userName = model.conversationTitle;
    conVC.title = model.conversationTitle;
    conVC.targetId = model.targetId;
    conVC.hidesBottomBarWhenPushed = YES;
    
    NSInteger AppIconBadgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber - model.unreadMessageCount;
    [UIApplication sharedApplication].applicationIconBadgeNumber = AppIconBadgeNum;
    [kNotificationCenter postNotificationName:kNotificationUpdataBadge object:nil];
    
    [self.navigationController pushViewController:conVC animated:YES];
}

-(void)didTapCellPortrait:(RCConversationModel *)model{
    PersonDetailVC *detailVC = [[PersonDetailVC alloc] init];
    
    [SingleChatVC getUserWithUserID:model.targetId finish:^(DSUser *user) {
        detailVC.user = user;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
}
@end
