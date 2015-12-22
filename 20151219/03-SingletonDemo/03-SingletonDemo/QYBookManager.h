//
//  QYBookManager.h
//  03-SingletonDemo
//
//  Created by qingyun on 15/12/19.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYBookManager : NSObject

/**
 * defaultXXX sharedXXX standardXXX
 */
+ (instancetype)sharedManager;

@end
