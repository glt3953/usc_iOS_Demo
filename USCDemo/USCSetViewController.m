//
//  USCSetViewController.m
//  USCDemo
//
//  Created by iOSDeveloper-zy on 15-6-11.
//  Copyright (c) 2015年 usc. All rights reserved.
//

#import "USCSetViewController.h"
#import "Masonry.h"

@interface USCSetViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,weak) UIPickerView *mainPickerView; // 采样率
@property (nonatomic,strong) NSArray *language; // 语言
@property (nonatomic,strong) NSMutableArray *sampleArray;
@property (nonatomic,strong) NSMutableArray *engienArray;
@property (nonatomic,strong) NSMutableArray *languageArray;
@end

@implementation USCSetViewController


- (instancetype)init
{
    if (self = [super init]) {
        _selectedEngine = @"general";
        _selectedLanguage = @"chinese";
        _selectedSample = @"16000";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

    self.sampleArray =  [[NSMutableArray alloc] initWithObjects:@"16K",@"8K",@"自动",nil];
    self.engienArray = [[NSMutableArray alloc]initWithObjects:@"通用",@"地名",@"歌名",@"医药",@"影视", nil];
    self.languageArray = [[NSMutableArray alloc]initWithObjects:@"普通话", nil];
}


- (void)setSelectedSample:(NSString *)selectedSample
{
    if ([selectedSample isEqualToString:@"16K"]) {
        _selectedSample = @"16000";
    }
    else if([selectedSample isEqualToString:@"8K"]) {
        _selectedSample = @"8000";
    }
    else{
        _selectedSample = @"0";
    }
}

- (void)setSelectedEngine:(NSString *)selectedEngine
{
    if ([selectedEngine isEqualToString:@"影视"]) {
        _selectedEngine = @"movietv";
    }
    else if ([selectedEngine isEqualToString:@"地名"]){
        _selectedEngine = @"poi";
    }
    else if ([selectedEngine isEqualToString:@"歌名"]){
        _selectedEngine = @"song";
    }else if ([selectedEngine isEqualToString:@"医药"]){
        _selectedEngine = @"medical";
    }else
    {
        _selectedEngine = @"general";
    }
}

- (void)setSelectedLanguage:(NSString *)selectedLanguage
{
    if ([selectedLanguage isEqualToString:@"英语"]) {
        _selectedLanguage = @"english";
    }
    else if ([selectedLanguage isEqualToString:@"粤语"]){
        _selectedLanguage = @"cantoness";
    }
    else{
       _selectedLanguage = @"chinese";
    }
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    /***********UIScrollVeiw + UIPickerVeiw ***********/
    UIView *superView = self.view;

    UILabel *sampleLabel = [[UILabel alloc]init];
    sampleLabel.textAlignment = NSTextAlignmentCenter;
    sampleLabel.text = @"采样率";
    [self.view addSubview:sampleLabel];
    UILabel *engineLabel = [[UILabel alloc]init];
    engineLabel.text = @"识别领域";
    engineLabel.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:engineLabel];

    UILabel *languageLabel = [[UILabel alloc]init];
    languageLabel.text = @"识别语言";
    languageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:languageLabel];


    UIPickerView *mainPickerView = [[UIPickerView alloc]init];
    self.mainPickerView = mainPickerView;
    self.mainPickerView.delegate = self;
    self.mainPickerView.dataSource = self;
    [self.view addSubview:mainPickerView];

    [sampleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(100);
        make.left.equalTo(superView.mas_left);
        make.width.equalTo(superView.mas_width).multipliedBy(0.33);
        make.height.equalTo(@30);
    }];

    [engineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.bottom.equalTo(sampleLabel);
        make.left.equalTo(sampleLabel.mas_right);
        make.right.equalTo(languageLabel.mas_left);
    }];

    [languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(sampleLabel);
        make.left.equalTo(engineLabel.mas_right);
    }];

    [mainPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superView.mas_width);
        make.top.equalTo(sampleLabel.mas_bottom).offset(0);
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component) {
        self.selectedSample = self.sampleArray[row];
    }

    if (1 == component) {
        self.selectedEngine = self.engienArray[row];
    }

    if (2 == component) {
        self.selectedLanguage = self.languageArray[row];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    if (0 == component) {
        return self.sampleArray[row];
    }

    if(1 == component){
        return self.engienArray[row];
    }

    if (2 == component) {
        return self.languageArray[row];
    }
    return nil;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (0 == component) {
        return self.sampleArray.count;
    }

    if (1 == component) {
        return self.engienArray.count;
    }

    if (2 == component) {
        return self.languageArray.count;
    }
    return 0;
}

@end
