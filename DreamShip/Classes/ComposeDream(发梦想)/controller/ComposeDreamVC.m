//
//  ComposeDreamVCViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/31.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "ComposeDreamVC.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"

#import "PlaceHolderTextView.h"

@interface ComposeDreamVC ()

@property (nonatomic, weak) PlaceHolderTextView *textView;
@property (nonatomic, weak) UIBarButtonItem *composeDream;

@end

@implementation ComposeDreamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationView];
    [self setInputView];
}

/**
 *  设置导航栏
 */
-(void)setNavigationView{
    self.title = @"说出梦想";

    UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelView)];
    self.navigationItem.leftBarButtonItem = cancelBar;
    
    UIBarButtonItem *composeBar = [[UIBarButtonItem alloc] initWithTitle:@"做梦" style:UIBarButtonItemStyleDone target:self action:@selector(composeADream)];
    self.navigationItem.rightBarButtonItem = composeBar;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    _composeDream = composeBar;
    
    NSString *name = [AccountTool account].userRealName;
    NSString *prefix = @"追逐梦想";
    if (name) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.width = 200;
        titleLabel.height = 50;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        
        NSString *titleStr = [NSString stringWithFormat:@"%@\n%@", @"追逐梦想", name];
        // 创建一个带有属性的字符串
        NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:titleStr];
        
        // 添加一个属性
        [attriText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range: [titleStr rangeOfString:prefix]];
        [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range: [titleStr rangeOfString:name]];
        [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[titleStr rangeOfString:name]];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor grayColor];
        shadow.shadowOffset = CGSizeMake(0.5, 0.5 );
        shadow.shadowBlurRadius = 0.2;
        [attriText addAttribute:NSShadowAttributeName value:shadow range:[titleStr rangeOfString:name]];
        titleLabel.attributedText = attriText;
        
        self.navigationItem.titleView = titleLabel;
    }else{
        self.title = prefix;
    }
}

/**
 *  发送梦想
 */
-(void)composeADream{
    AccountModel *model = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = @"composeDream";
    params[@"user_id"] = model.userID;
    params[@"text"] = self.textView.text;
    params[@"time"] = [CommomToolDefine currentDateStr];
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        DBLog(@"%@", json);
        [MBProgressHUD showSuccess:@"发表成功"];
        [kNotificationCenter postNotificationName:kNotificationComposed object:nil];
        [self performSelector:@selector(cancelView) withObject:self afterDelay:1];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
    }];
}

/**
 *  关闭窗口
 */
-(void)cancelView{
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  设置输入框
 */
-(void)setInputView{
    PlaceHolderTextView *textView = [[PlaceHolderTextView alloc]init];
    textView.alwaysBounceVertical = YES;    //垂直方向上一直可以拖拽
    textView.delegate = self;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:20];
    textView.placehoder = @"说出你的梦想...";
    [self.view addSubview:textView];
    
    self.textView = textView;
    //[self.textView becomeFirstResponder];
    
    // 文字改变通知
    [kNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    // 键盘改变通知
    [kNotificationCenter addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)textDidChange{
    if (self.textView.hasText) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void)keyboardFrameChanged:(NSNotification *)notification{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
