//
//  ViewController.m
//  06-DownloadWithCancelAndResume
//
//  Created by qingyun on 15/12/19.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"

#define kImgURLStr  @"http://cdn.tutsplus.com/mobile/uploads/2014/01/5a3f1-sample.jpg"

@interface ViewController () <NSURLSessionDownloadDelegate, NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation ViewController

- (NSURLSession *)session {
    if (_session == nil) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)download:(id)sender {
  
    self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:kImgURLStr]];
    
    [self.downloadTask resume];

    _downloadBtn.enabled = NO;
    _progressView.hidden = NO;
    _cancelBtn.hidden = NO;
}

#pragma mark - session delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _imageView.image = image;
        _progressView.hidden = YES;
        _cancelBtn.hidden = YES;
        _resumeBtn.hidden = YES;
        _downloadBtn.enabled = YES;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = (float)progress;
    });
}

- (IBAction)cancel:(id)sender {
    if (self.downloadTask == nil) {
        return;
    }
    
    _cancelBtn.hidden = YES;
    
    // 取消下载任务
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
        self.downloadTask = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resumeBtn.hidden = NO;
        });
    }];
}

- (IBAction)resume:(id)sender {
    if (self.resumeData == nil) {
        return;
    }
    
    _resumeBtn.hidden = YES;
    
    // 继续下载
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
    
    _cancelBtn.hidden = NO;
}


@end
