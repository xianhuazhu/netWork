//
//  DBFileHandel.m
//  01-Fmdb作业
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "DBFileHandel.h"
#import "Header.h"
#import "QYstudent.h"


@interface DBFileHandel ()
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation DBFileHandel

+(instancetype)shareHandel{
    static DBFileHandel *handel;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handel=[[DBFileHandel alloc] init];
        
        [handel createTable];
    });
    return handel;
}

-(FMDatabase *)db{
    if (_db) {
        return _db;
    }
    //创建db对象
    NSString *libaryPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    
    NSString *filePath=[libaryPath stringByAppendingPathComponent:DBFILENAME];
    
    _db=[FMDatabase databaseWithPath:filePath];
    return _db;
}

/*
 *创建表
 */
-(BOOL)createTable{
  //1.打开数据库
    if (![self.db open]) {
        return NO;
    }
    
  //2.执行sql语句
    if (![self.db executeUpdate:@"create table if not exists student(stu_id text primary key,name text,age integer)"]) {
        NSLog(@"======error==%@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
   //3.关闭数据库
    [self.db close];
    return YES;
}

-(BOOL)insertIntoDataFrom:(QYstudent *)mode{
 //1.打开数据库
    if (![self.db open]) {
        return NO;
    }
  //2.执行sql语句
    if(![self.db executeUpdate:@"insert into student values(?,?,?)",mode.stu_id,mode.name,@(mode.age)]){
        NSLog(@"=====error===%@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
    //3.关闭数据库
    [self.db close];
    
    return YES;
}

-(NSMutableArray *)selectAllData{
 //1.打开数据库
    if(![self.db open]) return nil;
    
 //2.执行sql
  FMResultSet *set=[self.db executeQuery:@"select *from student"];
   NSMutableArray *arr=[NSMutableArray array];
    while ([set next]) {
//        NSString *stu_id=[set stringForColumn:@"stu_id"];
        
     //kvc;
     QYstudent *student=[[QYstudent alloc] initWithDic:[set resultDictionary]];
     [arr addObject:student];
    }
    
  //3.关闭数据库
    [self.db close];
    return arr;
}

-(NSMutableArray *)selectFromDataWithName:(NSString *)stu_id{
  //1打开数据库
    if (![self.db open]) {
        return nil;
    }
 //2.执行sql
   // FMResultSet *set=[self.db executeQueryWithFormat:@"select * from student where name like '%%%@%%'",name];
    FMResultSet *set=[self.db executeQueryWithFormat:@"select * from student where stu_id=%@",stu_id];
    NSMutableArray *arr=[NSMutableArray array];
    while ([set next]) {
        //kvc
        QYstudent *student=[[QYstudent alloc] initWithDic:[set resultDictionary]];
        [arr addObject:student];
    }
  //3.关闭数据库
    [self.db close];
    return arr;
}

-(BOOL)deleteDataFromStuid:(NSString *)stuId{
  //1.打开数据库
    if(![self.db open])return NO;
  //2.执行删除
    if (![self.db executeUpdate:@"delete from student where stu_id=?",stuId]) {
        NSLog(@"=====error=====%@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
  //3.关闭数据库
    [self.db close];
    return YES;
}
-(BOOL)deleteDataAll{
 //1.打开数据库
    if (![self.db open]) {
        return NO;
    }
 //2.执行删除操作
    if (![self.db executeUpdate:@"delete from student"]) {
        NSLog(@"=====%@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
 //3.关闭数据库
    [self.db close];
  return YES;
}





@end
