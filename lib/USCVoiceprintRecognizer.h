//
//  USCRecognizer.h
//  usc
//
//  Copyright (c) 2014年 yunzhisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import "USCVoiceprintParams.h"
#import "USCVoiceprintResult.h"
#import "USCIAudioSource.h"

@class USCRecoginizerParam;

#pragma mark -
#pragma mark 语音识别代理
@protocol USCVoiceprintRecognizerDelegate <NSObject>
/**
 *  返回错误信息
 *
 *  @param type     类型
 *  @param errorMSG 错误
 */
- (void)onError:(int)type error:(NSError *)errorMSG;

/**
 *  声纹处理过程中事件回调
 *
 *  @param type  类型
 *  @param times 发生事件
 *
 *  @return 结果
 */
- (int)onEvent:(int)type times:(int)times;

/** 声纹处理结果状态回调 VPR_REGISTER VPR_LOGIN
 *  返回识别信息
 *
 *  @param type       类型注册 :1 登录:2
 *  @param jsonResult 返回结果
 */
- (void)onResult:(int)type result:(NSString *)jsonResult;
@end

#pragma mark -
#pragma mark 声纹识别类

@interface USCVoiceprintRecognizer : NSObject
/**
 *  代理
 */
@property (nonatomic, weak) id<USCVoiceprintRecognizerDelegate> delegate;

/**
 *  初始化声纹识别对象
 *
 *  @param appkey appkey 请到云知声官网申请http://www.unisound.com/
 *  @param secret secret 请到云知声官网申请http://www.unisound.com/
 *
 *  @return 声纹识别对象
 */
- (id)initWithAppKey:(NSString *)appkey secret:(NSString *)secret;

/**
 *  启动声纹识别
 *
 *  @param userName 用户标识
 *  @param type     Type - 1:声纹注册 2:声纹登陆
 */
- (void)start:(NSString *)userName type:(NSString *)type;

/**
 *  停止声纹识别，即停止录音和识别
 */
- (void)stop;

/**
 *  取消，注意如果识别已经开始这个方法并不能取消识别线程。要中途取消识别请使用stop方法。
 */
- (void)cancel;

/**
 *  设置audiosource
 *
 *  @param audioSource  录音输入源
 *
 *  @return 0 表示成功,否则返回相应错误码
 */
- (int)setAudioSource:(USCIAudioSource *)audioSource;

/**
 *  设置可选项 如设置服务器地址SpeechConstants.VPR_SERVER_ADDR
 *
 *  @param key   key
 *  @param value value
 */
- (void)setOption:(int)key value:(id)value;

/**
 *  获取可选项
 *
 *  @param key key
 *
 *  @return value
 */
- (id)getOption:(int)key;

@end
