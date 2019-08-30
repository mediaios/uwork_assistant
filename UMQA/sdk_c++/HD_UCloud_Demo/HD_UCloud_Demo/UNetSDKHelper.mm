//
//  UNetSDKHelper.cpp
//  HD_UCloud_Demo
//
//  Created by ethan on 2019/3/6.
//  Copyright © 2019 ucloud. All rights reserved.
//

#include "UNetSDKHelper.h"



UCloudSDKHelper::UCloudSDKHelper(){}
UCloudSDKHelper::~UCloudSDKHelper(){};

UCloudSDKHelper * UCloudSDKHelper::m_instance = NULL;
UCloudSDKHelper * UCloudSDKHelper::getInstance()
{
    if(m_instance == NULL){
        m_instance = new UCloudSDKHelper();
    }
    return m_instance;
}

void UCloudSDKHelper::registSDK()
{
    // 1. 设置日志级别(非必须)：为了在开发调试时有比较详细的日志，我们建议在注册SDK前设置日志级别为debug级别，在发布时移除日志级别设置。
    [[UMQAClient shareInstance] uNetSettingSDKLogLevel:UCSDKLogLevel_DEBUG];
    
    // 2. 注册SDK(必须)： 我们推荐在App刚启动时注册SDK
    NSString *appkey = @""; // 你的appkey
    NSString *appSecret = @""; //你的app公钥
    [[UMQAClient shareInstance] uNetRegistSdkWithAppKey:appkey appSecret:appSecret completeHandler:^(UCError * _Nullable ucError) {
        if (ucError) {
            NSLog(@"regist UNetAnalysisSDK error , error info: %@",ucError.error.description);
        }else{
            NSLog(@"regist UNetAnalysisSDK success...");
            
            // 3. 设置手动诊断的服务地址(非必须)：如果你在此处设置你们服务的ip地址，那么我们做自动网络诊断时会包含对该ip的诊断；手动诊断时只诊断你所设置的这些ip
            NSArray *customerIps = @[@"61.135.169.121"]; // 此处填入你要手动诊断的网络地址,只支持ip
            [[UMQAClient shareInstance] uNetSettingCustomerIpList:customerIps];
        }
    }];
}

/*
 @brief 设置自定义上报字段(非必须)
 @discussion 如果你要上报的字段在注册SDK之前能获取到，则需要在注册SDK之前调用此方法；如果你要上报的字段在注册SDK的时候还没有获取到，则可以在获取到该字段时调用此方法设置，但是前期SDK诊断的数据上报时可能不含有你设置的自定义字段。
 @param fields 用户自定义上报字段。如果没有直接传nil。该字段有长度限制，最后转化为字符串的总长度不能超过1024
 @param handler `UCNetErrorHandler` 类型的 `block`，通过这个 `block` 来告知用户是设置是否成功.  如果成功，则 `error` 为空。
 
 特别注意： 如果你要上报的字段在注册SDK之前能获取到，则需要在注册SDK之前调用设置自定义字段方法；如果你要上报的字段在注册SDK的时候还没有获取到，则可以在获取到该字段时调用设置自定义字段方法，但是前期SDK诊断的数据上报时可能不含有你设置的自定义字段。
 */
int UCloudSDKHelper::settingFields(std::map<std::string,std::string> *pFields)
{
    __block int res = 0;
    NSMutableDictionary *userDefines = [NSMutableDictionary dictionary];
    std::map<std::string,std::string>::iterator iter;
    iter = pFields->begin();
    while (iter != pFields->end()) {
        NSString *key = [NSString stringWithCString:iter->first.c_str() encoding:[NSString defaultCStringEncoding]];
        NSString *value = [NSString stringWithCString:iter->second.c_str() encoding:[NSString defaultCStringEncoding]];
        [userDefines setObject:value forKey:key];
        iter++;
    }
    [[UMQAClient shareInstance] uNetSettingUserDefineFields:userDefines handler:^(UCError * _Nullable ucError) {
        if (!ucError) {
           res = -1;
        }
    }];

    return res;
}


void UCloudSDKHelper::closeAutoDetectNet()
{
    [[UMQAClient shareInstance] uNetCloseAutoDetectNet];
}

void UCloudSDKHelper::startDetectNet()
{
    [[UMQAClient shareInstance] uNetStartDetect];
}


void UCloudSDKHelper::stopDataCollection()
{
    // 4. 停止网络数据收集(非必须): 我们建议，当用户点击home键app进入非活跃状态时，停止网络数据收集，主要是为了防止当用户点击home键然后再打开app时signal pipe引起的app 闪退。如果你们测试没有这种问题，可以不调用该方法
    [[UMQAClient shareInstance] uNetStopDataCollectionWhenAppWillResignActive];
}

void UCloudSDKHelper::avoidCpuHightInIOS12()
{
    /* 5. 适配ios12(非必须): 在ios12中(ios12以下的版本没有发现问题)，如果正在执行诊断的过程中按锁屏键然后再次进入app，会导致app一瞬间cpu占用过高，引起该问题的原因是NSURLSession在ios12的问题，详细信息可查看 AFNetWorking---NSPOSIXErrorDomain Code=53: Software caused connection abort 以及Firebase Dynamic Links sometimes got error NSPOSIXErrorDomain Code=53 "Software caused connection abort都是类似的问题。
    由于我们SDK内部也使用了NSURLSession，所以我们增加了方法uNetAppDidEnterBackground用于处理这种问题。该方法内部的实现逻辑是延迟进入挂起状态，如果你的app有后台模式或者有延迟挂起逻辑，那么可以忽略该方法。
     */
    [[UMQAClient shareInstance] uNetAppDidEnterBackground];
}


