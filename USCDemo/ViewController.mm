//
//  ViewController.m
//
//
//  Created by  on 14-12-31.
//  Copyright (c) 2014年 usc. All rights reserved.
//


#import "Masonry.h"
#import "ViewController.h"
#import "USCConstant.h"
//E-ASR
#import "USCAsrViewController.h"
//E-ASR
//E-VPR
#import "USCVoiceprintViewController.h"
//E-VPR

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IPHONE_SIZE_HEIGHT [UIScreen mainScreen].bounds.size.height

#define GAP 10
#define TVWIDTH (320 - 2 * GAP)

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *featuresLists;
@property (nonatomic,strong) NSMutableArray *featureVCArray;
//E-VPR
@property (nonatomic,strong) USCVoiceprintViewController *vprVC;
//E-VPR
//E-ASR
@property (nonatomic,strong) USCAsrViewController *asrVC;
//E-ASR

@end

@implementation ViewController

#pragma mark -lazy
//E-ASR
- (USCAsrViewController *)asrVC
{
    if (!_asrVC) {
        _asrVC = [[USCAsrViewController alloc]init];
    }
    return _asrVC;
}
//E-ASR
//E-VPR
- (USCVoiceprintViewController *)vprVC
{
    if (!_vprVC) {
        _vprVC = [[USCVoiceprintViewController alloc]init];
    }
    return _vprVC;
}
//E-VPR

- (NSMutableArray *)featureVCArray
{
    if (!_featureVCArray) {
        _featureVCArray = [NSMutableArray array];
//E-ASR
        [_featureVCArray addObject:self.asrVC];
//E-ASR
//E-VPR
        [_featureVCArray addObject:self.vprVC];
//E-VPR
    }
    return _featureVCArray;
}

- (NSMutableArray *)featuresLists
{
    return[NSMutableArray arrayWithObjects:
	//E-ASR
	@"语音理解",
	//E-ASR
	//E-VPR
	@"声纹识别",
	//E-VPR
	nil];
}

#pragma mark -
#pragma mark view
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI
{
   /*********** view + textview + tableview ***********/
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *superView = self.view;

    UITextView *briefTextView = [[UITextView alloc]init];
    briefTextView.layer.borderWidth = 1;
    briefTextView.layer.cornerRadius = 5;
    briefTextView.text = @"云知声智能语音交互平台提供语音理解(语音云和语义云)服务。本SDK帮助开发者开发基于语音识别、语义理解及语音合成需求的客户端软件。";
    briefTextView.scrollEnabled = NO;
    briefTextView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:briefTextView];

    UITableView *featureListTableView = [[UITableView alloc]init];
    featureListTableView.delegate = self;
    featureListTableView.dataSource = self;
    featureListTableView.backgroundColor = [UIColor lightGrayColor];
    featureListTableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    [self.view addSubview:featureListTableView];

    [briefTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding * 7);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.bottom.equalTo(featureListTableView.mas_top).offset(-padding);
        make.height.equalTo(@100);
    }];

    [featureListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(briefTextView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.bottom.equalTo(superView.mas_bottom);
    }];
}

#pragma mark -
#pragma mark tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[self.featureVCArray objectAtIndex:indexPath.row] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = self.featuresLists[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
