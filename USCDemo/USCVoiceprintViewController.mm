//
//  USCVoiceprintViewController.m
//  asr_nlu_tts
//
//  Created by iOSDeveloper-zy on 15-5-10.
//  Copyright (c) 2015年 usc. All rights reserved.
//

#import "USCVoiceprintViewController.h"
#import "Masonry.h"
#import "DKCircleButton.h"
#import "USCVoiceprintRecognizer.h"
#import "USCVoiceprintParams.h"
#import "USCVoiceprintResult.h"
#import "SCLAlertView.h"
#import "USCConfigure.h"
#import "USCRecorder.h"
#import "USCSpeechConstant.h"

@interface USCVoiceprintViewController ()<USCVoiceprintRecognizerDelegate>
@property (weak, nonatomic)   UISegmentedControl *segment;
@property (weak, nonatomic)   UILabel *infiLabel;
@property (weak, nonatomic)   UIButton *stopBtn;
@property (weak, nonatomic)   UITextView *textView;
@property (weak, nonatomic)  UIProgressView *progressView;

@property (nonatomic,strong) USCVoiceprintParams *vprPara;
@property (nonatomic,strong) USCVoiceprintRecognizer *vprRecognizer;
@property (nonatomic,weak) UIButton *btn;

@property (nonatomic,strong) USCRecorder *record;
@end

@implementation USCVoiceprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self vprTest];

    [self setupUI];

    [self.segment setSelectedSegmentIndex:0];
}

#define RegisterDecsription @"1.点击下面的注册按钮,输入想要注册的用户名，点击开始.\t\n2.开始录音后,请朗读\"北京云知声信息技术有限公司,是专注于语音识别及语言处理技术的移动互联网公司 或者任意一段文字,时长不少于5秒\".\t\n3.说完后点击停止按钮.\t\n4.同一个用户名只能注册一次，重复注册会报502错误."
#define LoginDecsription @"1.点击下面的注册按钮,输入想要注册的用户名，点击开始.\t\n2.开始录音后,请任意说一段时长不少于2秒的话\".\t\n3.说完点击停止按钮.\t\n4.声纹的匹配度满分100,60分以上表示合格."

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)vprTest
{
    self.record = [[USCRecorder alloc]init];

    USCVoiceprintRecognizer *recognizer = [[USCVoiceprintRecognizer alloc]initWithAppKey:APPKEY secret:SECRET];
    self.vprRecognizer = recognizer;
    self.vprRecognizer.delegate = self;
    [self.vprRecognizer setAudioSource:self.record];

    USCVoiceprintParams *vprpara = [[USCVoiceprintParams alloc]init];
    self.vprPara = vprpara;
    [self.vprRecognizer setOption:USC_VPR_PARAMETER value:vprpara];
}

- (void)segmentChange{
    if(self.segment.selectedSegmentIndex == 0)
    {
        [self.btn setTitle:@"注册" forState:UIControlStateNormal];
        self.textView.text = RegisterDecsription;
    }
    else
    {
        [self.btn setTitle:@"登录" forState:UIControlStateNormal];
        self.textView.text = LoginDecsription;
    }
}

