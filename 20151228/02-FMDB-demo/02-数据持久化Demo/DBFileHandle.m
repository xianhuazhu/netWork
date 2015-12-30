//
//  DBFileHandle.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "DBFileHandle.h"
#import "QYStudent.h"


//数据库名称
#define dbfile @"QYstudent.db"
//1.引入头文件
#include <sqlite3.h>


//1.静态变量，意味着全局可以访问，只是在.m访问
//2.db 数据库连接对象
static sqlite3 *db;

@interface DBFileHandle ()
@property(strong,nonatomic)NSString *filePath;
@end


@implementation DBFileHandle

+(instancetype)shareHandel{
    static DBFileHandle *fileHandel;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
     //执行一次
        fileHandel=[[DBFileHandle alloc] init];
     //创建表
        [fileHandel creaetTable];
    });
    return fileHandel;
}

//文件路径
-(NSString *)filePath{
    if (_filePath) {
        return _filePath;
    }
   //1.获取沙盒路径
    NSString *libaryPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory , NSUserDomainMask, YES)[0];
   //2.组合文件路径
    _filePath=[libaryPath stringByAppendingPathComponent:dbfile];
    return _filePath;
}
//打开数据库
-(BOOL)openDB{
    if(db){
        return YES;
    }
  //1创建数据库连接对象，打开数据库
    int count=sqlite3_open([self.filePath UTF8String],&db);
    if (count!=SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    NSLog(@"======数据库打开成功");
    return YES;
}


//关闭数据库
-(BOOL)closeDB{
    //关闭数据库连接对象
    if(sqlite3_close(db)!=SQLITE_OK){
        NSLog(@"=====关闭数据库失败");
        return NO;
    }
    //把db指针指向空
     db=NULL;
    return YES;
}


//创建表
-(BOOL)creaetTable{
 //1.打开数据库
  if (![self openDB]) {
        return NO;
    }
 //2sql语句
   NSString *sql=@"create table if not exists students(ID integer primary key,name text,age integer,icon blob)";
    
    
 //3执行sql语句
    char *errmsg;
   int result=sqlite3_exec(db, [sql UTF8String], NULL, NULL, &errmsg);
    if (result!=SQLITE_OK) {
        NSLog(@"==创建表失败===%s",errmsg);
        [self closeDB];
        return NO;
    }

 //4。关闭数据库
    [self closeDB];
    return YES;
}


-(BOOL)insertIntoData:(QYStudent *)mode{
   //1打开数据库
    if(![self openDB])return NO;
   //2sql语句
      NSString *sql=@"insert into students values(?,?,?,?)";
   //3.将sql语句转换成预编译对象
       //声明预编译对象指针；
       sqlite3_stmt *stmt;
       //第三个参数表上sql的长度 -1全部
       //第五个参数表上sql的地址，Null;
    int result=sqlite3_prepare_v2(db, [sql UTF8String],-1, &stmt, NULL);
    if (result!=SQLITE_OK) {
        NSLog(@"===预编译失败===%s",sqlite3_errmsg(db));
        [self closeDB];
        return NO;
    }
    //bind参数
    //第一个参数是预编译对象
    //第二个参数表示参数位置
    //第三个参数表示值
    sqlite3_bind_int(stmt, 1, mode.ID);
    //第四个参数表示字符串长度-1 全部
    //第五个参数表上析构函数（销毁对象）NUll
    sqlite3_bind_text(stmt, 2,[mode.name UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 3, mode.age);
    
    NSData *iconData=UIImageJPEGRepresentation(mode.icon, 1);
    sqlite3_bind_blob(stmt, 4, iconData.bytes,(int)iconData.length, NULL);
   //4.执行预编译对象
    result=sqlite3_step(stmt);
    //对于insert，update，delete sql语句执行，它们没有返回值，step结果用SQLITE_DONE
    //对于select语句执行有返回值，step结果SQLITE_ROW，取出结果要遍历
    if (result!=SQLITE_DONE) {
        NSLog(@"==插入执行失败===%s",sqlite3_errmsg(db));
        //销毁预编译对象
        sqlite3_finalize(stmt);
        [self closeDB];
        return NO;
    }
   //5.销毁预编译对象
    sqlite3_finalize(stmt);
   //6.关闭数据库
    [self closeDB];
    return YES;
}

-(BOOL)updateDataFromMode:(QYStudent *)mode{
   //1.打开数据库
    if (![self openDB]) {
        return NO;
    }
   //2sql语句
    NSString *sql=@"update students set name=?,age=?,icon=? where ID=?";
    
   //3.将sql语句转换成预编译对象
      //声明预编译对象
      sqlite3_stmt *stmt;
       //第三个参数表示sql长度 -1 全部
       //第五个参数表示sql地址 没有用 NULL
    int result=sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    if (result!=SQLITE_OK) {
        NSLog(@"======预编译对象失败====%s",sqlite3_errmsg(db));
        [self closeDB];
        return NO;
    }
    //bind 参数
    //第四个参数表示字符串长度 -1 全部
    //第五个参数字符串的析构函数，没有用，NULL可以了
    sqlite3_bind_text(stmt, 1, [mode.name UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 2, mode.age);
    
    NSData *iconData=UIImageJPEGRepresentation(mode.icon, 1);
    //第三个参数表示插入的二进制数据
    //第四个参数表示数据的长度
    //第五个参数析构函数，没有用，NULL可以了
    sqlite3_bind_blob(stmt, 3, iconData.bytes,(int)iconData.length, NULL);
    sqlite3_bind_int(stmt, 4, mode.ID);
   //4.执行预编译对象
    //insert,update,delete 执行后没有结果 结果==SQLITE_DONE
    //select 执行后有结果集需要通过遍历结果  结果SQLITE_ROW
    if (sqlite3_step(stmt)!=SQLITE_DONE) {
        NSLog(@"===预编译执行失败==%s",sqlite3_errmsg(db));
        sqlite3_finalize(stmt);
        [self closeDB];
        return NO;
    }
   //5.销毁预编译对象
    sqlite3_finalize(stmt);
   //6.关闭数据库
    [self closeDB];
    return YES;
}

-(BOOL)deleteDataFromId:(int)Id{
  //1.打开数据库
    if(![self openDB])return NO;
  //2.sql语句
    NSString *sql=@"delete from students where ID=?";
    
  //3.将sql语句转换成预编译对象
    //声明预编译对象指针
     sqlite3_stmt *stmt;
     //第三个参数表示sql的长度 -1 全部
     //第五个参数表示sql的地址，对我们没有用 NULL
    int result=sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
      if (result!=SQLITE_OK) {
        NSLog(@"=========%s",sqlite3_errmsg(db));
        [self closeDB];
        return NO;
      }
    //bind参数
    sqlite3_bind_int(stmt, 1, Id);
    
  //4.执行预编译对象
   result=sqlite3_step(stmt);
    //SQLITE_DONE 表示执行完成，insert，update,delete等没有返回值的语句
    //SQLITE_ROW  表示还有其他行没有读取，一般用于select语句
    if (result!=SQLITE_DONE) {
        NSLog(@"===执行失败=%s",sqlite3_errmsg(db));
        sqlite3_finalize(stmt);
        [self closeDB];
        return NO;
    }

  //5.销毁预编译对象
    sqlite3_finalize(stmt);
  //6.关闭数据库
    [self closeDB];
    return YES;
}

//将预编译对象里边的数据取出，同时将数据赋值给mode
-(QYStudent *)modeValueFromStmt:(sqlite3_stmt *)stmt{
   //1.取出学号
    //第一参数：预编译对象
    //第二个参数：表示位置
    int Id=sqlite3_column_int(stmt, 0);
    //2.取出name
    const unsigned char *cName=sqlite3_column_text(stmt, 1);
    //3.取出age
    int age=sqlite3_column_int(stmt, 2);
    //4.取出icon
     const void *iconData=sqlite3_column_blob(stmt, 3);
     int size=sqlite3_column_bytes(stmt, 3);
     NSData *data=[NSData dataWithBytes:iconData length:size];
    
    //mode 对象
    QYStudent *mode=[QYStudent initWithID:Id Name:[NSString stringWithUTF8String:(const char *)cName] withAge:age withIcon:[UIImage imageWithData:data]];
    
    return mode;
}



-(NSMutableArray *)selectValueFromId:(int)Id{
   //1.打开数据库
    if (![self openDB]) {
        return nil;
    }
   //2.sql语句
    NSString *sql=@"select * from students where ID=?";
    
   //3.将sql语句转换成预编译对象
     //声明预编译对象
      sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL)!=SQLITE_OK) {
        NSLog(@"=======%s",sqlite3_errmsg(db));
        [self closeDB];
        return nil;
    }
    //bind 参数
    sqlite3_bind_int(stmt, 1, Id);
    //4.执行预编译对象
    int result=sqlite3_step(stmt);
    
    //存放查询数据的数组
    NSMutableArray *dataArr=[NSMutableArray array];
    if (result==SQLITE_ROW) {
      //取出数据
     QYStudent *mode=[self modeValueFromStmt:stmt];
        [dataArr addObject:mode];
    }
   //5.销毁预编译对象
    sqlite3_finalize(stmt);

   //6.关闭数据库;
    [self closeDB];
    
    return dataArr;
}

-(NSMutableArray *)selectValueAll{
   //1.打开数据库
    if(![self openDB])return nil;

   //2.sql语句
    NSString *sql=@"select *from students";

   //3.将sql语句转换成预编译对象
    //声明预编对象指针
    sqlite3_stmt *stmt;
    int result=sqlite3_prepare(db, [sql UTF8String], -1, &stmt, NULL);
    if (result!=SQLITE_OK) {
        NSLog(@"=====%s",sqlite3_errmsg(db));
        [self closeDB];
        return nil;
    }
   //4.执行预编译对象
    NSMutableArray *dataArr=[NSMutableArray array];
    //遍历出所有的结果
    while (sqlite3_step(stmt)==SQLITE_ROW) {
        //取出数据，将数据转换成mode
       QYStudent *mode=[self modeValueFromStmt:stmt];
        if (mode) {
        [dataArr addObject:mode];
        }
    }
   //5.销毁预编译对象
    sqlite3_finalize(stmt);
   //6.关闭数据库
    [self closeDB];
    
    return dataArr;
}



@end
