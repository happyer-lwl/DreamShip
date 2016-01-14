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
#import "ComposeToolBar.h"

@interface ComposeDreamVC ()

@property (nonatomic, weak) PlaceHolderTextView *textView;
@property (nonatomic, weak) UIImageView *photoView;

@property (nonatomic, weak) UIBarButtonItem *composeDream;
@property (nonatomic, weak) ComposeToolBar *toolBar;

@property (nonatomic, weak) UISegmentedControl *dreamTypeSeg;
@end

@implementation ComposeDreamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kViewBgColor;
    
    [self setNavigationView];
    [self setDreamTypeSegView];
    [self setInputView];
    [self setPhotoView];
    [self setToolBar];
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
        [attriText addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:[titleStr rangeOfString:name]];
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

-(void)setDreamTypeSegView{
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"认真做梦", @"组队寻友", @"拉拉投资"]];
    seg.frame = CGRectMake(0, 0, 160, 25);
    seg.backgroundColor = kTitleDarkBlueColor;
    seg.selectedSegmentIndex = 0;
    seg.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = seg;
    [seg addTarget:self action:@selector(dreamTypeSegChanged) forControlEvents:UIControlEventValueChanged];
    _dreamTypeSeg = seg;
}

-(void)dreamTypeSegChanged{
    [self.textView becomeFirstResponder];
}
/**
 *  发送梦想
 */
-(void)composeADream{
    AccountModel *model = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"user_id"] = model.userID;
    params[@"text"] = self.textView.text;
    params[@"time"] = [CommomToolDefine currentDateStr];
    params[@"type"] = [NSNumber numberWithInteger:self.dreamTypeSeg.selectedSegmentIndex + 1];
    
    if (self.photoView.image) {
        [self composeDreamWithPhoto:params];
    }else{
        [self composeDreamWithoutPhoto:params];
    }
}

-(void)composeDreamWithoutPhoto:(NSMutableDictionary *)params{
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = @"composeDream";

    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        DBLog(@"%@", json);
        [MBProgressHUD showSuccess:@"发表成功"];
        [kNotificationCenter postNotificationName:kNotificationComposed object:nil];
        [self performSelector:@selector(cancelView) withObject:self afterDelay:1];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
    }];
}

-(void)composeDreamWithPhoto:(NSMutableDictionary *)params{
    params[@"api_uid"] = @"dreams";
    params[@"api_type"] = @"composeDream";
    
    UIImage *newImage = [self scaleToSize:self.photoView.image size:CGSizeMake(500, 500)];
    
    NSData *data = nil;
    NSString *imageName = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    if (UIImagePNGRepresentation(newImage) == nil) {
        data = UIImageJPEGRepresentation(newImage, 1);
        imageName = [NSString stringWithFormat:@"%@.jpg", dateStr];
    }else{
        data = UIImagePNGRepresentation(newImage);
        imageName = [NSString stringWithFormat:@"%@.png", dateStr];
    }
    
    NSMutableDictionary *paramsTemp = nil;
    
    params[@"pic"] = data;
    params[@"imageName"] = imageName;
    
    DBLog(@"%@", data);
    
    [HttpTool postWithUrl:[NSString stringWithFormat:@"%@", Host_Url] params:params success:^(NSDictionary* json) {
        [MBProgressHUD showSuccess:@"发表成功"];
        [kNotificationCenter postNotificationName:kNotificationComposed object:nil];
        [self performSelector:@selector(cancelView) withObject:self afterDelay:1];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
    }];
    
//    [HttpTool posWithUrl:@"http://192.168.1.101/imageUpload_dream.php" params:paramsTemp data:data name:@"pic" fileName:@"hello.png" type:@"image/png" success:^(NSDictionary *json) {
//        DBLog(@"%@", json);
//        [MBProgressHUD showSuccess:@"发表成功"];
//        [kNotificationCenter postNotificationName:kNotificationComposed object:nil];
//        [self performSelector:@selector(cancelView) withObject:self afterDelay:1];
//    } failuer:^(NSError *error) {
//        DBLog(@"Error %@", error.description);
//    }];
}

/**
 缩放
 */
-(UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
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
    textView.placehoder = @"做个梦吧...";
    [self.view addSubview:textView];
    
    self.textView = textView;
    
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
    NSDictionary *userInfo = notification.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyBoardF = [userInfo[UIKeyboardFrameEndUserInfoKey ] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.y = keyBoardF.origin.y - self.toolBar.height - 64;
        
        DBLog(@"%f", self.toolBar.y);
    }];
}

-(void)setToolBar{
    ComposeToolBar *toolBar = [ComposeToolBar toolBar];
    toolBar.delegate = self;
    toolBar.width = kScreenWidth;
    toolBar.height = 44;
    toolBar.y = self.view.height - toolBar.height - 64;
    self.toolBar = toolBar;
    
    [self.view addSubview:toolBar];
}
/**
 *  设置图片位置
 */
-(void)setPhotoView{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.y = 120;
    photoView.x = 10;
    photoView.width = 150;
    photoView.height = 150;
    [self.textView addSubview:photoView];
    
    self.photoView = photoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark ScrollDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.textView endEditing:YES];
}

#pragma mark ComposeToolBarDelegate
-(void)ComposeToolBarClickedWithTag:(ComposeToolbarButtonType)tag{
    switch (tag) {
        case eComposeToolbarButtonTypeCamera:
            [self getPicFromCamera];
            break;
        case eComposeToolbarButtonTypePicture:
            [self getPicFromPhotoAlbum];
            break;
        case eComposeToolbarButtonTypeEmotion:
            [self insertEmotion];
            break;
        default:
            break;
    }
}

-(void)getPicFromCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

-(void)getPicFromPhotoAlbum{
    [self openImagePickerController:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
}

-(void)insertEmotion{
    
}

-(void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark  UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *picImage = info[UIImagePickerControllerOriginalImage];
    
    self.photoView.image = picImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