- (void)setupUI
{
    self.title = @"云知声声纹识别";
    self.view.backgroundColor = [UIColor whiteColor];
     /***********title + segment + textview + label + progressView + label + button ***********/
    UIView *superView = self.view;

    UISegmentedControl *segment = [[UISegmentedControl alloc]init];
    [segment insertSegmentWithTitle:@"注册" atIndex:0 animated:YES];
    [segment insertSegmentWithTitle:@"登录" atIndex:1 animated:YES];
    [segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];

    self.segment = segment;
    [self.view addSubview:segment];

    UITextView *infoTextView = [[UITextView alloc]init];
    self.textView = infoTextView;
    infoTextView.layer.borderWidth = 1;
    infoTextView.layer.cornerRadius = 2;
    infoTextView.editable = NO;
    [self.view addSubview:infoTextView];
     self.textView.text = RegisterDecsription;

    UILabel *volumeLable = [[UILabel alloc]init];
    volumeLable.text =@"音量:";
    [self.view addSubview:volumeLable];

    UIProgressView *progressView = [[UIProgressView alloc]init];
    [progressView setProgress:0.f];
    self.progressView = progressView;
    [self.view addSubview:progressView];

    UIEdgeInsets inset = UIEdgeInsetsMake(padding, padding, padding, padding);

    DKCircleButton *btn = [DKCircleButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"停止" forState:UIControlStateSelected];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    self.btn = btn;
    [self.view addSubview:btn];


    DKCircleButton *audioBtn = [DKCircleButton buttonWithType:UIButtonTypeCustom];
    [audioBtn setBackgroundColor:[UIColor grayColor]];
    [audioBtn addTarget:self action:@selector(audioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [audioBtn setTitle:@"下载" forState:UIControlStateNormal];
    [audioBtn setTitle:@"停止" forState:UIControlStateSelected];
    [self.view addSubview:audioBtn];


    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding * 7);
        make.centerX.equalTo(superView.mas_centerX);
        make.width.equalTo(superView.mas_width).offset(-padding * 2);
        make.bottom.equalTo(infoTextView.mas_top).offset(-padding * .5f);
    }];

    [infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segment.mas_bottom).offset(padding * .5f);
        make.centerX.equalTo(segment.mas_centerX);
        make.width.equalTo(segment.mas_width);
        make.bottom.equalTo(volumeLable.mas_top).offset(-padding * .5f);
    }];

    [volumeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoTextView.mas_bottom).offset(padding * .5f);
        make.left.equalTo(superView).insets(inset);
        make.right.lessThanOrEqualTo(progressView.mas_left).offset(-padding * .2f);
        make.height.equalTo(segment.mas_height);
        make.width.equalTo(progressView.mas_width).multipliedBy(.17f);
        make.bottom.lessThanOrEqualTo(btn.mas_top).offset(-padding * .5f);
    }];

    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(volumeLable.mas_centerY);
        make.left.equalTo(volumeLable.mas_right).offset(padding * .2f);
        make.right.equalTo(superView).insets(inset);
    }];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(volumeLable.mas_bottom).offset(padding * .5f);
        make.centerX.equalTo(segment.mas_centerX);
        make.height.width.equalTo(superView.mas_width).multipliedBy(.23f);
        make.bottom.greaterThanOrEqualTo(superView.mas_bottom).offset(-padding);
    }];

    [audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(btn);
        make.left.equalTo(superView.mas_left);
    }];
}

static NSString *lastUserName=@"";

- (void)btnOnClick:(id)sender
{
     /***********关闭***********/
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        [self.vprRecognizer stop];
        [self.btn setSelected:NO];
        return;
    }

     /***********开始***********/
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = [UIColor colorWithRed:11/225.f green:96/255.f blue:254/255.f alpha:1];
    UITextField *textField = [alert addTextField:@"请输入用户名"];

    if(self.segment.selectedSegmentIndex)
    {
        textField.text = lastUserName;
        [alert addButton:@"开始" actionBlock:^(void) {

            [self.vprPara setVPRName:textField.text];
            [self.vprPara setVPRType:USCVPRTypeLogin];
            self.textView.text = LoginDecsription;
            [self.vprRecognizer start:textField.text type:@"login"];
            [self.btn setSelected:YES];
        }];

        [alert showEdit:self title:@"登录" subTitle:nil closeButtonTitle:@"取消" duration:0.0f];
    }
    else
    {
        [alert addButton:@"开始" actionBlock:^(void) {
           
            lastUserName = textField.text;
            [self.vprPara setVPRName:textField.text];
            [self.vprPara setVPRType:USCVPRTypeRegister];
            self.textView.text = RegisterDecsription;

            [self.vprRecognizer start:textField.text type:@"register"];
            [self.btn setSelected:YES];
        }];
        [alert showEdit:self title:@"注册" subTitle:nil closeButtonTitle:@"取消" duration:0.0f];
    }
}

