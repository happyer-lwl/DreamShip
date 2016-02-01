//
//  DiscoverViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/17.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "DiscoverViewController.h"
#import "SingleChatVC.h"
#import "GroupsListVC.h"
#import "PersonDetailVC.h"
#import "UITabBar+littleRedDotBadge.h"
#import "GroupChatUserListVC.h"
#import "GroupChatVC.h"

#import "AccountModel.h"
#import "AccountTool.h"

#import <RongIMKit/RongIMKit.h>

@interface DiscoverViewController()

@property (nonatomic, strong) REMenu *menu;

@end

@implementation DiscoverViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_GROUP)]];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self initGroupMenu];
    
    UIBarButtonItem *addGroup = [[UIBarButtonItem alloc] initWithTitle:@"Group" style:UIBarButtonItemStyleDone target:self action:@selector(groupCreate)];
    self.navigationItem.rightBarButtonItem = addGroup;
}

-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger AppIconBadgeNum = [UIApplication sharedApplication].applicationIconBadgeNumber - model.unreadMessageCount;
    [UIApplication sharedApplication].applicationIconBadgeNumber = AppIconBadgeNum;
    [kNotificationCenter postNotificationName:kNotificationUpdataBadge object:nil];
    
    if (model.conversationType == ConversationType_GROUP) {
        GroupChatVC *conVC = [[GroupChatVC alloc] initWithConversationType:ConversationType_GROUP targetId:model.targetId];
        
        conVC.userName = model.conversationTitle;
        conVC.title = model.conversationTitle;
        conVC.targetId = model.targetId;
        conVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:conVC animated:YES];
    } else if (model.conversationType == ConversationType_PRIVATE){
        SingleChatVC *conVC = [[SingleChatVC alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
        
        conVC.userName = model.conversationTitle;
        conVC.title = model.conversationTitle;
        conVC.targetId = model.targetId;
        conVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:conVC animated:YES];
    }
}

-(void)didTapCellPortrait:(RCConversationModel *)model{
    if (model.conversationType == ConversationType_GROUP) {
        
    } else if (model.conversationType == ConversationType_PRIVATE){
        PersonDetailVC *detailVC = [[PersonDetailVC alloc] init];
        
        [SingleChatVC getUserWithUserID:model.targetId finish:^(DSUser *user) {
            detailVC.user = user;
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }];
    }
}

-(void)initGroupMenu{
    __weak typeof (self) weakSelf = self;
    
    REMenuItem *groups = [[REMenuItem alloc] initWithTitle:@"群组" image:[UIImage imageNamed:@"avatar_default_small"] backgroundColor:kBtnFireColorNormal highlightedImage:nil action:^(REMenuItem *item) {
        
        GroupsListVC *groupList = [[GroupsListVC alloc] init];
        [weakSelf.navigationController pushViewController:groupList animated:YES];
    }];
    
    REMenuItem *newGroup = [[REMenuItem alloc] initWithTitle:@"建群" image:[UIImage imageNamed:@"avatar_default_small"] backgroundColor:kBtnFireColorNormal highlightedImage:nil action:^(REMenuItem *item) {
        
        GroupChatUserListVC *groupVC = [[GroupChatUserListVC alloc] init];
        [weakSelf.navigationController pushViewController:groupVC animated:YES];
        
    }];
    
    self.menu = [[REMenu alloc] initWithItems:@[groups, newGroup]];
    
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    
    self.menu.separatorOffset = CGSizeMake(15.0, 0.0);
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    self.menu.delegate = self;
    
    [self.menu setClosePreparationBlock:^{
        NSLog(@"Menu will close");
    }];
    
    [self.menu setCloseCompletionHandler:^{
        NSLog(@"Menu did close");
    }];
}

-(void)groupCreate{
    if (self.menu.isOpen) {
        return [self.menu close];
    }

    [self.menu showFromNavigationController:self.navigationController];
}
@end
