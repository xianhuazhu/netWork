//
//  QYstudent.h
//  01-Fmdb作业
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYstudent : NSObject
@property(nonatomic,assign)int age;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *stu_id;

-(instancetype)initWithDic:(NSDictionary *)value;

@end
