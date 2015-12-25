//
//  ViewController.m
//  03-settingsBundle
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UISwitch *swithVIew;

@end

@implementation ViewController

-(void)loadDataFromLocal{
    //读取userDefaults文件
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _tfName.text=[defaults objectForKey:@"name_preference"];
    _swithVIew.on=[defaults boolForKey:@"enabled_preference"];
    _slider.value=[defaults floatForKey:@"slider_preference"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromLocal];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
