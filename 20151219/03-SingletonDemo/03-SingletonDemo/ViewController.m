//
//  ViewController.m
//  03-SingletonDemo
//
//  Created by qingyun on 15/12/19.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "QYBookManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)getSharedManager:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        QYBookManager *manager1 = [QYBookManager sharedManager];
        NSLog(@"manager1:%@", manager1);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        QYBookManager *manager2 = [QYBookManager sharedManager];
        NSLog(@"manager2:%@", manager2);
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        QYBookManager *manager3 = [QYBookManager sharedManager];
        NSLog(@"manager3:%@", manager3);
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        QYBookManager *manager4 = [QYBookManager sharedManager];
        NSLog(@"manager4:%@", manager4);
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        QYBookManager *manager5 = [QYBookManager sharedManager];
        NSLog(@"manager5:%@", manager5);
    });
    

}


@end
