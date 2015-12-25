//
//  AppDelegate.m
//  03-settingsBundle
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1.获取Root.plist的路径
    NSString *settingPath=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSString *rootPath=[settingPath stringByAppendingPathComponent:@"Root.plist"];
    
    NSLog(@"====%@",NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]);
    
    //2.读取plist 文件
    NSDictionary *rootDic=[[NSDictionary alloc] initWithContentsOfFile:rootPath];
    //3.获取数组控件的属性和值 数组
    NSArray *arr=rootDic[@"PreferenceSpecifiers"];
    //4.获取设置控件的有效值
      //4.1声明一个字典；
    NSMutableDictionary *valueDic=[NSMutableDictionary dictionary];
    //4.2 读取arr的字典值，控件字典的值key的value值作为 valueDic的key；把控件字典的DefaultValue值作为ValueDic的value值
    
    for (NSDictionary *vDic in arr) {
        NSString *key=vDic[@"key"];
        NSString *value=vDic[@"DefaultValue"];
        if (key&&value) {
         //存放到字典
        [valueDic setObject:value forKey:key];
        }
    }
    
    //注册到注册作用域
    //[[NSUserDefaults standardUserDefaults] registerDefaults:valueDic];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
