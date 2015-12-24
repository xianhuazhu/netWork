//
//  CRAWViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "CRAWViewController.h"
#define  fileName @"test.txt"

@interface CRAWViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfContent;

@property (strong,nonatomic) NSString *filePath;
@end

@implementation CRAWViewController

-(NSString *)filePath{
    
    if (_filePath==nil) {

   //1.获取沙盒路径 libary
    NSString *libarPath=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
   //2.拼接路径
    _filePath=[libarPath stringByAppendingPathComponent:fileName];
    }
    return _filePath;
}


-(void)loadDataFromLocal{
    
    //1.打开文件
    FILE *fp=fopen([self.filePath UTF8String],"r");
    if (fp==NULL) {
        NSLog(@"文件打开失败");
        return;
    }
    //2.磁盘上的数据读到内存
      //2.1声明一个数组
      char buffer[1024]={0};
      //2.2算文件长度
        //2.2.1 将文件指针指向一个位置 尾部
         fseek(fp, 0, SEEK_END);
        //2.2.2 文件长度
       long len=ftell(fp);
      //2.3将文件指针指向开始位置
       rewind(fp);
    
    //3.读取操作
    size_t count=fread(buffer,len,1, fp);
    if (count>0) {
        NSLog(@"读取成功");
    }
    //4关闭文件；
    fclose(fp);
    //内容赋值给tf
    _tfContent.text=[NSString stringWithUTF8String:buffer];

}


-(BOOL)saveData{
    
    //1FILE  打开文件
    FILE *fp=fopen([self.filePath UTF8String],"w+");
    if (fp==NULL) {
        NSLog(@"打开文件失败");
        return NO;
    }

    NSString *content=_tfContent.text;
    int leng=(int)content.length;
    
    
    //2写入操作
    size_t count=fwrite([content UTF8String], leng, 1,fp);
    if (count>0) {
        NSLog(@"写入成功");
    }
    
    //3.关闭文件
    fclose(fp);

    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromLocal];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)TouchSave:(id)sender {
    
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
