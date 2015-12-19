//
//  ViewController.m
//  NSThreadDemo
//
//  Created by qingyun on 15/12/18.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

#define kImgUrlStr @"http://d.hiphotos.baidu.com/image/pic/item/472309f79052982249530eecd6ca7bcb0a46d4b8.jpg"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)updateImageView:(UIImage *)image
{
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"主线程！-%s", __FUNCTION__);
    }else{
        NSLog(@"对等线程！-%s",__FUNCTION__);
    }
    _imageView.image = image;
    sleep(10);
}

- (void)fetchImage:(NSURL *)url{
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"主线程！- %s",__FUNCTION__);
    }else{
        NSLog(@"对等线程！-%s",__FUNCTION__);
    }
    
    NSLog(@"%@",[NSThread currentThread].name);
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    sleep(5);
    UIImage *image = [UIImage imageWithData:data];
    
    [self performSelectorOnMainThread:@selector(updateImageView:) withObject:image waitUntilDone:YES];
    NSLog(@"hacking here!");
}

- (IBAction)loadImageView:(id)sender {
    NSURL *url = [NSURL URLWithString:kImgUrlStr];
    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *sessionData = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if ([[NSThread currentThread] isMainThread]) {
//            NSLog(@"主线程");
//        }else{
//            NSLog(@"对等线程！");
//        }
//        UIImage *image = [UIImage imageWithData:data];
//        _imageView.image = image;
//    }];
//    [sessionData resume];
    
    if ([[NSThread currentThread] isMainThread]) {
        NSLog(@"主线程！-%s",__FUNCTION__);
    }else{
        NSLog(@"对等线程！-%s",__FUNCTION__);
    }
    
//    [NSThread detachNewThreadSelector:@selector(fetchImage:) toTarget:self withObject:url];
//    [self performSelectorInBackground:@selector(fetchImage:) withObject:url];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(fetchImage:) object:url];
    thread.name = @"zahngsan";
    [thread start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
