//
//  SelfInfoSetMailVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/27.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "SelfInfoSetMailVC.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"

#import "TableGroupModel.h"
#import "TableItemModel.h"

@interface SelfInfoSetMailVC ()

@property (nonatomic, weak)   UITextField     *mailText;

@end

@implementation SelfInfoSetMailVC

-(id)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self setSubviews];
    [self setTableView];
}

-(void)setNavigationBar{
    self.title = @"邮箱";
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)saveInfo{
    AccountModel *model = [AccountTool account];

    if ([HttpTool saveUserInfo:model.userPhone mod_key:@"mail" mod_value:self.mailText.text]) {
        model.userMail = self.mailText.text;
        [AccountTool saveAccount:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTableView{
    self.tableView.allowsSelection = NO;
}

-(void)setSubviews{
    AccountModel *model = [AccountTool account];
    
    // 用户邮箱
    UITextField *mail = [[UITextField alloc] init];
    mail.frame = CGRectMake(10, 0, kScreenWidth - 20, 44);
    mail.placeholder = @"邮箱";
    mail.text = model.userMail;
    mail.font = [UIFont systemFontOfSize:16];
    mail.backgroundColor = [UIColor whiteColor];
    mail.clearButtonMode = UITextFieldViewModeWhileEditing;
    mail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mail.keyboardType = UIKeyboardTypeDefault;
    _mailText = mail;
    [kNotificationCenter addObserver:self selector:@selector(mailTextChanged) name:UITextFieldTextDidChangeNotification object:_mailText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark TextFieldDelegate
-(void)mailTextChanged{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark TableViewDelegate / TableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    [cell.contentView addSubview:self.mailText];
    
    return cell;
}
@end
