//
//  OcRawViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "OcRawViewController.h"
#define fileName @"QY.txt"

@interface OcRawViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfContent;
@property(nonatomic,strong) NSString *filePath;

@end

@implementation OcRawViewController


-(NSString *)filePath{
    if (_filePath==NULL) {
      //1.获取沙盒路径
        NSString *direcPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask,YES)[0];
        
      //2创建文件夹
        //2.1获取文件管理器对象
        NSFileManager *fileManger=[NSFileManager defaultManager];
      
        //2.2创建文件夹
        //2.2.1 合并文件夹路径
        NSString *directroyPath=[direcPath stringByAppendingPathComponent:@"test"];
        //2.3 创建文件夹
        NSError *error;
        if (![fileManger createDirectoryAtPath:directroyPath withIntermediateDirectories:YES attributes:0 error:&error]) {
            NSLog(@"=======error===%@",error);
            return nil;
        };
        
       //3.创建文件
        //3.1 合并文件路径
        NSString *fPth=[directroyPath stringByAppendingPathComponent:fileName];
        
       //3.2 创建文件
        
        //3.3 判断文件是否存在
     if(![fileManger fileExistsAtPath:fPth]){
        if (![fileManger createFileAtPath:fPth contents:nil attributes:0]) {
            NSLog(@"=====文件创建失败");
            return nil;
        };
        _filePath=fPth;
        }else{
        _filePath=fPth;
      }
    }
    return _filePath;
}

-(BOOL)saveData{
    NSError *error;
    if (![_tfContent.text writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@"======失败");
        return NO;
    }
    return YES;
}

-(void)loadDataFromLocal{
    //1.读取本地文件 转成string
  // NSString *content=[NSString stringWithContentsOfFile:self.filePath usedEncoding:NSUTF8StringEncoding error:nil];
    
    NSString *content=[[NSString alloc] initWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
    
    //2.更新textFiled;

    _tfContent.text=content;
}


- (IBAction)touchSave:(id)sender {
    
    [self saveData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.读取本地数据
    [self loadDataFromLocal];
    
    // Do any additional setup after loading the view from its nib.
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
