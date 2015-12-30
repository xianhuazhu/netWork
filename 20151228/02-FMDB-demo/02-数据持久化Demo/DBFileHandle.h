//
//  DBFileHandle.h
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QYStudent;
@interface DBFileHandle : NSObject

+(instancetype)shareHandel;

/**
 插入数据
 ***/
-(BOOL)insertIntoData:(QYStudent *)mode;
/*
 * 更新数据
 */
-(BOOL)updateDataFromMode:(QYStudent *)mode;
/*
 *删除数据
 */
-(BOOL)deleteDataFromId:(int)Id;
/*
 *查询单个数据
 */
-(NSMutableArray *)selectValueFromId:(int)Id;
/*
 *查询所有的数据
 ***/
-(NSMutableArray *)selectValueAll;


@end
