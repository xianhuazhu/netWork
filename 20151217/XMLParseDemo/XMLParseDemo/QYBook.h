//
//  QYBook.h
//  XMLParseDemo
//
//  Created by qingyun on 15/12/18.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBookStore @"bookstore"
#define kBook        @"book"
#define kCategory   @"category"
#define kTitle         @"title"
#define kLanguage   @"lang"
#define kAuthor      @"author"
#define kYear         @"year"
#define kPrice        @"price"

@interface QYBook : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *price;

@end
