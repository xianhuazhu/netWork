//
//  QYstudent.m
//  01-Fmdb作业
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "QYstudent.h"

@implementation QYstudent


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.stu_id=value;
    }
}


-(instancetype)initWithDic:(NSDictionary *)value{
    if (self=[super init]) {
        //kvc进行赋值
        [self setValuesForKeysWithDictionary:value];
    }
    return self;
}


@end
