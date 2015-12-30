//
//  SelectViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "SelectViewController.h"
#import "QYStudent.h"
#import "DBFileHandle.h"


@interface SelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfID;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
//数据源
@property (strong,nonatomic)NSMutableArray *dataArr;
@end

@implementation SelectViewController
- (IBAction)selectValueFromId:(id)sender {
    DBFileHandle  *dbHandel=[DBFileHandle shareHandel];
    //查询Id字段
    NSMutableArray *tempARR=[dbHandel selectValueFromId:_tfID.text.intValue];
    if (tempARR) {
        self.dataArr=tempARR;
        //刷新tableVIew；
        [_myTable reloadData];
    }
}

-(void)selectValueAll{
    DBFileHandle *dbHandle=[DBFileHandle shareHandel];
    
    //查询所以的值
    NSMutableArray *tempArr=[dbHandle selectValueAll];
    if (tempArr) {
        self.dataArr=tempArr;
       //刷新tableview
        [_myTable reloadData];
    }
}

- (void)viewDidLoad {
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(selectValueAll)];
    self.navigationItem.rightBarButtonItem=item;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark tableDataSource delegate;

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *identfier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identfier];
    }
    QYStudent *mode=_dataArr[indexPath.row];
    if (mode) {
      //赋值
        cell.imageView.image=mode.icon;
      //name
        cell.textLabel.text=[NSString stringWithFormat:@"姓名:%@",mode.name];
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"学号:%d     年龄:%d",mode.ID,mode.age];
    }
    
    
    return cell;
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
