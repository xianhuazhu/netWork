//
//  ViewController.m
//  JSONSerializationDemo
//
//  Created by qingyun on 15/12/18.
//  Copyright © 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "QYCityInfo.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *cityInfos;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSMutableArray *)cityInfos{
    if (_cityInfos == nil) {
        _cityInfos = [NSMutableArray array];
    }
    return _cityInfos;
}

- (IBAction)JSONParse:(id)sender {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    //反序列化
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSArray *objs;
    if ([obj isKindOfClass:[NSArray class]]) {
        objs = (NSArray *)obj;
    }else{
        NSLog(@"will not go here!");
    }
    
    NSLog(@"%@",objs);
    
    NSDictionary *firstObj = objs[0];
    NSLog(@"City:%@",firstObj[@"City"]);
    
//    for (NSDictionary *dict in objs) {
//        QYCityInfo *cityInfo = [QYCityInfo cityInfoWithDictionary:dict];
//        [self.cityInfos addObject:cityInfo];
//    }
    
    NSData *data2 = [NSJSONSerialization dataWithJSONObject:objs options:0 error:nil];
    NSLog(@"data2:%@",data2);
    NSString *dataStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
    NSLog(@"dataStr:%@",dataStr);
    
    //----------------------------- 叶子节点-------------------------------
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"leaf" withExtension:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfURL:url2];
    
    //反序列化
    NSError *error2;
    id obj2 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error2];
    if (error2) {
        NSLog(@"%@",error2);
        return;
    }
    
    NSLog(@"obj2:%@",obj2);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
