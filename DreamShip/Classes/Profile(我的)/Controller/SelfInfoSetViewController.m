//
//  SelfInfoSetViewController.m
//  DreamShip
//
//  Created by 刘伟龙 on 15/12/21.
//  Copyright © 2015年 lwl. All rights reserved.
//

#import "SelfInfoSetViewController.h"
#import "SelfInfoSetMailVC.h"
#import "SelfInfoSetSexyVC.h"

#import "UICustomTextField.h"
#import "AccountModel.h"
#import "AccountTool.h"

#import "TableItemModel.h"
#import "TableGroupModel.h"

#import "HttpTool.h"
#import "UIButton+WebCache.h"
#import "DataBaseSharedManager.h"

#define kTableTagMail 01
#define kTableTagSex  02

@interface SelfInfoSetViewController()

@property (nonatomic, strong) UIImagePickerController *imagePickerPhotos;
@property (nonatomic, strong) UIImagePickerController *imagePickerCamera;

@property (nonatomic, weak) UIButton *selfImageView;
@property (nonatomic, weak) UICustomTextField *nameText;

@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation SelfInfoSetViewController

-(NSMutableArray *)groups{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    
    return _groups;
}

-(id)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = kViewBgColor;

    [self setNavigationView];
    [self setTableView];
    
    [self setSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.groups removeAllObjects];
    [self setTableData];
    [self.tableView reloadData];
}
/**
 设置导航栏内容
 */
-(void)setNavigationView{
    self.navigationItem.title = @"个人资料设置";
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveSelfInfo)];
    self.navigationItem.rightBarButtonItem = saveBarButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

/**
 保存名称信息
 */
-(void)saveSelfInfo{
    AccountModel *model = [AccountTool account];
    
    if ([HttpTool saveUserInfo:model.userPhone mod_key:@"name" mod_value:self.nameText.text]) {
        model.userRealName = self.nameText.text;
        [AccountTool saveAccount:model];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.nameText resignFirstResponder];
    }
}

/**
 设置列表
 */
-(void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setTableData];
}

/**
 设置列表数据
 */
-(void)setTableData{
    TableGroupModel *group = [TableGroupModel group];
    AccountModel *model = [AccountTool account];
    
    TableItemModel *itemMail = [TableItemModel initWithTitle:@"邮箱" detailTitle:model.userMail tag:kTableTagMail];
    TableItemModel *itemSexy = [TableItemModel initWithTitle:@"性别" detailTitle:model.userSex tag:kTableTagSex];
    
    NSArray *items = @[itemMail, itemSexy];
    group.items = [NSArray arrayWithArray:items];
    
    [self.groups addObject:group];
    
    [self.tableView reloadData];
}
/**
 设置控制器子控件
 */
-(void)setSubviews{
    AccountModel *model = [AccountTool account];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, self.view.width + 2, 88)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.borderColor = RGBColor(186, 186, 193).CGColor;
    headerView.layer.borderWidth = 0.3;
    
    UIButton *selfImageButton = [[UIButton alloc] init];
    selfImageButton.layer.masksToBounds = YES;
    selfImageButton.x = 15;
    selfImageButton.y = 4;
    selfImageButton.width = 80;
    selfImageButton.height = 80;

    NSURL *imageUrl = [NSURL URLWithString:model.userImage];
    if (model.userImage.length > 0) {
        //[selfImageButton setImageWithGCDURL:imageUrl forState:UIControlStateNormal];
        [selfImageButton sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
    }else{
        selfImageButton.imageView.image = [UIImage imageNamed:@"avatar_default_big"];
    }
    
    [selfImageButton setBackgroundColor:[UIColor lightGrayColor]];
    selfImageButton.layer.cornerRadius = 40;
    [selfImageButton addTarget:self action:@selector(selfImageChange) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:selfImageButton];
    _selfImageView = selfImageButton;
    
    CGFloat nameTextX = CGRectGetMaxX(selfImageButton.frame) + 10;
    UICustomTextField *nameText = [[UICustomTextField alloc] initWithFrame:CGRectMake(nameTextX, 0, headerView.width - nameTextX, headerView.height / 2)];
    nameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameText.text = model.userRealName;
    nameText.placeholder = @"姓名";
    nameText.delegate = self;
    [headerView addSubview:nameText];
    _nameText = nameText;
    // 文字改变通知
    [kNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification  object:_nameText];
    
    UICustomTextField *phoneText = [[UICustomTextField alloc] initWithFrame:CGRectMake(nameTextX, headerView.height / 2, headerView.width - nameTextX, headerView.height / 2)];
    NSString *phoneTextStr = [NSString stringWithFormat:@"帐号: %@", model.userPhone];
    phoneText.text = phoneTextStr;
    phoneText.enabled = NO;
    phoneText.placeholder = @"帐号";
    [headerView addSubview:phoneText];
    
    self.tableView.tableHeaderView = headerView;
}

