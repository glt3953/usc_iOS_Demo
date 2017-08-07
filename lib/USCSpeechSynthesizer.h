//
//  USCOnlineTTS.h
//  tts_online_test2
//
//  Created by yunzhisheng-zy on 14-12-4.
//  Copyright (c) 2014年 usc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USCIAudioSource.h"

#pragma mark -
#pragma mark protocal

/**
 *  语音合成参数
 */
typedef enum
{
    /**
     *  音高 取值 0~100 50为标准音高,只能设整数
     */
    USCSynthesizeParam_Volume,
    /**
     *  语速 取值 0~100 50为标准语速,只能设整数
     */
    USCSynthesizeParam_Speed,
    /**
     *  发音人 为说话人 @"xiaoli" 中文女生（默认） @"Joe" 英文男生，注意英文男生首字母大写
     */
    USCSynthesizeParam_VoiceName
}USCSynthesizeParam;

// @class - 协议
// @brief - 语音合成的相关代理方法
@protocol USCSpeechSynthesizerDelegate <NSObject>
/**
 *  合成出错
 *
 *  @param type     类型
 *  @param errorMSG 错误
 */
- (void)onError:(int)type error:(NSError *)errorMSG;

/**
 *  在合成过程中的事件的回调 包括 start，pause，play，resume，
 *
 *  @param type 事件类型
 */
- (void)onEvent:(int)type;
@end

#pragma mark -
#pragma mark 类
// @class - 在线TTS类
// @brief - 在线把文字转语音播放
@interface USCSpeechSynthesizer : NSObject

@property (nonatomic,weak) id<USCSpeechSynthesizerDelegate> delegate;
/**
 *  初始化
 *
 *  @param appKey  appkey  请到官网申请
 *  @param secret   secret 请到官网申请
 *
 *  @return 返回合成实例
 */
- (id)initWithAppkey:(NSString *)appkey secret:(NSString *)secret;

/**
 *  设置需要合成的utf8的文本, 并开始合成,非阻塞
 *  开始合成回调 onEvent type=TTS_EVENT_SYNTHESIZE_START
 *  合成完成后回调onEvent type= onEvent type=TTS_EVENT_SYNTHESIZE_STOP
 *
 *  @param utfTxt 要合成的文本
 */
- (void)synthesizeText:(NSString *)utfTxt;

/**
 *  合成并播放utf8的文本,直到播放结束,非阻塞 开始合成回调onEvent type=TTS_EVENT_SYNTHESIZE_START 合成完成后回调onEvent type= TTS_EVENT_SYNTHESIZE_STOP
 *  播放完成后回调onEvent type= TTS_EVENT_PLAYING_STOP
 *
 *  @param utfTxt 要合成的文本
 *
 *  @return 正常播放返回0
 */
- (int)playText:(NSString *)utfTxt;

/**
 *  将前面合成的声音播放出来,非阻塞 播放完成后回调onEvent type= TTS_EVENT_PLAYING_STOP
 */
- (void)playSynWav;

/**
 *  停止播放,非阻塞
 */
- (void)stop;

/**
 *  暂停后恢复合成,非阻塞
 */
- (void)resume;

/**
 *  暂停播放,非阻塞
 */
- (void)pause;

/**
 *  设置合成相关参数
 *
 *  设置合成语速 USC_TTS_KEY_VOICE_SPEED 范围 0 ~ 100 int
 *  设置合成音高 USC_TTS_KEY_VOICE_PITCH 范围 0 ~ 100 int
 *  设置合成音量 USC_TTS_KEY_VOICE_VOLUME 范围 0 ~ 100 int
 *  
 *  @param key   键
 *  @param value 值
 */
- (void)setOption:(int)key value:(id)value;

/**
 *  用来设置 audiosource
 *
 *  @param audioSource 音频输出源
 *
 *  @return 0 表示成功， 否则返回相应错误码
 */
- (int)setAudioSource:(USCIAudioSource *)audioSource;
@end
