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
  //NSKeyedArchiver 归档工具类
    //归档姓名
    [aCoder encodeObject:_name forKey:@"name"];
    //归档年龄
    [aCoder encodeInteger:_age forKey:@"age"];
    //归档图片
    [aCoder encodeObject:UIImageJPEGRepresentation(_icon,1) forKey:@"icon"];
}
 /*
 * 序列化
 * 将对象解档
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
    //NSKeyedUnarchiver 解档
        
    //解档姓名
     _name=[aDecoder decodeObjectForKey:@"name"];
    //年龄
     _age=[aDecoder decodeIntegerForKey:@"age"];
    //头像
    NSData *data=[aDecoder decodeObjectForKey:@"icon"];
        _icon=[UIImage imageWithData:data];
        
    }
    return self;
}




@end
