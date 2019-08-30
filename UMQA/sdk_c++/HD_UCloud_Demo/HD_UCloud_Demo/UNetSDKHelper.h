//
//  UNetSDKHelper.hpp
//  HD_UCloud_Demo
//
//  Created by ethan on 2019/3/6.
//  Copyright © 2019 ucloud. All rights reserved.
//

#include <stdio.h>
#import <UNetAnalysisSDK/UNetAnalysisSDK.h>
#include <map>
#include <string>

class UCloudSDKHelper
{
public:
    static UCloudSDKHelper * getInstance();
    UCloudSDKHelper();
    ~UCloudSDKHelper();
    
    
    /**
     @brief 注册SDK(必须)
     */
    void registSDK();
    
    
    /**
     @brief 设置自定义上报字段(非必须)
     
     @discussion  特别注意： 如果你要上报的字段在注册SDK之前能获取到，则需要在注册SDK之前调用设置自定义字段方法；如果你要上报的字段在注册SDK的时候还没有获取到，则可以在获取到该字段时调用设置自定义字段方法，但是前期SDK诊断的数据上报时可能不含有你设置的自定义字段。

     @param pFields 自定义上报字段map，该字段有长度限制，所有key-value最后转化为字符串的总长度不能超过1024
     @return 0:表示成功；1表示失败
     */
    int settingFields(std::map<std::string,std::string> *pFields);
    
    /**
     @brief 关闭自动检测功能(非必须)
     
     @discussion 如果你不想使用SDK的自动触发检测逻辑，那么你可以选择将其关闭。关闭自动触发检测逻辑后，需要你手动调用执行诊断功能才会触发网络检测。如果你调用了该方法，那么你只有自己调用`startDetectNet`才会触发网路数据诊断收集
     */
    void closeAutoDetectNet();
    
    /**
     @brief 触发网路检测(非必须)
     
     @discussion sdk会检测手机网络变化并触发网络检测。你也可以调用此方法来手动触发网络检测。
     */
    void startDetectNet();
    
    
    /**
     @brief 在app失去活跃状态时，停止网络数据采集(非必须)
     */
    void stopDataCollection();
    
    
    /**
     @brief 防止IOS12网络请求CPU占用过高(发生场景：网络采集过程中点击home键又快速回到app) （非必须）
     */
    void avoidCpuHightInIOS12();
    
private:
    static UCloudSDKHelper * m_instance;
};
