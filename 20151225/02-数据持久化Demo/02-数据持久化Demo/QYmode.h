//
//  QYmode.h
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface QYmode : NSObject<NSCoding>
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,strong)UIImage *icon;

+(instancetype)initName:(NSString *)name fromAge:(NSInteger)age fromIcon:(UIImage *)icon;


@end
