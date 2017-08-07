//
//  USCConstantFile.h
//  asr&nlu&tts
//
//  Created by iOSDeveloper-zy on 15-5-5.
//  Copyright (c) 2015年 usc. All rights reserved.
//

#import <Foundation/Foundation.h>

//static const int ddLogLevel

#define AUDIOBUFFERSIZE 3200

#define kLabelH 20
#define padding 10

// 识别领域
NSString * const USC_ENGINE_GENERAL = @"general";
NSString * const USC_ENGINE_POI = @"poi";
NSString * const USC_ENGINE_SONG = @"song";
NSString * const USC_ENGINE_MOVIETV = @"movietv";
NSString * const USC_ENGINE_MEDICAL = @"medical";

// 识别语言
NSString * const USC_LANGUAGE_CHINESE = @"chinese";
//NSString * const USC_LANGUAGE_ENGLISH = @"english";
//NSString * const USC_LANGUAGE_CANTONESE = @"cantonese";

typedef enum {
    USCLogLevel_NO,
    USCLogLevel_Debug,
    USCLogLevel_Info,
    USCLogLevel_Verbose
}USCLogLevel;

/*
 上传个性化数据支持的类型
 */
typedef enum
{
    kUSCPersonName = 1,
    kUSCAppName    = 2,
    kUSCSongName   = 3,

    /*
     新增加的个性化上传标签
     */
    kUSCSongerName = 4,
    kUSCAlbumName  = 5,
    kUSCCommandName= 6,
    kUSCPoiName    = 7
} USCUserDataType;

typedef enum
{
    USC_SERVICE_ADDRESS_PORT = 100, //设置私有识别服务器
    SAMPLE_RATE_AUTO = 400, //设置2G/3G智能切换
}USCRecognizerProperty;

/*!
 识别语言
 */
typedef enum {
    USCRecognizeLanguage_CN,// 中文
    USCRecognizeLanguage_EN,// 英文
    USCRecognizeLanguage_CO // 粤语
}USCRecognizeLanguage;

/*!
 声纹类型
 */
typedef enum {
    USCVPRTypeRegister = 1,
    USCVPRTypeLogin
}USCVPRType;

/**
 * 16kto 8k
 */
static int RATE_8K = 8000;
/**
 * 16k
 */
static  int RATE_16K = 16000;
/**
 * 8k语音输入
 */
static  int RATE_REAL_8K = 80000;

static   NSString *VOICE_FIELD_FAR = @"far";
static   NSString *VOICE_FIELD_NEAR = @"near";
static   NSString *SAMPLE_RATE_8K = @"8k";
static   NSString *SAMPLE_RATE_16K = @"16k";
static   NSString *SAMPLE_RATE_16kto8K = @"16kto8k";

