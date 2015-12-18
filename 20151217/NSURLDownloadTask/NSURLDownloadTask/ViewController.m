//
//  ViewController.m
//  NSURLDownloadTask
//
//  Created by qingyun on 15/12/17.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

#define kSongURLStr @"http://down.5nd.com/a/down.ashx?t=1&xcode=0b28de1ff927eb3c16eea3c14442219c&sid=602471"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:kSongURLStr] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@",error);
            return ;
        }
        
        NSLog(@"下载成功！");
        NSLog(@"location:%@",location);
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *dstPath = [@"/Users/qingyun/Desktop/xxx.mp3" stringByExpandingTildeInPath];
        NSLog(@"%@", dstPath);
        NSURL *toURL = [NSURL fileURLWithPath:dstPath];
        [manager copyItemAtURL:location toURL:toURL error:nil];
    }];
    
    [downloadTask resume];
}

- (IBAction)downLoadMusic:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