/**
  图片选择
 */
-(void)selfImageChange{
    DBLog(@"图片点击");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseFromImagePhoto];
    }];
    UIAlertAction *photoCamera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chooseFromCamera];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:photoLibrary];
    [alert addAction:photoCamera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 从相册中选取照片
 */
-(void)chooseFromImagePhoto{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    _imagePickerPhotos = imagePicker;
}

/**
 从相机中发送图片
 */
-(void)chooseFromCamera{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    _imagePickerCamera = imagePicker;
}

#pragma mark imagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = nil;
    AccountModel *model = [AccountTool account];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:@"UIImagePickerControllerMediaType"];
    
    if (picker == self.imagePickerCamera) {
        image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }else if (picker == self.imagePickerPhotos){
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    CGSize imageSize = self.selfImageView.size;
    UIImage *newImage = [self scaleToSize:image size:imageSize];
    [self.selfImageView setImage:newImage forState:UIControlStateNormal];
    
    NSData *data = nil;
    NSString *imageName = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *userImagePhone = [model.userPhone substringFromIndex:5];
    
    if (UIImagePNGRepresentation(newImage) == nil) {
        data = UIImageJPEGRepresentation(newImage, 1);
        imageName = [NSString stringWithFormat:@"%@%@.jpg", userImagePhone, dateStr];
    }else{
        data = UIImagePNGRepresentation(newImage);
        imageName = [NSString stringWithFormat:@"%@%@.png", userImagePhone, dateStr];
    }
    
    [data writeToFile:[kDocumentPath stringByAppendingPathComponent:imageName] atomically:YES];

    
    model.userImage = [NSString stringWithFormat:@"%@/images/%@", Host_Url, imageName];
    [AccountTool saveAccount:model];
    
    [self uploadSelfImage:data name:imageName];
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
 上传图片
 */
-(void)uploadSelfImage:(NSData *)data name:(NSString *)imageName{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AccountModel *model = [AccountTool account];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userPhone"] = model.userPhone;
    params[@"imageName"] = imageName;
    params[@"imageData"] = data;
    
    DBLog(@"%@", model.userPhone);
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@/imageUpload.php", Host_Url];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        DBLog(@"Sucess :%@", responseObject);
        [kNotificationCenter postNotificationName:kUpdateUserImage object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DBLog(@"Error :%@", error.description);
    }];

//    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //[formData appendPartWithFileData:data name:@"imageData" fileName:@"imageData" mimeType:@"image/png"];
//        [formData appendPartWithFormData:data name:@"imageData"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        DBLog(@"Sucess :%@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        DBLog(@"Error :%@", error.description);
//    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}

#pragma mark CustomTextFieldDelegate
-(void)textDidChange{
    self.navigationItem.rightBarButtonItem.enabled = self.nameText.hasText;
}

#pragma mark TableViewDelegate & DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TableGroupModel *group = [self.groups objectAtIndex:section];
    return group.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    TableGroupModel *group = [self.groups objectAtIndex:indexPath.section];
    TableItemModel *item = [group.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detailTitle;
    cell.tag = item.tag;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.tag == kTableTagMail) {
        SelfInfoSetMailVC *mainVC = [[SelfInfoSetMailVC alloc] init];
        [self.navigationController pushViewController:mainVC animated:YES];
    }else if(cell.tag == kTableTagSex){
        SelfInfoSetSexyVC *mainVC = [[SelfInfoSetSexyVC alloc] init];
        [self.navigationController pushViewController:mainVC animated:YES];
    }
}
@end
