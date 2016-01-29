//
//  ProfileUserPointsVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/26.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "ProfileUserPointsVC.h"
#import "AccountModel.h"
#import "AccountTool.h"
#import "HttpTool.h"

@interface ProfileUserPointsVC(){
    double circleAdd;
}

@property (nonatomic, weak) UILabel *pointsLabel;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) NSTimer *timer;


@end
@implementation ProfileUserPointsVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"梦想积分";
    self.view.backgroundColor = kViewBgColor;
    
    circleAdd = 0.1;
    [self setSubviews];
    [self circleAnimation];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateCircle) userInfo:nil repeats:YES];
}

-(void)setSubviews{
    AccountModel *account = [AccountTool account];
 
    UILabel *label = [[UILabel alloc] init];
    
    NSString *suffix = @"，你现在拥有的积分:";
    NSString *titleStr = [NSString stringWithFormat:@"%@%@", account.userRealName, suffix];
    // 创建一个带有属性的字符串
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:titleStr];
    // 添加一个属性
    [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range: [titleStr rangeOfString:suffix]];
    [attriText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range: [titleStr rangeOfString:account.userRealName]];
    label.attributedText = attriText;
    label.frame = CGRectMake(20, 100, kScreenWidth - 40, 30);
    label.textColor = kTitleFireColorNormal;
    label.numberOfLines = 0;
    [self.view addSubview:label];

    UILabel *pointsLabel = [[UILabel alloc] init];
    pointsLabel.x = 60;
    pointsLabel.y = 215;
    pointsLabel.width = kScreenWidth - 50;
    pointsLabel.height = 30;
    pointsLabel.textAlignment = NSTextAlignmentCenter;
    pointsLabel.text = @"";
    pointsLabel.textColor = kTitleFireColorNormal;
    pointsLabel.font = [UIFont systemFontOfSize:30];
    self.pointsLabel = pointsLabel;
    [self.view addSubview:pointsLabel];
    [self.view bringSubviewToFront:pointsLabel];

    UITextView *aboutlabel = [[UITextView alloc] init];
    aboutlabel.frame = CGRectMake(25, 310, kScreenWidth - 25, 200);
    aboutlabel.backgroundColor = kViewBgColor;
    aboutlabel.text = @"积分用途:\nO(∩_∩)O~这个暂时还不能说，加油得积分吧!\n\n如何获取:\n每发表一次梦想会获得3积分";
    aboutlabel.textColor = kTitleFireColorNormal;
    aboutlabel.font = [UIFont systemFontOfSize:16];
    aboutlabel.editable = NO;
    [self.view addSubview:aboutlabel];
}

-(void)getUserPoints{
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"getUserPoints";
    params[@"user_id"] = account.userID;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary *json) {
        NSString *result = [json[@"result"] stringValue];
        
        if ([result isEqualToString:@"200"]) {
            NSString *points = json[@"data"];
            self.pointsLabel.text = [NSString stringWithFormat:@"%@ P", points];
        }else{
            self.pointsLabel.text = @"Zero P";
        }
    } failure:^(NSError *error) {
        self.pointsLabel.text = @"ಥ_ಥ";
    }];
}

-(void)circleAnimation{
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, 160, 160);
    self.shapeLayer.position = CGPointMake(kScreenWidth - 150, 230);
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    // 设置线条的宽度和颜色
    self.shapeLayer.lineWidth = 15.0;
    self.shapeLayer.strokeColor = kTitleFireColorNormal.CGColor;
    
    // 设置stroke 起点
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd = 0;
    // 创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 160, 160)];
    // 让贝塞尔曲线与CAShapeLayer产生联系
    self.shapeLayer.path = circlePath.CGPath;
    
    // 添加并显示
    [self.view.layer addSublayer:self.shapeLayer];
}

-(void)updateCircle{
    if (self.shapeLayer.strokeEnd > 1 && self.shapeLayer.strokeStart < 1) {
        [self.timer invalidate];
        [self getUserPoints];
    }else if(self.shapeLayer.strokeStart == 0 && self.shapeLayer.strokeEnd != 1){
        self.shapeLayer.strokeEnd += circleAdd;
    }
    
    if (self.shapeLayer.strokeEnd == 0) {
        self.shapeLayer.strokeStart = 0;
    }
    
    if (self.shapeLayer.strokeStart == self.shapeLayer.strokeEnd) {
        self.shapeLayer.strokeEnd = 0;
    }
}

@end
