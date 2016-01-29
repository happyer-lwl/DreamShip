//
//  UserSkillShowVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/22.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "UserSkillShowVC.h"
#import "UserSkillModel.h"
#import "UserSkillCell.h"
#import "SingleChatVC.h"
#import "DSUser.h"
#import "UIImageView+WebCache.h"

@interface UserSkillShowVC ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *skillImageView;

@end

@implementation UserSkillShowVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setSubTableView];
    [self setSubChatView];
}

-(void)setSubTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSkillCellHeight) style:UITableViewStyleGrouped];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    _tableView = tableView;
    [self.view addSubview:tableView];
}

-(void)setSubChatView{
    UITextView *detailLabel = [[UITextView alloc] init];
    //detailLabel.backgroundColor = kViewBgColor;
    detailLabel.frame = CGRectMake(6, CGRectGetMaxY(self.tableView.frame), kScreenWidth - 20, kSkillCellHeight);
    
    NSString *prefix = @"简介:";
    NSString *detailStr = self.userSkill.detail;
    if (detailStr.length == 0)
        detailStr = @"暂时还没有哦";
    NSString *titleStr = [NSString stringWithFormat:@"%@\n%@", prefix, detailStr];
    // 创建一个带有属性的字符串
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:titleStr];
    // 添加一个属性
    [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range: [titleStr rangeOfString:prefix]];
    [attriText addAttribute:NSForegroundColorAttributeName value:kTitleFireColorNormal range:[titleStr rangeOfString:prefix]];
    [attriText addAttribute:NSForegroundColorAttributeName value:kViewBgColorDarkest range:[titleStr rangeOfString:detailStr]];
    [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range: [titleStr rangeOfString:detailStr]];
    detailLabel.editable = NO;
    detailLabel.attributedText = attriText;
    [self.view addSubview:detailLabel];
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.frame = CGRectMake(10, CGRectGetMaxY(detailLabel.frame), kScreenWidth - 20, 40);
    
    UIButton *buyButton = [[UIButton alloc] init];
    buyButton.frame = CGRectMake(0, 0, toolBar.width/2 - 2.5, toolBar.height);
    buyButton.layer.cornerRadius = 2;
    buyButton.backgroundColor = kBtnFireColorNormal;
    [buyButton setTitleColor:kViewBgColorDarker forState:UIControlStateHighlighted];
    if (self.userSkill.canBeBuy == 0) {
        [buyButton setTitle:@"只能交换" forState:UIControlStateNormal];
        buyButton.tag = 0;
    }else{
        [buyButton setTitle:[NSString stringWithFormat: @"购买 $%.1f", self.userSkill.price] forState:UIControlStateNormal];
        buyButton.tag = 1;
    }
    [buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:buyButton];
    
    UIButton *chatButton = [[UIButton alloc] init];
    chatButton.frame = CGRectMake(CGRectGetMaxX(buyButton.frame) + 5, 0, toolBar.width/2 - 2.5, toolBar.height);
    chatButton.layer.cornerRadius = 2;
    chatButton.backgroundColor = kBtnFireColorNormal;
    [chatButton setTitle:@"交流" forState:UIControlStateNormal];
    [chatButton setTitleColor:kViewBgColorDarker forState:UIControlStateHighlighted];
    [chatButton addTarget:self action:@selector(chatButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:chatButton];
    
    [self.view addSubview:toolBar];
    
    UIImageView *skillImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(toolBar.frame) + 10, kScreenWidth - 20, 160)];
    [skillImage sd_setImageWithURL:[NSURL URLWithString:self.userSkill.image] placeholderImage:nil];
    _skillImageView = skillImage;
    skillImage.layer.cornerRadius = 3;
    skillImage.layer.masksToBounds = YES;
    [self.view addSubview:skillImage];
}

-(void)buyButtonClick:(UIButton *)sender{
    if (sender.tag == 0) {
        UIAlertController *alert = [CommomToolDefine alertWithTitle:@"该技能只能交换，不能购买\n请与梦友交流" message:nil ok:^{
            [self chatButtonClick];
        } cancel:nil];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
    }
}

-(void)chatButtonClick{
    DSUser *user = self.userSkill.user;
    
    SingleChatVC *chatVC = [[SingleChatVC alloc] initWithConversationType:ConversationType_PRIVATE targetId:user.userRealName];
    chatVC.title = user.userRealName;
    chatVC.targetId = user.name;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSkillCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSkillCell *cell = [UserSkillCell cellWithTableView:tableView];
    cell.userSkillModel = self.userSkill;
    //cell.delegate = self;
    return cell;
}
@end
