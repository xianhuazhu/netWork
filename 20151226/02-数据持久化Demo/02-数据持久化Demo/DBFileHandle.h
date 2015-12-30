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

@end
