//
//  AddUserSkillVC.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/27.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "AddUserSkillVC.h"
#import "PlaceHolderTextView.h"
#import "MainNavigationController.h"
#import "HttpTool.h"
#import "AccountModel.h"
#import "AccountTool.h"

@interface AddUserSkillVC()

@property (nonatomic, strong) UIImagePickerController *imagePickerPhotos;
@property (nonatomic, strong) UIImagePickerController *imagePickerCamera;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIImageView         *skillImageView;
@property (nonatomic, weak) UIButton            *imageChoseButton;
@property (nonatomic, weak) UIButton            *openCameraButton;
@property (nonatomic, weak) UIButton            *openPhotosButton;
@property (nonatomic, weak) UITextField         *skillName;
@property (nonatomic, weak) PlaceHolderTextView *skillDetail;
@property (nonatomic, weak) UITextField         *skillPrice;
@property (nonatomic, weak) UIButton            *saveButton;

@property (nonatomic, weak) UISwitch            *buySwitch;
@end

@implementation AddUserSkillVC

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        CGFloat scale = 1.0;
        if (iPhone4) {
            scale = 1.3;
        }else if (iPhone5){
            scale = 1.1;
        }
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = self.view.bounds;
        scrollView.contentSize = CGSizeMake(0, kScreenHeight * scale);
        scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        
        // 技能图片介绍
        CGFloat padding = 10;
        CGFloat skillChoseBtnWH = 80;
        UIImageView *skillImage = [[UIImageView alloc] initWithFrame:CGRectMake(padding, padding * 2, kScreenWidth - padding * 2, skillChoseBtnWH * 2)];
        skillImage.backgroundColor = kViewBgColorDarker;
        _skillImageView = skillImage;
        skillImage.layer.cornerRadius = 3;
        skillImage.layer.masksToBounds = YES;
        skillImage.userInteractionEnabled = YES;
        [self.scrollView addSubview:skillImage];
        
        // 技能图片选择按键
        UIButton *choseButton = [[UIButton alloc] init];
        choseButton.frame = CGRectMake((skillImage.width - skillChoseBtnWH) / 2, (skillImage.height - skillChoseBtnWH) / 2, skillChoseBtnWH, skillChoseBtnWH);
        choseButton.layer.cornerRadius = skillChoseBtnWH/2;
        choseButton.layer.borderColor = [UIColor whiteColor].CGColor;
        choseButton.layer.borderWidth = 2;
        choseButton.layer.masksToBounds = YES;
        [choseButton setBackgroundImage:[UIImage imageNamed:@"skill_image"] forState:UIControlStateNormal];
        choseButton.imageView.contentMode = UIViewContentModeCenter;
        choseButton.backgroundColor = [UIColor colorWithRed:210/256.0 green:210/256.0 blue:210/256.0 alpha:0.5];
        [choseButton addTarget:self action:@selector(choseSkillImage) forControlEvents:UIControlEventTouchUpInside];
        [self.skillImageView addSubview:choseButton];
        
        // 打开照相机按键
        CGFloat centerX = kScreenWidth / 2.0;
        UIButton *cameraButton = [[UIButton alloc] init];
        cameraButton.frame = CGRectMake(centerX - 150, choseButton.y + padding, skillChoseBtnWH, skillChoseBtnWH);
        cameraButton.layer.cornerRadius = 2;
        [cameraButton setTitleColor:kTitleFireColorHighlighted forState:UIControlStateHighlighted];
        [cameraButton setBackgroundImage:[UIImage imageNamed:@"camera_open"] forState:UIControlStateNormal];
        cameraButton.imageView.contentMode = UIViewContentModeCenter;
        [cameraButton addTarget:self action:@selector(openCameraButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.skillImageView addSubview:cameraButton];
        cameraButton.hidden = YES;
        _openCameraButton = cameraButton;

        // 打开相册按键
        UIButton *photoButton = [[UIButton alloc] init];
        photoButton.frame = CGRectMake(centerX + 50, choseButton.y + padding, skillChoseBtnWH, skillChoseBtnWH);
        photoButton.layer.cornerRadius = 2;
        [photoButton setTitleColor:kTitleFireColorHighlighted forState:UIControlStateHighlighted];
        [photoButton setBackgroundImage:[UIImage imageNamed:@"photos_open"] forState:UIControlStateNormal];
        photoButton.imageView.contentMode = UIViewContentModeCenter;
        [photoButton addTarget:self action:@selector(openPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.skillImageView addSubview:photoButton];
        photoButton.hidden = YES;
        _openPhotosButton = photoButton;
        
        UITextField *skillNameT = [[UITextField alloc] init];
        skillNameT.frame = CGRectMake(padding, CGRectGetMaxY(skillImage.frame) + padding, skillImage.width, 44);
        skillNameT.backgroundColor = kViewBgColor;
        skillNameT.textColor = kTitleFireColorNormal;
        skillNameT.placeholder = @"技能名称";
        skillNameT.layer.cornerRadius = 3;
        skillNameT.clearButtonMode = UITextFieldViewModeWhileEditing;
        skillNameT.keyboardType = UIKeyboardTypeDefault;
        skillNameT.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.scrollView addSubview:skillNameT];
        _skillName = skillNameT;
        
        PlaceHolderTextView *skillDetail = [[PlaceHolderTextView alloc] init];
        skillDetail.frame = CGRectMake(padding, CGRectGetMaxY(skillNameT.frame) + padding, kScreenWidth - padding * 2, 120);
        skillDetail.backgroundColor = kViewBgColor;
        skillDetail.textColor = kTitleFireColorNormal;
        skillDetail.placehoder = @"技能描述";
        skillDetail.placeholderColor = kViewBgColorPlaceHoder;
        skillDetail.font = [UIFont systemFontOfSize:17];
        skillDetail.layer.cornerRadius = 3;
        skillDetail.keyboardType = UIKeyboardTypeDefault;
        skillDetail.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self.scrollView addSubview:skillDetail];
        _skillDetail = skillDetail;
        
        UILabel *labelAllowBuy = [[UILabel alloc] init];
        labelAllowBuy.frame = CGRectMake(padding, CGRectGetMaxY(skillDetail.frame) + padding, 260, 50);
        labelAllowBuy.text = @"是否允许人民币购买";
        labelAllowBuy.textColor = kTitleFireColorNormal;
        labelAllowBuy.font = [UIFont systemFontOfSize:15];
        [self.scrollView addSubview:labelAllowBuy];
        
        UISwitch *buySwitch = [[UISwitch alloc] init];
        buySwitch.frame = CGRectMake(CGRectGetMidX(labelAllowBuy.frame) + padding, labelAllowBuy.y + padding, 70 - padding, 25);
        buySwitch.on = NO;
        buySwitch.tintColor = kBtnFireColorNormal;
        buySwitch.onTintColor = kBtnFireColorNormal;
        [buySwitch addTarget:self action:@selector(buySwitchChanged:) forControlEvents:UIControlEventValueChanged];
        self.buySwitch = buySwitch;
        [self.scrollView addSubview:buySwitch];
        
        UITextField *skillPriceT = [[UITextField alloc] init];
        skillPriceT.frame = CGRectMake(CGRectGetMaxX(buySwitch.frame) + padding, labelAllowBuy.y + padding / 2, kScreenWidth - buySwitch.x - buySwitch.width - padding * 2, 40);
        skillPriceT.backgroundColor = kViewBgColor;
        skillPriceT.textColor = kTitleFireColorNormal;
        skillPriceT.textAlignment = NSTextAlignmentCenter;
        skillPriceT.placeholder = @"价格";
        skillPriceT.layer.cornerRadius = 3;
        skillPriceT.clearButtonMode = UITextFieldViewModeWhileEditing;
        skillPriceT.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        skillPriceT.autocapitalizationType = UITextAutocapitalizationTypeNone;
        skillPriceT.returnKeyType = UIReturnKeyDone;
        skillPriceT.hidden = YES;
        [self.scrollView addSubview:skillPriceT];
        _skillPrice = skillPriceT;
        
        UIButton *saveButton = [[UIButton alloc] init];
        saveButton.frame = CGRectMake(padding * 3, CGRectGetMaxY(labelAllowBuy.frame) + padding * 2, kScreenWidth - padding * 6, 44);
        saveButton.layer.cornerRadius = 2;
        [saveButton setTitleColor:kTitleFireColorHighlighted forState:UIControlStateHighlighted];
        saveButton.backgroundColor = kBtnFireColorNormal;
        [saveButton setTitle:@"提交技能" forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(saveSkillButton) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:saveButton];
        _saveButton = saveButton;
    }
    
    return _scrollView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBgColor;
    
    [self setNavgationInfo];
    [self scrollView];
    [self setScrollViewInfo];
}

