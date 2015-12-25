//
//  PlistViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "PlistViewController.h"
#define fileName @"QY.plist"


@interface PlistViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchSex;
@property (weak, nonatomic) IBOutlet UITextField *tfAge;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UISlider *silder;


@property(nonatomic,strong) NSString *filePath;

@end

@implementation PlistViewController

//文件路径
-(NSString *)filePath{
    
    if(!_filePath){
  //1.获取libary 目录
 NSString*libaryPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    
  //2.创建文件夹
     //创建文件管理器对象
        NSFileManager *fileManager=[NSFileManager defaultManager];
        
    //2.1合并文件夹路径
     NSString *directoryPath=[libaryPath stringByAppendingPathComponent:@"Plist"];
    //2.2创建文件夹
     NSError *error;
     if (![fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:0 error:&error]) {
            NSLog(@"====文件夹创建失败==%@",error);
            return nil;
     }
  //3.创建文件
   //3.1合并文件路径
    NSString *fPath=[directoryPath stringByAppendingPathComponent:fileName];
    //3.2判断文件是否存在
        if (![fileManager fileExistsAtPath:fPath]) {
           //创建文件
            if(![fileManager createFileAtPath:fPath contents:nil attributes:0]){
                NSLog(@"======文件创建失败");
                return nil;
            }
        }
        _filePath=fPath;
    }
    return _filePath;
}


-(BOOL)saveData{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:@(_switchSex.on) forKey:@"sex"];
    [dic setObject:_tfName.text forKey:@"name"];
    [dic setObject:@(_tfAge.text.integerValue) forKey:@"age"];
    [dic setObject:@(_silder.value) forKey:@"column"];
    //将dic写入plist文件
    if (![dic writeToFile:self.filePath atomically:YES]) {
        NSLog(@"=======写入失败");
        return NO;
    } ;
    return YES;
}

-(void)loadDataFromLocal{
    //读取plist文件 =====字典
    NSDictionary *dic=[[NSDictionary alloc] initWithContentsOfFile:self.filePath];
    //更新ui
    _switchSex.on=[dic[@"sex"] boolValue];
    _tfAge.text=[dic[@"age"] stringValue];
    _tfName.text=dic[@"name"];
    _silder.value=[dic[@"column"] floatValue];
}


- (IBAction)touchSave:(id)sender {
    //保存数据
    [self saveData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //读取数据
    [self loadDataFromLocal];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
