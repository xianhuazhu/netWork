//
//  FileHandle.m
//  01-租房
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "FileHandle.h"

@implementation FileHandle

+(instancetype)shareHandel{
    static FileHandle *handle;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handle=[[FileHandle alloc] init];
    });
    return handle;
}
//创建文件路径
-(NSString*)filePath:(NSString *)name{
  //1.获取沙盒路径
    NSString *libaryPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
  //2.创建文件路径 libary/name
    NSString *filePath=[libaryPath stringByAppendingPathComponent:name];
  //3.判断文件是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return filePath;
    }
    
    //4.创建文件
    if([[NSFileManager defaultManager]createFileAtPath:filePath contents:nil attributes:0]) return filePath;
    
    return nil;
}


-(BOOL)saveLocalValue:(NSArray *)value saveName:(NSString *)name{
   //将租房列表存在本地文件
    return [value writeToFile:[self filePath:name] atomically:YES];
}

-(NSMutableArray *)loadFromLocal:(NSString *)name{
    //从本地获取租房列表
    return [[NSMutableArray alloc] initWithContentsOfFile:[self filePath:name]];
}

-(BOOL)savelocalImage:(UIImage*)image saveName:(NSString *)name{
   //1.转化成Nsdata
    NSData *data=UIImageJPEGRepresentation(image, 1);
   //2.写在本地
    return [data writeToFile:[self filePath:name] atomically:YES];
}

-(UIImage*)loadImageFormLocal:(NSString *)name{
    return [UIImage imageWithContentsOfFile:[self filePath:name]];
}


@end
