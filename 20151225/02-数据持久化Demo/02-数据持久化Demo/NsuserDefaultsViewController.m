//
//  NsuserDefaultsViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "NsuserDefaultsViewController.h"

@interface NsuserDefaultsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchSex;
@property (weak, nonatomic) IBOutlet UITextField *tfAge;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation NsuserDefaultsViewController


-(BOOL)saveData{
  //1.获取userDefaults 对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
 //2设置值
    [defaults setBool:_switchSex.on forKey:@"sex"];
    [defaults setInteger:_tfAge.text.integerValue forKey:@"age"];
    [defaults setObject:_tfName.text forKey:@"name"];
    [defaults setFloat:_slider.value forKey:@"column"];
  //3.同步到plist文件
    
    [defaults synchronize];
    return YES;
}

-(void)loadDataFromLocal{
    //1.取出数据 刷新ui
      //1.1获取NsuserDefaults对象
    NSUserDefaults *defaluts=[NSUserDefaults standardUserDefaults];
    //2. 更新ui
    _switchSex.on=[defaluts boolForKey:@"sex"];
    _tfAge.text=[NSString stringWithFormat:@"%ld",[defaluts integerForKey:@"age"]];
    _tfName.text=[defaluts objectForKey:@"name"];
    _slider.value=[defaluts floatForKey:@"column"];
}


-(void)singTapAction:(id)sender{
    [_tfName resignFirstResponder];
    [_tfAge resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singTapAction:)]];
    
    //读取本地缓存
    [self loadDataFromLocal];
    
    
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)touchSave:(id)sender {
    [self saveData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
