//
//  ViewController.m
//  HTTPHeaderDemo
//
//  Created by qingyun on 15/12/17.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#define kImgUrlStr @"http://d.lanrentuku.com/down/png/1510/weixin-qq-icon/pengyouquan.png"

@interface ViewController () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableData *imgData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_imageView];
    
    [self fetchAndSetImageViewFrame];
}

- (void)fetchAndSetImageViewFrame{
    //加载图片，进行网络请求
    NSURL *url = [NSURL URLWithString:kImgUrlStr];
    //创建请求，这个请求头要加字段，所以是可变的
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置头字段（加了个名为Rangle的，内容是bytes=16-23的头字段） 。if you are making HTTP or HTTPS byte-range requests, always use the (NSUrlRequestReloadIgnoringLocalCacheData) policy
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    //用range时忽略本地缓存
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    NSURLResponse *response;
    //发送请求（同步请求）
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSLog(@"%@", data);
    
    CGSize size = [self pngSizeWithData:data];
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
    _imageView.center = self.view.center;
    _imageView.center = self.view.center;
}

//数据的解析
- (CGSize)pngSizeWithData:(NSData *)data{

    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    //对data发消息
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    
    
    //得到的数据是大端的，要转换成小端。大端默认（低字节放高地址，高字节放低地址），（第一个获取的值左移24位，第二个左移16，第三个左移8个）（4个字节，每个字节8byte）
    int w= (w1<<24) + (w2<<16) + (w3<<8) + w4;
    
    int h1=0, h2=0, h3=0, h4=0;
    [data getBytes:&h1 range:NSMakeRange(4, 1)];//第一个字节
    [data getBytes:&h2 range:NSMakeRange(5, 1)];//第二个字节
    [data getBytes:&h3 range:NSMakeRange(6, 1)];//第三个字节
    [data getBytes:&h4 range:NSMakeRange(7, 1)];//第四个字节
    
    int h = (h1<<24) + (h2<<16) + (h3<<8) + h4;
    
    NSLog(@"W:0x%08x H:0x%08x",w , h);
    NSLog(@"W:%d H:%d", w, h);
    return CGSizeMake((CGFloat)w /2.0, (CGFloat)h / 2.0);
}

- (IBAction)loadImage:(id)sender {

    NSURL *url = [NSURL URLWithString:kImgUrlStr];
    //request不能是普通的请求了（因为下边的statusCode== 206是部分数据），忽略了本地缓存，否则请求的时候就会把本地的给我们了所以此处用NSMutableURLRequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    NSURLResponse *response;
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
}

#pragma mark -NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    {
        NSLog(@"%s", __func__);
        if (httpResponse.statusCode == 200) {
            _imgData = [NSMutableData data];
            NSLog(@"ok");
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%s",__func__);
    [_imgData appendData:data];
    NSLog(@"%@",data);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s", __func__);
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.image = [UIImage imageWithData:_imgData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
