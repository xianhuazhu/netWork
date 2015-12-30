//
//  DBFileFMDBHandel.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/28.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "DBFileFMDBHandel.h"
#import "FMDB.h"
#import "QYStudent.h"
#define DBName @"students.db"


@interface DBFileFMDBHandel ()
//数据库对象
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation DBFileFMDBHandel

+(instancetype)shareHandel{
    static DBFileFMDBHandel *handel;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        handel=[[DBFileFMDBHandel alloc] init];
        //初始化调用一次
        [handel createTable];
        
    });
    return handel;
}

-(NSString *)libaryPath{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
}

-(FMDatabase *)db{
    if (_db) {
        return _db;
    }
  //1.合并文件路径
    NSString*dbpath=[[self libaryPath]stringByAppendingPathComponent:DBName];
   //创建数据库对象
    _db=[FMDatabase databaseWithPath:dbpath];
    return _db;
}

-(BOOL)createTable{
 //1.打开数据库
    if (![self.db open]) {
        NSLog(@"======%@",[self.db lastErrorMessage]);
        return NO;
    }
 //2.执行sql
    if (![self.db executeUpdate:@"create table if not exists students(ID integer primary key,name text,age integer,icon blob)"]) {
        NSLog(@"=====%@",[self .db lastErrorMessage]);
        
        [self.db close];
        return NO;
    }
 //3.关闭数据库
    [self.db close];
    return YES;
}



-(BOOL)insertIntoData:(QYStudent *)mode{
  //1.打开数据库
    if (![self.db open]) {
        NSLog(@"========%@",[self.db lastErrorMessage]);
        return NO;
    }
  //2执行sql语句
   // [self.db executeUpdate:@"insert into students values(?,?,?,?)",@(mode.ID),mode.name,@(mode.age),UIImageJPEGRepresentation(mode.icon, 1)]
   //[self.db executeUpdateWithFormat:@"insert into students values(%d,%@,%d,%@)",mode.ID,mode.name,mode.age,UIImageJPEGRepresentation(mode.icon,1)]
    
    NSDictionary *dic=@{@"ID":@(mode.ID),@"name":mode.name,@"age":@(mode.age),@"icon":UIImageJPEGRepresentation(mode.icon, 1)};
    
    if (![self.db executeUpdate:@"insert into students values(:ID,:name,:age,:icon)" withParameterDictionary:dic]) {
        NSLog(@"======isnert error==%@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
  //3.关闭数据库
      [self.db close];
  
    return YES;
}

/*
 * 更新数据
 */
-(BOOL)updateDataFromMode:(QYStudent *)mode{
 //1打开数据库
    if (![self.db open]) {
        return NO;
    }
 //2.执行sql语句
    if (![self.db executeUpdate:@"update students set name=?,age=?,icon=? where ID=?",mode.name,@(mode.age),UIImageJPEGRepresentation(mode.icon, 1),@(mode.ID)]) {
        NSLog(@"=====error===%@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
 //3.关闭数据库
    
    [self.db close];
    return YES;
}

- (BOOL)deleteDataFromId:(int)Id
{
    //1.打开数据库
    if (![self.db open]) {
        return NO;
    }
    //2.执行sql语句
    if (![self.db executeUpdateWithFormat:@"delete from students where ID=%d",Id]) {
        [self.db close];
        return NO;
    }
    //3.关闭数据库
    [self.db close];
    return YES;
}

-(QYStudent *)modeFromRestvalue:(FMResultSet *)set{
    int Id=[set intForColumnIndex:0];
    
    NSString *name=[set stringForColumn:@"name"];
    
    int age=[set intForColumnIndex:2];
    
    NSData *data=[set dataForColumnIndex:3];
    
  return [QYStudent initWithID:Id Name:name withAge:age withIcon:[UIImage imageWithData:data]];
}

-(NSMutableArray *)selectValueFromId:(int)Id{
   //1.打开数据库
    if (![self.db open])return nil;
   //2.执行查询
    FMResultSet *set=[self.db executeQuery:@"select *from students where ID=?",@(Id)];
    //取出数据
    NSMutableArray *dataArr=[NSMutableArray array];
    while ([set next]) {
         NSLog(@"=======%@",[set resultDictionary]);
        [dataArr addObject:[self modeFromRestvalue:set]];
    }
    //关闭数据库
    [self.db close];
    return dataArr;
}

-(NSMutableArray *)selectValueAll{
   //1打开数据库
    if(![self.db open])return nil;
   //2执行sql语句
    FMResultSet*set=[self.db executeQuery:@"select *from students"];
    //取出数据
    NSMutableArray *dataArr=[NSMutableArray array];
    while ([set next]) {
      //添加mode
        [dataArr addObject:[self modeFromRestvalue:set]];
    }
    //关闭数据库
    [self.db close];
    return dataArr;
}


@end
