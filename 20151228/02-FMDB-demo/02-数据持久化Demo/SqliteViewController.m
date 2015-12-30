//
//  SqliteViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "SqliteViewController.h"

@interface SqliteViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation SqliteViewController

- (void)viewDidLoad {
    self.title=@"数据库操作";
    
    _dataArr=@[@"插入数据",@"修改数据",@"删除数据",@"查询数据",@"InsertViewController",@"UpdateViewController",@"DeleteViewController",@"SelectViewController"];
    
    UITableView *myTable=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    myTable.delegate=self;
    myTable.dataSource=self;
    [self.view addSubview:myTable];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count/2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identfier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    cell.textLabel.text=_dataArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIViewController *controller=[NSClassFromString(_dataArr[indexPath.row+4]) new];
    
    [self.navigationController pushViewController:controller animated:YES];
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