/**
 *  设置导航栏信息
 */
-(void)setNavgationInfo{
    self.title = @"添加技能";
}

/**
 *  设置滚动view内容
 */
-(void)setScrollViewInfo{
    
}

/**
 *  选择技能标识图片
 */
-(void)choseSkillImage{
    [self setCameraAndPhotoButtonShow:self.openCameraButton.hidden];
}

-(void)setCameraAndPhotoButtonShow:(BOOL)bShow{
    [UIView animateWithDuration:0.5 animations:^{
        self.openCameraButton.hidden = !bShow;
        self.openPhotosButton.hidden = !bShow;
    }];
}

-(void)openCameraButtonClick{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background_fire"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [imagePicker.navigationBar setTitleTextAttributes:dict];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    _imagePickerCamera = imagePicker;
    
    [self setCameraAndPhotoButtonShow:NO];
}

-(void)openPhotoButtonClick{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background_fire"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [imagePicker.navigationBar setTitleTextAttributes:dict];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    _imagePickerPhotos = imagePicker;
    
    [self setCameraAndPhotoButtonShow:NO];
}

#pragma mark imagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = nil;
    if (picker == self.imagePickerCamera) {
        image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }else if (picker == self.imagePickerPhotos){
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    RSKImageCropViewController *curImageVC = [[RSKImageCropViewController alloc] initWithImage:image];
    curImageVC.delegate = self;
    [curImageVC setCropImageRect:CGRectMake(10, kScreenHeight / 2 - 80, kScreenWidth - 20, 160)];
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:curImageVC];
    nav.title = @"截取照片";
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage{
    self.skillImageView.image = croppedImage;
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  是否允许人民币购买
 *
 *  @param buySwitch
 */
-(void)buySwitchChanged:(UISwitch *)buySwitch{
    self.skillPrice.hidden = !buySwitch.isOn;
}

/**
 *  保存技能
 */
-(void)saveSkillButton{
    [MBProgressHUD showMessage:@"正在发送"];
    
    AccountModel *account = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"api_uid"] = @"users";
    params[@"api_type"] = @"commitUserSkill";
    params[@"user_id"] = account.userID;
    params[@"skills"] = self.skillName.text;
    params[@"detail"] = self.skillDetail.text;
    params[@"canBeBuy"] = self.buySwitch.isOn ? [NSNumber numberWithInteger:1] : [NSNumber numberWithInteger:0];
    params[@"price"] = self.skillPrice.text.length ? self.skillPrice.text : @"0.0";
    
    if (self.skillImageView.image) {
        [self composeSkillWithPhoto:params];
    }else{
        [self composeSkillWithoutPhoto:params];
    }
}

