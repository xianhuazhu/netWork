//
//  DBlistViewController.m
//  01-Fmdb作业
//
//  Created by qingyun on 15/12/29.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "DBlistViewController.h"
#import "Header.h"
#import "QYstudent.h"
#import "DBFileHandel.h"

@interface DBlistViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property(nonatomic,strong)UITableView *myTable;
@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)UIRefreshControl *refreshControl;

@end

@implementation DBlistViewController


-(void)addContents{
 //添加

}

-(void)changValue:(UIRefreshControl *)control{
    if (control.isRefreshing) {
        control.attributedTitle=[[NSAttributedString alloc] initWithString:@"正在加载..."];
        //执行网络请求
        [self loadDataFromNet];
    }else{
       
    }
}




-(void)addsubView{
 //1.添加tableview
    _myTable=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myTable.delegate=self;
    _myTable.dataSource=self;
    [self.view addSubview:_myTable];
    
 //2.添加 “添加”按钮
    UIBarButtonItem *addItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContents)];
    self.navigationItem.rightBarButtonItem=addItem;

//3.添加下来刷新的控件
    _refreshControl=[[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle=[[NSAttributedString alloc] initWithString:@"下拉刷新..."];
    [_refreshControl addTarget:self action:@selector(changValue:) forControlEvents:UIControlEventValueChanged];
   //添加tableview
    [_myTable addSubview:_refreshControl];
    
//3.添加一个searbar
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.delegate=self;
    _myTable.tableHeaderView=searchBar;
}

#pragma searchBardelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
     //显示取消按钮
    searchBar.showsCancelButton=YES;
    return YES;
}

//点击搜索按钮的时候调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=NO;
    //取消第一响应
    [searchBar resignFirstResponder];
    
    //调用搜索
    
    NSMutableArray *tempArr=[[DBFileHandel shareHandel] selectFromDataWithName:searchBar.text];
    if (tempArr) {
        self.dataArr=tempArr;
        //刷新列表
        [_myTable reloadData];
    }
    
    
}
//点击取消按钮时候调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
      searchBar.showsCancelButton=NO;
      //取消第一响应
     [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"=====%@",searchBar.text);
    if (searchBar.text.length==0) {
        //加载本地数据
        NSMutableArray *tempARR=[[DBFileHandel shareHandel] selectAllData];
        if (tempARR) {
            self.dataArr=tempARR;
        }
        [_myTable reloadData];
    }else{
        NSMutableArray *tempArr=[[DBFileHandel shareHandel] selectFromDataWithName:searchBar.text];
        if (tempArr) {
            self.dataArr=tempArr;
            //刷新列表
            [_myTable reloadData];
        }
    }
}


#pragma mark tableView DataSource 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //取出模型
        QYstudent *mode=self.dataArr[indexPath.row];
        //1.删除数据源 内存
        [self.dataArr removeObjectAtIndex:indexPath.row];
        //2.删除表格
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //3.删除数据库的数据
        if ([[DBFileHandel shareHandel] deleteDataFromStuid:mode.stu_id]) {
            NSLog(@"=====删除单条数据成功");
        }
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identfier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    QYstudent *mode=self.dataArr[indexPath.row];
    cell.textLabel.text=mode.name;

    return cell;
}

-(void)endRefresh{
    _refreshControl.attributedTitle=[[NSAttributedString alloc] initWithString:@"下拉刷新..."];
}


#pragma mark 网络请求数据
-(void)loadDataFromNet{
    //1.进行网络请求
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    //设置请求参数
    NSDictionary *dic=@{@"person_type":@"student"};
    
    [manager POST:URLPATH parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //请求成功
         NSLog(@"=======%@",responseObject);
         NSArray *tempArr=responseObject[@"data"];
         self.dataArr=[NSMutableArray array];
        
         for (NSDictionary *dic in tempArr) {
            QYstudent *student=[[QYstudent alloc] initWithDic:dic];
            [self.dataArr addObject:student];
         }
        
       //2.刷新ui
        [_myTable reloadData];
        
        //如果已经ISSAVE设置过值，说明当前请求是下拉刷新请求，
        //我们需要清空当前列表，重写缓存数据
        if ([[NSUserDefaults standardUserDefaults]objectForKey:ISSAVE]) {
            //说明是下拉过来数据，删除本地已经缓存过的数据
            //删除表的上次请求的数据
            if ([[DBFileHandel shareHandel] deleteDataAll]) {
                NSLog(@"======删除完成");
            }
            
            [_refreshControl endRefreshing];
            [self performSelector:@selector(endRefresh) withObject:nil afterDelay:1];
        }
        
        
       //2.1 缓存数据到数据库
         for (QYstudent *mode in self.dataArr) {
           //存到数据库
            [[DBFileHandel shareHandel] insertIntoDataFrom:mode];
        }
        //3.设置已经保存过
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:ISSAVE];
        
        //持久化同步
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
      //请求失败
       
         [_refreshControl endRefreshing];
          [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.判断本地是否有缓存数据
    
      NSString *issave=[[NSUserDefaults standardUserDefaults] objectForKey:ISSAVE];
      if(issave){
     //读取本地缓存
        NSMutableArray *tempARR=[[DBFileHandel shareHandel] selectAllData];
        if (tempARR) {
            self.dataArr=tempARR;
        }
    }else{
     //进行网络请求 异步
        [self loadDataFromNet];
    }
    //添加视图
    [self addsubView];
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
