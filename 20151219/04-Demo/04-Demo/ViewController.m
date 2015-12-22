//
//  ViewController.m
//  04-Demo
//
//  Created by qingyun on 15/12/19.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)start:(id)sender {
    // 1. 创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.hnqingyun.demo", 0);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1 job");
        dispatch_async(queue, ^{
            NSLog(@"2 job");
        });
        NSLog(@"3 job");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"4 job");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"5 job");
    });
    
    NSLog(@"6 job");
}

@end
