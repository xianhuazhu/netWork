//
//  DBFileHandel.h
//  01-Fmdb作业
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QYstudent;
@interface DBFileHandel : NSObject

+(instancetype)shareHandel;

//插入数据
-(BOOL)insertIntoDataFrom:(QYstudent *)mode;
//查询所有数据
-(NSMutableArray *)selectAllData;
//以名字的方式模糊查询
-(NSMutableArray *)selectFromDataWithName:(NSString *)stu_id;


//删除一条数据
-(BOOL)deleteDataFromStuid:(NSString *)stuId;
//清空表里边的数据
-(BOOL)deleteDataAll;

@end
