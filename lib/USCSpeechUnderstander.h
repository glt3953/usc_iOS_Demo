//
//  USCSpeechUnderstander.h
//  nlu&asr
//
//  Created by yunzhisheng on 14-12-1.
//  Copyright (c) 2014年 usc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USCConstant.h"
#import "USCIAudioSource.h"

@class USCScene,USCSpeechResult,USCSceneManage;
#pragma mark -
#pragma mark 代理
@protocol USCSpeechUnderstanderDelegate <NSObject>
/**
 *   错误信息
 *
 *  @param type  错误类型
 *  @param error 错误
 */
- (void)onError:(int)type error:(NSError *)error;
/**
 *  事件回调
 *
 *  @param type 事件类型:如SPPEECHSTART,RECORDINGSTART,RECORDINGSTOP
 *  @param timeMs 
 */
- (void)onEvent:(int)type timeMs:(int)timeMs;
/**
 *  结果回调
 *
 *  @param type 结果类型:ASR_FIX_RESULT,ASR_ONLINE_RESULT,ASR_ONLINE_LAST_RESULT,ASR_NLU_RESULT
 *  @param jsonResult 结果
 */
- (void)onResult:(int)type jsonString:(NSString *)jsonString;
@end

#pragma mark -
#pragma mark 类
// @class - 语音理解类
// @brief - 语音识别和语义理解
@interface USCSpeechUnderstander : NSObject
/**
 *  代理
 */
@property (nonatomic,weak) id<USCSpeechUnderstanderDelegate> delegate;

/**
 *  初始化
 *
 *  @param context 上下文环境变量，设置nil即可
 *  @param appKey  appkey 请到官网申请
 *  @param start   secret 请到官网申请
 *
 *  @return 识别对象
 */
- (id)initWithContext:(NSString *)context appKey:(NSString *)appKey secret:(NSString *)secret;

/**
 *  开始语音识别,使用默认模型
 */
- (void)start;

/**
 *  结束录音，停止本次语音识别，并回调相关结果,非阻塞.先录音停止回调onEvent type=ASR_EVENT_RECORDING_STOP 再完成识别回调onEvent type=ASR_EVENT_RECOGNIZITION_END，
 */
- (void)stop;

/**
 *  取消本次语音识别,停止所有相关回调
 */
- (void)cancel;

/**
 *   设置audiosource
 *
 *  @param audioSource
 *
 *  @return 0 表示成功， 否则返回相应错误码
 */
- (int)setAudioSource:(USCIAudioSource *)audioSource;

/**
 *  设置参数
 *
 *  设置在线识别带宽 ASR_BANDWIDTH
 *
 *  设置识别领域 USC_ASR_DOMAIN
 *
 *  设置远近讲 USC_ASR_VOICE_FIELD 默认为近讲,@"near"近讲，@"far"远讲
 *
 *  设置识别语言 USC_ASR_LANGUAGE 默认普通话，@"chinese"普通话,@"english"英文,@"cantoness"粤语。
 *
 *  设置VAD前端点超时 USC_ASR_VAD_TIMEOUT_FRONTSIL 范围 int 1000~10000 (ms)
 *
 *  设置VAD后端点超时 USC_ASR_VAD_TIMEOUT_BACKSIL 范围 int 300-1000 (ms)
 *
 *  设置识别结果是否包含标点符号 USC_ASR_NET_PNUCTUATION ，返会设置 @"true" ,不返回设置@"false"
 *
 *  设置语音解析服务器 ASR_SERVER_ADDR 格式:@"ip:port"
 *
 *  设置同步请求语义结果 USC_NLU_ENABLE 默认同步请求语义 ,设置@"true"请求语义，@"false"不请求语义
 *
 *  设置语义理解场景 USC_NLU_SCENARIO.
 *
 *  设置语音解析服务器 USC_ASR_SERVER_ADDR 格式:@"ip:port"
 *
 *  设置网络交互超时 USC_ASR_NET_TIMEOUT 范围 int 3000~10000 (ms)
 *
 *  设置是否开启定位功能 USC_ASR_LOCATION_ENABLE。默认开启@"true"开启，@"false"关闭
 *
 *  @param key   key
 *  @param value value
 */
- (void)setOption:(int)key value:(id)value;

/**
 *  获取设置选项
 *  
 *  USC_ASR_EVENT_VOLUMECHANGE 获取录音音量返回NSNumber
 *  @param key 选项对应key
 *
 *  @return 选项值
 */
- (id)getOption:(int)key;


/**
 *  上传用户词表，非阻塞,上传完成后回调onEvent type=　ASR_EVENT_USERDATA_UPLOADED,用户设置命令词并上传，提高识别率,如果当前为在线识别，则上传词表
 *
 *  @param userData 用户词表
 */
- (void)uploadUserData:(NSDictionary *)userData;


@end
