//
//  ViewController.m
//  02-数据持久化Demo
//
//  Created by qingyun on 15/12/24.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *arr;

@end

@implementation ViewController

- (void)viewDidLoad {
     self.title=@"数据持久化方法";
    [super viewDidLoad];
 _arr=@[@"CRAWViewController",@"OcRawViewController",@"PlistViewController",@"NsuserDefaultsViewController",@"ArchiverViewController",@"SqliteViewController"];
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma  mark tableview DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identfier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    cell.textLabel.text=_arr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *className=_arr[indexPath.row];
    UIViewController *controller=     [[NSClassFromString(className) alloc] init ];
    [self.navigationController pushViewController:controller animated:YES];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
