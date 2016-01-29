//
//  CitySelectView.m
//  DreamShip
//
//  Created by 刘伟龙 on 16/1/12.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "CitySelectView.h"

@interface CitySelectView()

@property (nonatomic, weak) UIPickerView     *cityPickerView;
@property (nonatomic, weak) UIButton         *confirmButton;
@property (nonatomic, weak) UIButton         *closeButton;

@property (nonatomic, strong) NSDictionary   *cityDict;

@property (nonatomic, strong) NSMutableArray *provience;
@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic, strong) NSMutableArray *zones;
@end

#define PICKER_COMPONENT_PROVIENCE 0
#define PICKER_COMPONENT_CITIES    1
#define PICKER_COMPONENT_ZONES     2

@implementation CitySelectView

-(NSMutableArray *)provience{
    if (_provience == nil) {
        _provience = [NSMutableArray array];
    }
    
    return _provience;
}

-(NSMutableArray *)cities{
    if (_cities == nil) {
        _cities = [NSMutableArray array];
    }
    
    return _cities;
}

-(NSMutableArray *)zones{
    if (_zones == nil) {
        _zones = [NSMutableArray array];
    }
    
    return _zones;
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kViewBgColor;
        
        CGFloat headViewH = 30;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headViewH)];
        view.backgroundColor = kBtnFireColorNormal;
        
        [self addSubview:view];
        
        UIButton *closeButton = [[UIButton alloc] init];
        closeButton.frame = CGRectMake(kScreenWidth - 50, 0, 40, headViewH);
        closeButton.layer.cornerRadius = 2;
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeButton setTitleColor:kTitleFireColorHighlighted forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(closeAddr) forControlEvents:UIControlEventTouchUpInside];
        _closeButton = closeButton;
        [view addSubview:closeButton];
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, headViewH, kScreenWidth, 140)];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.showsSelectionIndicator = YES;
        _cityPickerView = pickerView;
        [self addSubview:pickerView];
        
        UIButton *confirmButton = [[UIButton alloc] init];
        CGFloat buttonW = 0.8 * kScreenWidth;
        confirmButton.frame = CGRectMake((kScreenWidth - buttonW) / 2, CGRectGetMaxY(pickerView.frame) + 5, buttonW, 1.0/8.0*buttonW);
        confirmButton.layer.cornerRadius = 2;
        [confirmButton setTitle:@"好 了" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton setTitleColor:kTitleFireColorHighlighted forState:UIControlStateHighlighted];
        [confirmButton setBackgroundColor:kBtnFireColorNormal];
        [confirmButton addTarget:self action:@selector(confirmAddr) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton = confirmButton;
        [self addSubview:confirmButton];
        
        [self setPickerData];
    }
    
    return self;
}

+(instancetype)citiSelectView{
    return [[self alloc] init];
}

-(void)setPickerData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    _cityDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    [self setCityAndZone:0];
}

-(void)setCityAndZone:(NSInteger)rowProvience{
    NSArray *components = [_cityDict allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([obj1 integerValue] > [obj2 integerValue]){
            return (NSComparisonResult)NSOrderedDescending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    NSMutableArray *provienceTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < [sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *temp = [[self.cityDict objectForKey:index] allKeys];
        [provienceTemp addObject:[temp objectAtIndex:0]];
    }
    
    [self.provience removeAllObjects];
    [self.provience addObjectsFromArray:provienceTemp];
    
    NSString *index = [sortedArray objectAtIndex:rowProvience];
    NSString *selected = [self.provience objectAtIndex:rowProvience];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[self.cityDict objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    [self.cities removeAllObjects];
    [self.cities addObjectsFromArray:[cityDic allKeys]];

    NSString *selectedCity = [self.cities objectAtIndex: 0];
    [self.zones addObjectsFromArray: [cityDic objectForKey: selectedCity]];
    
    [self.cityPickerView reloadAllComponents];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger count = 0;
    
    switch (component) {
        case PICKER_COMPONENT_PROVIENCE:
            count = self.provience.count;
            break;
        case PICKER_COMPONENT_CITIES:
            count = self.cities.count;
            break;
        case PICKER_COMPONENT_ZONES:
            count = self.zones.count;
            break;
        default:
            break;
    }
    
    return count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel * label = nil;
    label.textColor = [UIColor whiteColor];
    if (view == nil) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 187, 188)];
        [label setTextAlignment:NSTextAlignmentCenter];
    }else{
        label = (UIView*)view;
    }
  
    if (component == PICKER_COMPONENT_PROVIENCE) {
        label.text = [self.provience objectAtIndex:row];
    }else if (component == PICKER_COMPONENT_CITIES){
        label.text = [self.cities objectAtIndex:row];
    }else if (component == PICKER_COMPONENT_ZONES){
        label.text = [self.zones objectAtIndex:row];
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    static NSString *selectedProvience  = @"";
    
    if (component == PICKER_COMPONENT_PROVIENCE) {
        selectedProvience = [self.provience objectAtIndex:row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.cityDict objectForKey: [NSString stringWithFormat:@"%ld", row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvience]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        [self.cities removeAllObjects];
        [self.cities addObjectsFromArray:array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        [self.zones removeAllObjects];
        [self.zones addObjectsFromArray:[cityDic objectForKey: [self.cities objectAtIndex: 0]]];
        
        [self.cityPickerView selectRow: 0 inComponent: PICKER_COMPONENT_CITIES animated: YES];
        [self.cityPickerView selectRow: 0 inComponent: PICKER_COMPONENT_ZONES animated: YES];
        [self.cityPickerView reloadComponent: PICKER_COMPONENT_CITIES];
        [self.cityPickerView reloadComponent: PICKER_COMPONENT_ZONES];
    }else if (component == PICKER_COMPONENT_CITIES){
        NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [self.provience indexOfObject: selectedProvience]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.cityDict objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvience]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        [self.zones removeAllObjects];
        [self.zones addObjectsFromArray:[cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [self.cityPickerView selectRow: 0 inComponent: PICKER_COMPONENT_ZONES animated: YES];
        [self.cityPickerView reloadComponent: PICKER_COMPONENT_ZONES];
    }else{
    }
}


-(void)confirmAddr{
    NSString *provience = [self.provience objectAtIndex:[self.cityPickerView selectedRowInComponent:PICKER_COMPONENT_PROVIENCE]];
    NSString *city = [self.cities objectAtIndex:[self.cityPickerView selectedRowInComponent:PICKER_COMPONENT_CITIES]];
    NSString *zone = [self.zones objectAtIndex:[self.cityPickerView selectedRowInComponent:PICKER_COMPONENT_ZONES]];
    
    NSString *addr = [NSString stringWithFormat:@"%@ %@ %@", provience, city, zone];
    if ([self.delegate respondsToSelector:@selector(confirmPickerViewSelected:)]) {
        [self.delegate confirmPickerViewSelected:addr];
    }
}

-(void)closeAddr{
    [self removeFromSuperview];
}
@end
