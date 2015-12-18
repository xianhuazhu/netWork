//
//  ViewController.m
//  下载音乐
//
//  Created by qingyun on 15/12/15.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#define kSongURLStr @"http://down.5nd.com/a/down.ashx?t=1&xcode=476e6708d9847a40682349adf76f6396&sid=602003"
#define kSongPath @"/Users/qingyun/Desktop/aaa.mp3"

#import "ViewController.h"

@interface ViewController () <NSURLConnectionDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)downLoadMusic:(id)sender {
    
    //1.设置请求路径
    NSURL *url = [NSURL URLWithString:kSongURLStr];
    
    //2.创建请求对象（设置请求头和请求体）
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:60];
    
    //3.发送请求
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];

}

#pragma mark -NSURLConnectionDataDelegate
//当接收到服务器的响应（联通了服务器）时会调用
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //如果响应成功，则创建文件
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode == 200) {//200服务器成功返回网页，服务器成功处理了请求
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:kSongPath contents:nil attributes:nil];
        if (!result) {
            NSLog(@"创建文件失败");
            [connection cancel];
            return;
        }
    }
}

//当接收到服务器的数据时会调用（可能会被调用多次，每次只传递部分数据）
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //如果收到数据，在文件里追加数据
    static int count = 0;
    //打开一个文件准备读取
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:kSongPath];
    if (fileHandle == nil) {
        NSLog(@"打开文件失败");
        [connection cancel];
        return;
    }
    //跳到文件末尾
    [fileHandle seekToEndOfFile];
    //写入数据
    [fileHandle writeData:data];
    [fileHandle closeFile];
    
    NSLog(@"<%d>:%@",count++,data);
}

//当服务器的数据加载完毕时就会调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //将数据保存到文件
    NSLog(@"下载完成");
}

//请求错误（失败）的时候调用（请求超时\断网\没有网，一般指客户端错误）
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"请求失败");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
