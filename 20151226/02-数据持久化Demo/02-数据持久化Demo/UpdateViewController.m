//
//  UpdateViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "UpdateViewController.h"
#import "QYStudent.h"
#import "DBFileHandle.h"
@interface UpdateViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfID;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfAge;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

@implementation UpdateViewController


-(void)insertValue{
    QYStudent *mode=[QYStudent initWithID:_tfID.text.intValue Name:_tfName.text withAge:_tfAge.text.intValue withIcon:_iconImage.image];
    //1获取数据库操作类的单例对象
    DBFileHandle *handel=[DBFileHandle shareHandel];
    //2更新操作
    if ([handel updateDataFromMode:mode]) {
        NSLog(@"========更新数据成功");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //修改按钮
    UIBarButtonItem *baritem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(insertValue)];
    self.navigationItem.rightBarButtonItem=baritem;
    
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
