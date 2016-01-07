//
//  SelfInfoSetWordsVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/27.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "SelfInfoSetWordsVC.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"

#import "TableGroupModel.h"
#import "TableItemModel.h"

@interface SelfInfoSetWordsVC ()

@property (nonatomic, weak)   UITextField     *wordsText;

@end

@implementation SelfInfoSetWordsVC

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
    self.title = @"个人签名";
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)saveInfo{
    AccountModel *model = [AccountTool account];

    if ([HttpTool saveUserInfo:model.userPhone mod_key:@"words" mod_value:self.wordsText.text]) {
        model.userWords = self.wordsText.text;
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
    UITextField *words = [[UITextField alloc] init];
    words.frame = CGRectMake(10, 0, kScreenWidth - 20, 40);
    words.placeholder = @"个人签名";
    words.text = model.userWords;
    words.font = [UIFont systemFontOfSize:16];
    words.backgroundColor = [UIColor whiteColor];
    words.clearButtonMode = UITextFieldViewModeWhileEditing;
    words.autocapitalizationType = UITextAutocapitalizationTypeNone;
    words.keyboardType = UIKeyboardTypeDefault;
    _wordsText = words;
    [words becomeFirstResponder];
    [kNotificationCenter addObserver:self selector:@selector(mailTextChanged) name:UITextFieldTextDidChangeNotification object:_wordsText];
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
    
    [cell.contentView addSubview:self.wordsText];
    
    return cell;
}
@end
