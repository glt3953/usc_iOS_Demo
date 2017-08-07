//
//  USCAsrViewController.m
//  asr_nlu_tts
//
//  Created by iOSDeveloper-zy on 15-5-10.
//  Copyright (c) 2015年 usc. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "USCAsrViewController.h"
#import "USCConstant.h"
#import "DKCircleButton.h"
#import "USCConfigure.h"
#import "USCSpeechResult.h"
#import "USCSpeechUnderstander.h"
#import "USCSpeechSynthesizer.h"
#import "USCSpeechConstant.h"
// E-SETVC
#import "USCSetViewController.h"
// E-SETVC

#import "USCRecorder.h"
#import "USCPlayThread.h"

@interface USCAsrViewController ()<USCSpeechUnderstanderDelegate,USCSpeechSynthesizerDelegate>
/***********UI***********/
@property (nonatomic,weak) UIButton *btn;
@property (nonatomic,weak) UITextView *asrTv;
@property (nonatomic,weak) UITextView *nluTv;
@property (nonatomic,weak) UIProgressView *progressView;
@property (nonatomic,copy) NSMutableString *mStr;
@property (nonatomic,strong) MBProgressHUD *hud;
// E-SETVC
@property (nonatomic,strong) USCSetViewController *setVC;
// E-SETVC

/***********SpeechUnderdtander***********/
@property (nonatomic,strong) USCSpeechUnderstander *speechUnderstander;
@property (nonatomic,strong) USCSpeechSynthesizer *speechSynthesizer;
@property (nonatomic,strong) USCSpeechResult *speechResult;

@property (nonatomic,strong) USCRecorder *record;
@property (nonatomic,strong) USCPlayThread *player;

@end

@implementation  USCAsrViewController

#pragma mark - lazy
- (NSMutableString *)mStr
{
    if (!_mStr) {
        _mStr = [[NSMutableString alloc]init];
    }
    return _mStr;
}

- (MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.mode = MBProgressHUDModeText;
    }
    return _hud;
}

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];

    /***********1.创建语音理解对象***********/
    [self setupSpeech];

    /***********2.布局界面***********/
    [self setupUI];
}

// E-SETVC

- (void)pushSetVC
{
    [self.navigationController pushViewController:self.setVC animated:YES];
}
// E-SETVC

- (void)setupUI
{
    // E-SETVC
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(pushSetVC)];
    // E-SETVC

    // E-SETVC
    self.setVC = [[USCSetViewController alloc]init];
    // E-SETVC

    /***********title + textveiw + btn***********/
    self.title = @"云知声语音理解";
    UIView *superView = self.view;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UITextView *asrTextView = [[UITextView alloc]init];
    [self.view addSubview:asrTextView];
    asrTextView.editable = NO;
    asrTextView.layer.borderWidth = 1;
    asrTextView.layer.cornerRadius = 2;
    self.asrTv = asrTextView;

    UIProgressView *progressView = [[UIProgressView alloc]init];
    [progressView setProgress:0.f];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    UIView *coverV = [[UIView alloc]init];
    coverV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:coverV];

    UILabel *volumeLable = [[UILabel alloc]init];
    volumeLable.text =@"音量:";
    [self.view addSubview:volumeLable];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(padding, padding, padding, padding);

    DKCircleButton *btn = [DKCircleButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setTitle:@"停止" forState:UIControlStateSelected];
    [self.view addSubview:btn];
    self.btn = btn;

    [asrTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding * 6.5f);
        make.centerX.equalTo(superView.mas_centerX);
        make.width.equalTo(superView.mas_width).offset(-padding * 2);
        make.bottom.equalTo(volumeLable.mas_top).offset(-padding * .5f);
    }];

    [volumeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(asrTextView.mas_bottom).offset(padding * .5f);
        make.left.equalTo(superView).insets(inset);
        make.right.lessThanOrEqualTo(progressView.mas_left).offset(-padding * .2f);
        make.height.equalTo(@kLabelH);
        make.width.equalTo(progressView.mas_width).multipliedBy(.17f);
        make.bottom.lessThanOrEqualTo(btn.mas_top).offset(padding * .5f);
    }];
    
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(volumeLable.mas_centerY);
        make.left.equalTo(volumeLable.mas_right).offset(padding * .2f);
        make.right.equalTo(superView).insets(inset);
    }];
    
    [coverV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(volumeLable);
        make.leading.equalTo(@0);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(volumeLable.mas_bottom).offset(padding * .5f);
        make.centerX.equalTo(superView.mas_centerX);
        make.height.width.equalTo(superView.mas_width).multipliedBy(.23f);
        make.bottom.greaterThanOrEqualTo(superView.mas_bottom).offset(-padding);
    }];
}

- (void)reset
{
    [self.speechUnderstander stop];
    [self.mStr setString:@""];
}

