//
//  ViewController.m
//  syncRequestDemo
//
//  Created by qingyun on 15/12/15.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.创建URL对象
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    //2.创建URL请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发起请求（连接）
    NSURLRequest *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"%ld",(long)httpResponse.statusCode);
    
    NSDictionary *responseHeaders = [httpResponse allHeaderFields];
    NSString *contentType = responseHeaders[@"Content-Type"];
    NSLog(@"%@",contentType);
    
    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"==>%@",html);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
