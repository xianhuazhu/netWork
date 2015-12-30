//
//  ViewController.m
//  01-Fmdb作业
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "DBlistViewController.h"
@interface ViewController ()

@end

@implementation ViewController

-(void)clickNextResponder{
  //1.进入DBlistViewController
    DBlistViewController *dblist=[[DBlistViewController alloc] init];
    [self.navigationController pushViewController:dblist animated:YES];
    
}

- (void)viewDidLoad {
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"next" forState:UIControlStateNormal];
    btn.frame=CGRectMake(100, 200, 150, 40);
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn addTarget:self action:@selector(clickNextResponder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [super viewDidLoad];
    self.title=@"首页";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
