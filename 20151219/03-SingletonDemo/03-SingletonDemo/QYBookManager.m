//
//  QYBookManager.m
//  03-SingletonDemo
//
//  Created by qingyun on 15/12/19.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "QYBookManager.h"

@implementation QYBookManager

#if 0
+ (instancetype)sharedManager {
    static QYBookManager *manager;
    // lock
    if (manager == nil) {
        // ...
        [NSThread sleepForTimeInterval:2];
        manager = [[QYBookManager alloc] init];
        // unlock

    }

    return manager;
}
#endif

+ (instancetype)sharedManager {
    static QYBookManager *manager;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [NSThread sleepForTimeInterval:3];
        manager = [[QYBookManager alloc] init];
    });
    return manager;
}

@end
