//
//  ViewController.m
//  POSTDemo
//
//  Created by qingyun on 15/12/17.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)login:(id)sender {
    NSString *urlStr = @"http://jw.zzu.edu.cn/scripts/freeroom/freeroom.dll/mylogin";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    //设置post方法
    [request setHTTPMethod:@"POST"];
    
    //设置body
    NSString *bodyStr = @"zhanghao=20132450412&mima=8998264978&B1=登录";
    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    
    NSLog(@"<<%@",data);
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:enc];
    NSLog(@">>%@",dataStr);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
