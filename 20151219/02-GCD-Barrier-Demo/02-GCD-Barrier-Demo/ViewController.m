//
//  ViewController.m
//  02-GCD-Barrier-Demo
//
//  Created by qingyun on 15/12/19.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"
@class QYPhonto;
@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) dispatch_queue_t photoQueue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

/**
 * writer
 */
- (void)addPhoto:(QYPhonto *)photo {
    if (photo) {
        dispatch_barrier_async(self.photoQueue, ^{
            [_photos addObject:photo];
        });
    }
}

/**
 * reader
 */
- (NSArray *)photos {
    __block NSArray *array;
    dispatch_sync(self.photoQueue, ^{
        array = [NSArray arrayWithArray:_photos];
    });

    return array;
}

- (IBAction)barrierDemo:(id)sender {
    // 1. 创建一个自定义的并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.hnqingyun.barrier", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"1 job");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"xxx job");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"2 job");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3 job");
    });
    
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"4 job");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"5 job");
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"6 job");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"7 job");
    });
}


@end
