//
//  ArchiverViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ArchiverViewController.h"
#import "QYmode.h"
#define FileName @"archiver"

@interface ArchiverViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfAge;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (strong,nonatomic) NSString *filePath;

@end

@implementation ArchiverViewController


-(NSString*)filePath{
    
    if (_filePath) {
        return _filePath;
    }
    //libary 路径
    NSString *libaryPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    //2合并文件路径
    NSString *fpath=[libaryPath stringByAppendingPathComponent:FileName];
    if ([[NSFileManager defaultManager]fileExistsAtPath:fpath]) {
        _filePath=fpath;
        NSLog(@"%@",_filePath);
        return _filePath;
    }
    
    if ([[NSFileManager defaultManager] createFileAtPath:fpath contents:nil attributes:0]) {
        _filePath=fpath;
        return _filePath;
    }
    return nil;
}


-(void)loadDataFromLocal{
//1.读取本地nsdata
    QYmode *mode=[NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    if (mode) {
    //更新ui
        _tfName.text=mode.name;
        _tfAge.text=[NSString stringWithFormat:@"%ld",mode.age];
        _iconImage.image=mode.icon;
    }
}

-(BOOL)saveData{
  //1.将保存的值赋给mode对象
    QYmode *mode=[QYmode initName:_tfName.text fromAge:_tfAge.text.integerValue fromIcon:[UIImage imageNamed:@"1.jpg"]];
   //2.归档到本地
    if ([NSKeyedArchiver archiveRootObject:mode toFile:self.filePath]) {
        NSLog(@"=====序列化完成");
        return YES;
    }
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromLocal];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)touchSave:(id)sender {
   //开始归档 归档完毕后存储本地；
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
