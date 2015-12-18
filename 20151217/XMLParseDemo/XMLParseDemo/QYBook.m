//
//  QYBook.m
//  XMLParseDemo
//
//  Created by qingyun on 15/12/18.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYBook.h"

@implementation QYBook

- (NSString *)description{
    NSString *desc = [NSString stringWithFormat:@"BookInfo:\r Title:<%@>\r Language:<%@>\r Category:<%@>\r Author:<%@>\r Year:<%@>\r Price:<%@>\r",_title, _lang, _category, _author, _year, _price];
    return desc;
}
@end
