//
//  PersonOtherNameVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/21.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "PersonOtherNameVC.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "DSUser.h"
#import "HttpTool.h"

#import "TableGroupModel.h"
#import "TableItemModel.h"

@interface PersonOtherNameVC ()

@property (nonatomic, weak)   UITextField     *otherNameText;

@end

@implementation PersonOtherNameVC

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
    self.title = @"备注";
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)saveInfo{
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"modOtherName";
    
    params[@"user_id"] = account.userID;
    params[@"focused_user_id"] = self.user.user_id;
    params[@"other_name"] = self.otherNameText.text;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        [kNotificationCenter postNotificationName:kUpdateUserRemark object:self];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)setTableView{
    self.tableView.allowsSelection = NO;
}

-(void)setSubviews{
    AccountModel *model = [AccountTool account];
    
    // 用户邮箱
    UITextField *otherName = [[UITextField alloc] init];
    otherName.frame = CGRectMake(10, 0, kScreenWidth - 20, 40);
    otherName.placeholder = @"备注";
    otherName.text = self.otherName;
    otherName.font = [UIFont systemFontOfSize:16];
    otherName.backgroundColor = [UIColor whiteColor];
    otherName.clearButtonMode = UITextFieldViewModeWhileEditing;
    otherName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    otherName.keyboardType = UIKeyboardTypeEmailAddress;
    _otherNameText = otherName;
    
    [otherName becomeFirstResponder];
    [kNotificationCenter addObserver:self selector:@selector(mailTextChanged) name:UITextFieldTextDidChangeNotification object:_otherNameText];
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
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    [cell.contentView addSubview:self.otherNameText];
    
    return cell;
}

@end