- (void)audioBtnClick:(id)sender
{

    /***********关闭***********/
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        return;
    }

    /***********开始***********/
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = [UIColor colorWithRed:11/225.f green:96/255.f blue:254/255.f alpha:1];
    UITextField *textField = [alert addTextField:@"请输入RequestID"];
        textField.text = lastUserName;
        [alert addButton:@"下载" actionBlock:^(void) {
            [self.btn setSelected:YES];
        }];
        [alert showEdit:self title:@"下载音频数据" subTitle:nil closeButtonTitle:@"取消" duration:0.0f];
}

#pragma mark -
#pragma mark VPR delegate
- (void)onVPRResult:(USCVoiceprintResult *)result;
{
//    NSLog(@"sessionId=%@",[self.vprRecognizer getSessionId]);

    if(self.segment.selectedSegmentIndex){
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@\t\n**********************************\t\n您和“%@”用户的声纹匹配度为:%.3f\t\n**********************************\t\n",LoginDecsription,result.userName,result.score];
        if (result.score >= 60) {
            [str appendString:@"匹配成功！😃"];
        }
        else
        {
            [str appendString:@"匹配失败！😱"];
        }
        self.textView.text = str;
    }
    else
    {
        NSString *resultStr = [NSString stringWithFormat:@"\t\n**********************************\t\n%@注册成功！\t\n**********************************",result.userName];
        self.textView.text = [NSString stringWithFormat:@"%@\t\n%@",RegisterDecsription,resultStr];
    }
}

- (void)onEnd:(NSError *)error
{
//    NSLog(@"sessionId=%@",[self.vprRecognizer getSessionId]);

    NSString *str;
    NSLog(@"view controller error = %@",error);
    if (error) {
        str = [NSString stringWithFormat:@"%@\t\n**********************************\t\n错误:%@\t\nstatusCode:%d\t\n**********************************\t\n",self.textView.text,error.domain,error.code];
        self.textView.text = str;
    }
    self.infiLabel.text = @"声纹识别停止！";

    [self.btn setSelected:NO];

}

- (void)onUpdateVolume:(int)volume
{
    self.infiLabel.text = @"正在录音...";
    [self.progressView setProgress:volume /100.f animated:NO];
}

- (void)onRecordingStart
{
    self.infiLabel.text = @"正在录音...";
}

- (void)onRecordingStop:(NSMutableData *)recordingDatas
{
    NSLog(@"录音返回数据");
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"123.pcm"];
    [recordingDatas writeToFile:file atomically:YES];
    self.infiLabel.text = @"录音停止！";
}

- (void)onDownloadAudioEnd:(NSError *)error
{
    if (!error){

        NSLog(@"下载音频成功");
    }
    else{
        NSLog(@"下载音频出错:%@",error);
    }
}

/**
 *  返回错误信息
 *
 *  @param type     类型
 *  @param errorMSG 错误
 */
- (void)onError:(int)type error:(NSError *)errorMSG
{

}

/**
 *  声纹处理过程中事件回调
 *
 *  @param type  类型
 *  @param times 发生事件
 *
 *  @return 结果
 */
- (int)onEvent:(int)type times:(int)times{
    return 1;
}

/** 声纹处理结果状态回调 VPR_REGISTER VPR_LOGIN
 *  返回识别信息
 *
 *  @param type       类型注册 :1 登录:2
 *  @param jsonResult 返回结果
 */
- (void)onResult:(int)type result:(NSString *)jsonResult
{
    dispatch_async(dispatch_get_main_queue(), ^{

        NSMutableString *str = [NSMutableString stringWithFormat:@"%@\t\n**********************************\t\n返回结果：\n**********************************\t\n",LoginDecsription];
        [str appendString:jsonResult];
        self.textView.text = str;

        NSLog(@"json= %@",jsonResult);
    });
}

@end
