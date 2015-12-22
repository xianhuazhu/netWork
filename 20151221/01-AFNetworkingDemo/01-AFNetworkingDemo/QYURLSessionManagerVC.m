//
//  QYSessionManagerVC.m
//  01-AFNetworkingDemo
//
//  Created by qingyun on 15/12/21.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "QYURLSessionManagerVC.h"
#import <AFURLSessionManager.h>
#import <AFURLRequestSerialization.h>

#define kSongURLStr @"http://tingge.5nd.com/20060919//2014/2014-8-20/63916/1.Mp3"

#define MTWeak(var, weakVar) __weak __typeof(&*var) weakVar = var

@interface QYURLSessionManagerVC ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *multiPartRequestProgress;
@property (nonatomic, strong) AFURLSessionManager *manager;
@end

@implementation QYURLSessionManagerVC


- (AFURLSessionManager *)manager {
    if (_manager == nil) {
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _manager.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        MTWeak(self, weakSelf);
        [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [weakSelf handleNetworkWithState:status];
        }];
        [_manager.reachabilityManager startMonitoring];
    }
    return _manager;
}

- (void)handleNetworkWithState:(AFNetworkReachabilityStatus)state {
    switch (state) {
        case AFNetworkReachabilityStatusUnknown: {
            NSLog(@"网络未知!");
            break;
        }
        case AFNetworkReachabilityStatusNotReachable: {
            NSLog(@"网络不可达!");
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            NSLog(@"2G/3G/4G!");
            
//           NSURLSessionDownloadTask *downloadTask = self.manager.downloadTasks[0];
//            [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//                
//            }];
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            NSLog(@"Wi-Fi!");
//            [self.manager downloadTaskWithResumeData:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//
//            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//
//            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)download:(id)sender {
    NSLog(@"%@", NSHomeDirectory());
    // 1. 创建manager
    
    // 2. 创建下载任务
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kSongURLStr]];
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 关于进度的处理 (在主线程更新进度条)
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress = downloadProgress.fractionCompleted;
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 返回将数据下载到哪里(URL)
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:response.suggestedFilename];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    // 3. 启动下载任务
    [downloadTask resume];
}

- (IBAction)uploadImage:(id)sender {
    
    // 1. 创建Manager
    // 2. 创建上传任务
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://afnetworking.sinaapp.com/upload2server.json"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://afnetworking.sinaapp.com/upload2server.json"]];
    request.HTTPMethod = @"POST";
    NSURL *fileURL = [NSURL fileURLWithPath:@"/Users/qingyun/Desktop/1.jpg"];
    NSURLSessionUploadTask *uploadTask = [self.manager uploadTaskWithRequest:request fromFile:fileURL progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _uploadProgressView.progress = uploadProgress.fractionCompleted;
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"上传失败! - (%@)", error);
            return ;
        }
        NSLog(@"%@", responseObject);
    }];
    
    // 3. 开始上传
    [uploadTask resume];
}

- (IBAction)multiPartRequest:(id)sender {
    
    // 1. 用请求序列化器来构建请求
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://afnetworking.sinaapp.com/upload2server.json" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 构建多部分请求，往body中，追加要上传的文件
        NSURL *file1URL = [NSURL fileURLWithPath:@"/Users/qingyun/Desktop/1.jpg"];
        NSURL *file2URL = [NSURL fileURLWithPath:@"/Users/qingyun/Desktop/222.jpg"];
        [formData appendPartWithFileURL:file1URL name:@"image" fileName:@"xxx.jpg" mimeType:@"image/jpeg" error:nil];
        [formData appendPartWithFileURL:file2URL name:@"image" fileName:@"yyy.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    // 2. 创建manager
    // 3. 创建多部分请求任务
    NSURLSessionUploadTask *uploadTask = [self.manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
        _multiPartRequestProgress.progress = uploadProgress.fractionCompleted;
        });

    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        
        NSLog(@"%@", responseObject);
    }];
    
    // 4. 开始上传任务
    [uploadTask resume];
    
}


- (IBAction)dataTask:(id)sender {
    
    // 1. 创建manager
    
    
    // 2. 创建dataTask
//    NSString *urlStr = @"http://afnetworking.sinaapp.com/request_post_body_http.json";
    NSString *urlStr = @"http://afnetworking.sinaapp.com/request_post_body_json.json";
    NSDictionary *parameters = @{@"foo":@"bar"};
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:parameters error:nil];
//    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:parameters error:nil];

    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", responseObject);
    }];
    
    // 3. 启动
    [dataTask resume];
}

@end
