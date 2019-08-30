//
//  AppDelegate.m
//  HD_UCloud_Demo
//
//  Created by ethan on 2019/3/6.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import "AppDelegate.h"
#include "UNetSDKHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // 设置自定义上报字段，你也可以延后设置
    std::map<std::string,std::string> userDefines;
    std::map<std::string,std::string> *p_userDefines = &userDefines;
    p_userDefines->insert(std::pair<std::string,std::string>("playerid","str_11111111"));
    p_userDefines->insert(std::pair<std::string,std::string>("account", "00000000000"));
    UCloudSDKHelper::getInstance()->settingFields(p_userDefines);
    
    // 注册,内部设置的日志级别是debug,在发布前请改成error，或者移除设置
    UCloudSDKHelper::getInstance()->registSDK();
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UCloudSDKHelper::getInstance()->stopDataCollection();
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    UCloudSDKHelper::getInstance()->avoidCpuHightInIOS12();
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
