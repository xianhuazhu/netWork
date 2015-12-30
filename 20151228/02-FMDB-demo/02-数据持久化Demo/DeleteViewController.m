//
//  DeleteViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "DeleteViewController.h"
#import "DBFileHandle.h"
#import "DBFileFMDBHandel.h"

@interface DeleteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfId;

@end

@implementation DeleteViewController

-(void)deleteValue{
#if 0
 //1.单例对象
    DBFileHandle *dbHandel=[DBFileHandle shareHandel];
 //2.执行删除操作
    if ([dbHandel deleteDataFromId:_tfId.text.intValue]) {
        NSLog(@"====成功删除Id==%d",_tfId.text.intValue);
    }
#else
    //fmdb
    //1.获取单例对象
    DBFileFMDBHandel *dbHandel=[DBFileFMDBHandel shareHandel];
    if ([dbHandel deleteDataFromId:_tfId.text.intValue]) {
        NSLog(@"======成功delete");
    }
#endif
}


- (void)viewDidLoad {
    
    //1.删除item
    UIBarButtonItem *deleteItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteValue)];
    self.navigationItem.rightBarButtonItem=deleteItem;
    
    [super viewDidLoad];
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
