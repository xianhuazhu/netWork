//
//  ViewController.m
//  AsyncRequestDemo
//
//  Created by qingyun on 15/12/17.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#define kSongURLStr   @"http://down.5nd.com/a/down.ashx?t=1&xcode=0b28de1ff927eb3c16eea3c14442219c&sid=602471"

#import "ViewController.h"

@interface ViewController () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *songData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //创建一个NSUrl路径
    NSURL *url = [NSURL URLWithString:kSongURLStr];
    
    //创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:0];
    //发送请求
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark -NSUrlConnectionDataDelegate
//接到服务器响应调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //如果响应成功，则申请内存
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200) {
        _songData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //如果收到数据，在songData后面追加数据
    static int count = 0;
    [_songData appendData:data];
    NSLog(@"<%d>:%@", count++ , data);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //将数据保存到文件
    [_songData writeToFile:@"/Users/qingyun/Desktop/song.mp3" atomically:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
