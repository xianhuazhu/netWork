//
//  QYHttpSessionManagerVC.m
//  01-AFNetworkingDemo
//
//  Created by qingyun on 15/12/21.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "QYHttpSessionManagerVC.h"
#import <AFHTTPSessionManager.h>

@interface QYHttpSessionManagerVC ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation QYHttpSessionManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (IBAction)get:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{@"foo":@"bar"};
    [manager GET:@"http://afnetworking.sinaapp.com/request_get.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
}

- (IBAction)post:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer;
    
//    NSString *urlStr = @"http://afnetworking.sinaapp.com/request_post_body_http.json";
    NSString *urlStr = @"http://afnetworking.sinaapp.com/request_post_body_json.json";
    
    NSDictionary *parameters = @{@"foo":@"bar"};
    
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (IBAction)multiPartRequest:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:@"http://afnetworking.sinaapp.com/upload2server.json" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *file1URL = [NSURL fileURLWithPath:@"/Users/qingyun/Desktop/222.jpg"];
        [formData appendPartWithFileURL:file1URL name:@"image" fileName:@"suibian.jpg" mimeType:@"image/jpeg" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _progressView.progress = uploadProgress.fractionCompleted;
        });

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
@end
