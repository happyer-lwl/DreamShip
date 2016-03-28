//
//  RegisterNoticeViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "RegisterNoticeViewController.h"
#import "DSHtmlItem.h"
#import "TableGroupModel.h"

@interface RegisterNoticeViewController()

@property (nonatomic, strong) NSMutableArray *htmls;

@end

@implementation RegisterNoticeViewController

-(NSMutableArray *)htmls{
    if (_htmls == nil) {
        _htmls = [NSMutableArray array];
        
        NSString *htmlFfile = [[NSBundle mainBundle] pathForResource:@"help.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:htmlFfile];

        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dict in jsonArray) {
            DSHtmlItem *html = [DSHtmlItem htmlWithDict:dict];
            [_htmls addObject:html];
        }
    }
    
    return _htmls;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(closeView)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background_fire"] forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    
    [self htmls];
    // 取出每一行对应的Html模型
//    DSHtmlItem *html = self.htmls[0];
    self.navigationItem.title = @"梦扬的协议";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dsnotice.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];

    [self.view addSubview:webView];
}

-(void)closeView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
