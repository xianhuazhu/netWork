//
//  QYStudent.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "QYStudent.h"

@implementation QYStudent


+(instancetype)initWithID:(int)Id Name:(NSString *)name withAge:(int)age withIcon:(UIImage *)icon{
    QYStudent *student=[[QYStudent alloc] init];
    student.ID=Id;
    student.name=name;
    student.age=age;
    student.icon=icon;
    return student;
}

@end
