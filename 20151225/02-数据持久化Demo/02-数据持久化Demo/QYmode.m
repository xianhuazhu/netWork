//
//  QYmode.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "QYmode.h"

@implementation QYmode



+(instancetype)initName:(NSString *)name fromAge:(NSInteger)age fromIcon:(UIImage *)icon{
    QYmode *mode=[[QYmode alloc] init];
    mode.age=age;
    mode.icon=icon;
    mode.name=name;
    return mode;
}
#pragma mark 实现coding协议
/*
 * 序列化
 * 将对象归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    //归档姓名
    [aCoder encodeObject:_name forKey:@"name"];
    //归档年龄
    [aCoder encodeInteger:_age forKey:@"age"];
    //归档图片
    [aCoder encodeObject:_icon forKey:@"icon"];
}
 /*
 * 序列化
 * 将对象解档
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
    //解档姓名
     _name=[aDecoder decodeObjectForKey:@"name"];
    //年龄
     _age=[aDecoder decodeIntegerForKey:@"age"];
    //头像
    _icon=[aDecoder decodeObjectForKey:@"icon"];
    }
    return self;
}




@end
