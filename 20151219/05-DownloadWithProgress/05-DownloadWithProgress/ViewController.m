//
//  ViewController.m
//  05-DownloadWithProgress
//
//  Created by qingyun on 15/12/19.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"

#define kImgURLStr @"http://cdn.tutsplus.com/mobile/uploads/2013/12/sample.jpg"

@interface ViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)downloadImage:(id)sender {
    _progressView.hidden = NO;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:kImgURLStr]];
    
    [downloadTask resume];
}


#pragma mark - session delegate
/**
 * 下载完成之后的回调
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSData *imgData = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:imgData];
    
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"主线程!");
    } else {
        NSLog(@"对等线程!");
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.image = image;
        _progressView.hidden = YES;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    dispatch_async(dispatch_get_main_queue(), ^{
        double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        _progressView.progress = (float)progress;
    });
}

@end