-(void)composeSkillWithPhoto:(NSMutableDictionary *)params{
    __block UIImage* _newImage = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        _newImage = [CommomToolDefine scaleToSize:self.skillImageView.image size:CGSizeMake(kScreenWidth - 20, 160)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = nil;
            NSString *imageName = @"";
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYMMddHHmmss"];
            NSString *dateStr = [formatter stringFromDate:[NSDate date]];
            if (UIImagePNGRepresentation(_newImage) == nil) {
                data = UIImageJPEGRepresentation(_newImage, 1);
                imageName = [NSString stringWithFormat:@"%@.jpg", dateStr];
            }else{
                data = UIImagePNGRepresentation(_newImage);
                imageName = [NSString stringWithFormat:@"%@.png", dateStr];
            }
            
            params[@"image"] = data;
            params[@"imageName"] = imageName;
            
            DBLog(@"%@", data);
            
            [HttpTool postWithUrl:[NSString stringWithFormat:@"%@", Host_Url] params:params success:^(NSDictionary* json) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"发送成功"];
                [kNotificationCenter postNotificationName:kGetUserSkills object:nil];
                [self performSelector:@selector(dismissSelfView) withObject:self afterDelay:0.5];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
                DBLog(@"%@", error.description);
            }];
        });
    });
}

-(void)composeSkillWithoutPhoto:(NSMutableDictionary *)params{
    params[@"image"] = nil;
    params[@"imageName"] = nil;
    
    [HttpTool getWithUrl:Host_Url params:params success:^(NSDictionary* json) {
        DBLog(@"%@", json);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"发表成功"];
        [kNotificationCenter postNotificationName:kGetUserSkills object:nil];
        [self performSelector:@selector(dismissSelfView) withObject:self afterDelay:0.5];
    } failure:^(NSError *error) {
        DBLog(@"%@", error.description);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"网络错误"];
    }];
}

-(void)dismissSelfView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.skillPrice resignFirstResponder];
    [self.skillName resignFirstResponder];
    [self.skillDetail resignFirstResponder];
}
@end
