//
//  ViewController.m
//  01-租房
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "HouseInfoCell.h"
#import "AFNetworking.h"
#import "Header.h"
#import "FileHandle.h"




@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *myTable;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end
@implementation ViewController

#pragma mark requet
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

//请求租房列表
-(void)requestHouseList{
//http://www.fungpu.com/houseapp/apprq.do?HEAD_INFO={"commandcode":108,"REQUEST_BODY":{"city":"昆明","desc":"0" ,"p":1,"lat":24.973079315636,"lng":102.69840055824}}
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSString *value=@"{\"commandcode\":108,\"REQUEST_BODY\":{\"city\":\"昆明\",\"desc\":\"0\" ,\"p\":1,\"lat\":24.973079315636,\"lng\":102.69840055824}}";
    //设置响应序列化
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    //设置参数
    NSDictionary *prameter=@{@"HEAD_INFO":value};
    [manager GET:baseURl parameters:prameter progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        NSLog(@"======%@",responseObject);
      //json解析
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"====%@",dic);
        NSArray *temp=dic[@"RESPONSE_BODY"][@"list"];
      /****
       //缓存
       将租房列表存在本地，用于下次打开页面，直接从本地获取
      *****/
        [[FileHandle shareHandel]saveLocalValue:temp saveName:HOUSEINFOFILE];
        //移除掉数据源
        [self.dataArr removeAllObjects];
        
        //给数据源赋值
        [self.dataArr addObjectsFromArray:temp];
        //刷新Ui
        [_myTable reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"======%@",error);
    }];
}
//加载网络图片
-(void)loadImageFromNetWork:(NSString*)Url indexPath:(HouseInfoCell *)cell{
    
 //1读取本地转存http://www.fungpu.com/houseapp/Photos/201501/e646b1e498ed4d8781076403eea5bb65.jpg
    //1.1 截取字符串获取图片名称
    NSArray *arr=[Url componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/."]];
    NSLog(@"====%@",arr);
    //1.2 读取本地图片
    //1.3 获取图片名称
    NSString*imagName;
    if (arr.count>0) {
      imagName=arr[arr.count-2];
    //1.4获取到本地图片
       UIImage * image=[[FileHandle shareHandel]loadImageFormLocal:imagName];
        if(image){
        //更新ui
//            HouseInfoCell *cell=[self.myTable cellForRowAtIndexPath:path];
            if (cell) {
                cell.iconImage.image=image;
            }
            return;
        }
    }else{
        //空的url 无效的url
        return;
    }
    
    
    
 //2.网络请求

  //2.1.mangager
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
  //2.2执行网络请求
    //2.1 设置响应序列化
    manager.responseSerializer=[AFImageResponseSerializer serializer];
    //2.2执行下载
    [manager GET:Url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"========%@",responseObject);
        //成功 更新ui
       //1.获取cell
//            HouseInfoCell *cell=[_myTable cellForRowAtIndexPath:path];
            cell.iconImage.image=responseObject;
   
        //2.把图片存在本地
        [[FileHandle shareHandel] savelocalImage:responseObject saveName:imagName];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"===error==%@",error);
    }];

}


- (void)viewDidLoad {
    /**
      从本地读取缓存
     ***/
    
    NSMutableArray *data=[[FileHandle shareHandel] loadFromLocal:HOUSEINFOFILE];
    if (data) {
        self.dataArr=data;
    }
    
    [super viewDidLoad];
    _myTable=[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myTable.delegate=self;
    _myTable.dataSource=self;
    _myTable.rowHeight=100;
    [self.view addSubview:_myTable];
    //网络请求
    
    [self requestHouseList];
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"HouseInfoCell" owner:self options:nil][0];
    }
    cell.dic=self.dataArr[indexPath.row];
    //1.拼接图片的url
    NSString *imageUrl=[ImageURL stringByAppendingPathComponent:cell.dic[@"iconurl"]];
    //2加载图片
    [self loadImageFromNetWork:imageUrl indexPath:cell];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
