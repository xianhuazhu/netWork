//
//  QYStudent.h
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QYStudent : NSObject
@property(nonatomic,assign)int ID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)int age;
@property(nonatomic,strong)UIImage *icon;

+(instancetype)initWithID:(int)Id Name:(NSString *)name withAge:(int)age withIcon:(UIImage *)icon;


@end
