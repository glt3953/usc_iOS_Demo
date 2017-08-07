//
//  USCRecognizer.h
//  usc
//
//  Copyright (c) 2014年 yunzhisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import "USCConstant.h"

@class USCRecoginizerParam;

#pragma mark -
#pragma mark 语音识别代理
@protocol USCRecognizerDelegate <NSObject>
/**
 *  当录音和识别线程都启动成功后才会回调该方法。注意为了防止前半部分语音被截断的现象，建议在此方法回调后，再提醒用户开始说话
 */
- (void)onStart;
/**
 *  返回识别结果
 *
 *  @param result 识别结果
 *  @param isLast 当isLast返回YES表示识别结果已返回完成
 */
- (void)onResult:(NSString *)result isLast:(BOOL)isLast;
/**
 *  识别结束回调
 *
 *  @param error 返回的错误信息。error为nil时表示正常结束
 */
- (void)onEnd:(NSError *)error;
/**
 *  说话停顿超时，当检测到用户超过一定时间没说话就会返回vad超时，应该调用stop方法，停止识别。
 */
- (void)onVADTimeout;
/**
 *  返回录音音量大小
 *
 *  @param volume 音量。范围0-100
 */
- (void)onUpdateVolume:(int)volume;
/**
 *  上传个性化数据结束回调
 *
 *  @param error 错误信息。error为nil表示正常
 */
- (void)onUploadUserData:(NSError *)error;
/**
 *  录音停止
 *
 *  @param recordingDatas 返回的录音数据
 */
- (void)onRecordingStop:(NSMutableData *)recordingDatas;

@optional
/**
 *  识别超时，当网络中断或网络情况不好时会出现识别超时。
 */
- (void)onRecognizationTimeout;
/**
 *  开始说话回调
 */
- (void)onSpeechStart;
/**
 *  录音开始回调
 */
- (void)onRecordingStart;
@end

#pragma mark -
#pragma mark 类
// @class - 语音识别类
// @brief - 通过语音识别转换成文字
@interface USCRecognizer : NSObject

@property (nonatomic, weak) id<USCRecognizerDelegate> delegate;

/*
 初始化, 请到开发者网站http://dev.hivoice.cn申请appKey
 */
- (id)initWithAppKey:(NSString *)appkey;

/**
 *  设置参数对象
 *
 *  @param param 参数
 */
- (void)setParam:(USCRecoginizerParam *)param;

/**
 *
 *  启动识别引擎
 */
- (void)start;

/**
 *
 *  停止录音，并开始等待识别结束
 */
- (void)stop;

/*!
 *
 *  @brief  设置是否返回语义理解结果，默认每次识别结束后都会返回对应的语义理解结果。
 *
 *  @param enable YES:每次返回, NO:不返回
 */
- (void)setNluEnable:(BOOL)enable;

/**
 *
 *  取消识别
 */
- (void)cancel;

/**
 *
 *  上传个性化数据
 *
 *  @param userData 用户数据
 */
- (void)setUserData:(NSDictionary *)userData;

/** (DEPRECATED)
 *
 *  设置识别语言
 *
 *  @param language 语言 ,这个方法已不再推荐使用
 */
- (void)setLanguage:(NSString *)language; 
/*!
 *
 *  @brief  设置识别语言
 *
 *  @param language 语言
 */
- (void)setRecognizeLanguage:(USCRecognizeLanguage)language;
/*!
 *
 *  @brief   设置远近讲
 *
 *  @param voiceField 近讲设置成@“near”，远讲设置成@“far”
 *
 *  @return 设置成功返回YES，识别返回NO
 */
- (BOOL)setVoiceField:(NSString *)voiceField;
/**
 *
 *   设置vad超时时间，单位ms
 *
 *  @param frontTime 开始说话之前的停顿超时时间，默认3000ms
 *  @param backTime  开始说话之后的停顿超时时间，默认1000ms
 */
- (void)setVadFrontTimeout:(int)frontTime BackTimeout:(int)backTime;
/**
 *
 *   设置录音采样率
 *
 *  @param rate 支持8000和16000，默认为16000
 */
- (void)setSampleRate:(int)rate;
/**
 *
 *  设置识别参数
 *
 *  @param engine 识别领域
 *
 *  @return YES or NO
 */
- (BOOL)setEngine:(NSString *)engine;
/*!
 *
 *  @brief  设置模型类型
 *
 *  @param modelType 模型
 *
 *  @return 成功返回YES
 *
 */
- (BOOL)setModelType:(NSString *)modelType;
/**
 *
 *  设置识别超时时间
 *
 *  @param recognizationTime 超时时间，默认30s
 */
- (void)setRecognizationTimeout:(float)recognizationTime;

/*!
 *  直接识别音频文件
 *
 *  @brief  识别音频
 *
 *  @param audioFilePath 音频文件的路径
 */
- (void)recognizeAudioFile:(NSString *)audioFilePath;

/**
 *
 *  获取session id
 *
 *  @return 当前识别会话ID
 */
- (NSString *)getSessionId;

/*
 设置是否允许播放提示音
 */
-(void)setPlayingBeep:(BOOL)isAllowed;

/*
 设置标点符号
 */
- (void)setPunctuation:(BOOL)isEnable;

/*
 设置属性
 */
- (void)setProperty:(NSString *)property forKey:(int)key;

/*!
 *
 *  @brief  设置语义的场景，默认为空
 *
 *  @param scenario 语义场景
 */
- (void)setNluScenario:(NSString *)scenario;

/*
 版本号
 */
+ (NSString *)getVersion;
@end
