//
//  ViewController.m
//  HTTPHEADMethodDemo
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
    NSURL *url = [NSURL URLWithString:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";
    
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSLog(@"%@",data);
    NSLog(@"%@",httpResponse);
    NSLog(@"suggestedFileName:%@",response.suggestedFilename);
    NSLog(@"expectedContenLength:%lld", response.expectedContentLength);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
