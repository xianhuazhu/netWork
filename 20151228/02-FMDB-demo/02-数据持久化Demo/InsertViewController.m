//
//  InsertViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "InsertViewController.h"
#import "QYStudent.h"
#import "DBFileHandle.h"
#import "DBFileFMDBHandel.h"
@interface InsertViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfID;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfAge;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

@implementation InsertViewController
-(void)insertValue{
    QYStudent *student=[QYStudent initWithID:_tfID.text.intValue Name:_tfName.text withAge:_tfAge.text.intValue withIcon:_iconImage.image];
    
#if 0
    //获取单例对象
    DBFileHandle *handel=[DBFileHandle shareHandel];
    //执行插入数据操作
    if ( [handel insertIntoData:student]) {
        NSLog(@"===========》数据插入成功");
    };
#endif
    //fmdb
    //1.获取单例对象
    DBFileFMDBHandel *handel=[DBFileFMDBHandel shareHandel];
    if ([handel insertIntoData:student]) {
        NSLog(@"=======成功");
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *baritem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertValue)];
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