#pragma mark - SpeechUnderstander
- (void)setupSpeech
{
    USCRecorder *recorder = [[USCRecorder alloc]init];
    USCPlayThread *playThread = [[USCPlayThread alloc]init];

    /*********** create speechUnderstander***********/
    USCSpeechUnderstander *underStander = [[USCSpeechUnderstander alloc]initWithContext:nil appKey:APPKEY secret:SECRET];
    self.speechUnderstander = underStander;
    [self.speechUnderstander setOption:USC_ASR_DOMAIN value:@"general"];
    [self.speechUnderstander setOption:USC_ASR_VAD_TIMEOUT_FRONTSIL value:@"300"];
    [self.speechUnderstander setOption:USC_ASR_VAD_TIMEOUT_BACKSIL value:@"200"];
    [self.speechUnderstander setOption:USC_NLU_ENABLE value:@"true"];
    
    self.speechUnderstander.delegate = self;
    [self.speechUnderstander setAudioSource:recorder];

    /*********** create speechSynthesize***********/
    USCSpeechSynthesizer *speechSynthesize = [[USCSpeechSynthesizer alloc] initWithAppkey:APPKEY secret:SECRET];
    self.speechSynthesizer = speechSynthesize;
    self.speechSynthesizer.delegate = self;
    [self.speechSynthesizer setOption:USC_TTS_KEY_VOICE_VOLUME value:@"100"];
    [self.speechSynthesizer setOption:USC_TTS_KEY_VOICE_NAME value:@"xiaoli"];
    [self.speechSynthesizer setAudioSource:playThread];
}

#pragma mark - Action
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.speechSynthesizer playText:@"云知声 Set the foreground color with the foregroundColor property"];
    [self.view resignFirstResponder];
}

- (void)btnOnClick:(id)sender
{
    // E-SETVC
    [self.speechUnderstander setOption:USC_ASR_LANGUAGE value:self.setVC.selectedLanguage];
    [self.speechUnderstander setOption:USC_ASR_SAMPLING_RATE value:self.setVC.selectedSample];
    [self.speechUnderstander setOption:USC_ASR_DOMAIN value:self.setVC.selectedEngine];
    // E-SETVC

    if (self.btn.selected) {
        [self.speechUnderstander stop];
        return;    }

    [self reset];
    [self.speechUnderstander start];
}

- (void)showHubView:(NSString *)text
{
    self.hud.labelText = text;
    [self.view addSubview:self.hud];
    [self.hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [self.hud  removeFromSuperview];
    }];
}

#pragma mark - new interface

- (void)onError:(int)type error:(NSError *)error
{
    if (error) {
        NSLog(@"error = %@",error);
        return;
    }

    if (USC_TTS_ERROR == type) {
        return;
    }

    [self.btn setSelected:NO];
    if (self.mStr.length > 0 ) {
        NSLog(@"播放的文字：%@",self.mStr);
        [self.speechSynthesizer playText:self.mStr];
    }
    [self.btn setSelected:NO];
    [self.progressView setProgress:0];
}

- (void)onEvent:(int)type timeMs:(int)timeMs
{
    if (type == USC_ASR_EVENT_VOLUMECHANGE) {
        int volumeRate = [[self.speechUnderstander getOption:USC_ASR_EVENT_VOLUMECHANGE] intValue];
        [self.progressView setProgress:volumeRate /100.f animated:YES];
    }

    if (USC_ASR_EVENT_RECORDING_START == type) {
         [self.btn setSelected:YES];
    }
}

- (void)onResult:(int)type jsonString:(NSString *)jsonString
{
    NSLog(@"json= %@",jsonString);
    
    if ([self detectResultJSONCount:jsonString]) {
        [self.mStr appendString:[self separateJSONString:jsonString]];
    }else{

    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (resObj) {
        NSString *part = [resObj objectForKey:@"asr_recongize"];
        [self.mStr appendFormat:@"%@",part];
        NSLog(@"mstr=%@",self.mStr);
    }
    }
    self.asrTv.text = jsonString;
}

// detect last result json count
- (BOOL)detectResultJSONCount:(NSString *)resultStr
{
    NSString *parten =@"\\}\\{";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NULL error:&error];
    NSArray* match = [reg matchesInString:resultStr options:NSMatchingCompleted range:NSMakeRange(0, [resultStr length])];
    if (match.count >= 1) {
        return YES;
    }
    return NO;
}

- (NSString *)separateJSONString:(NSString *)string
{
    NSMutableString *allJsonResultStr = [NSMutableString string];// server all json result
    NSMutableDictionary *resultMDict;
    NSString *parten =@"\\}\\{";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NULL error:&error];
    NSArray* match = [reg matchesInString:string options:NSMatchingCompleted range:NSMakeRange(0, [string length])];// all json in match array
    if (match.count == 0) {
        return nil;
    }
    
    NSMutableArray *locationArray = [NSMutableArray array];
    // 计算每块json的location
    for (NSTextCheckingResult *checkResult in match) {
        [locationArray addObject:[NSNumber numberWithInt:checkResult.range.location]];
    }
    
    NSMutableArray *jsonArray = [NSMutableArray array];
    // 计算出每段json
    for (int i = 0; i < locationArray.count; i++) {
        NSString *jsonString;
        if (i == 0) {
            NSRange range = NSMakeRange(0, ([locationArray[i] intValue] + 1));
            jsonString = [string substringWithRange:range];
        }
        else{
            int len = [locationArray[i] intValue] - [locationArray[i - 1] intValue];
            NSRange range = NSMakeRange([locationArray[i-1] intValue] + 1, len);
            jsonString = [string substringWithRange:range];
        }
        [jsonArray addObject:jsonString];
        NSData *tempData =  [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingAllowFragments error:&error];
        
        if ([tempDict objectForKey:@"asr_recongize"]) {
            [allJsonResultStr appendString:(NSString *)[tempDict objectForKey:@"asr_recongize"]];
        }
    }// for
    return allJsonResultStr;
}
@end
