//
//  ViewController.m
//  01-GCDDemo
//
//  Created by qingyun on 15/12/19.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)fetchDataFromSearver:(id)sender {
    
    NSDate *startDate = [NSDate date];
    

    __block NSString *string;
    __block NSString *result1;
    __block NSString *result2;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1. 模拟从网络请求数据
        string = [self fetchData];
        
        dispatch_group_t group = dispatch_group_create();

        // 2. 模拟第一次对数据的处理
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            result1 = [self firstHandling:string];
        });

        // 3. 模拟第二次数据的处理
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            result2 = [self secHandling:string];
        });
        
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *result;
            
            result = [NSString stringWithFormat:@"%@\r%@", result1, result2];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 4. 汇总结果，并更新UI
                
                _textView.text = result;
                
                NSDate *endDate = [NSDate date];
                
                NSTimeInterval duration = [endDate timeIntervalSinceDate:startDate];
                NSLog(@"duration:%.2f", duration);
            });
        });

    });
}

- (NSString *)fetchData {
    [NSThread sleepForTimeInterval:3];
    return @"This is a mock for fetching data from the server.";
}

- (NSString *)firstHandling:(NSString *)string {
    // 1. 将小写都变成大写
    [NSThread sleepForTimeInterval:3];
    return [string uppercaseString];
}

- (NSString *)secHandling:(NSString *)string {
    // 2. 将o变成x
    [NSThread sleepForTimeInterval:2];
    return  [string stringByReplacingOccurrencesOfString:@"o" withString:@"x"];
}

@end
