//
//  HouseInfoCell.m
//  01-租房
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "HouseInfoCell.h"

@implementation HouseInfoCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDic:(NSDictionary *)dic{
   //进行赋值操作
    /*
     {
     camera = N;
     cid = FI0000001006;
     community = "\U6ec7\U6c60\U536b\U57ce\U84dd\U57df\U6674\U5929";
     housetype = "3\U5ba42\U5385";
     iconurl = "Photos/aspics/pic0016/1307201427270E7069E60614F9977672.jpg";
     nid = "WCQE000138  ";
     price = 2300;
     simpleadd = "\U6ec7\U6c60\U5ea6\U5047\U533a\U7247\U533a";
     temprownumber = 1;
     title = "\U6700\U4fbf\U5b9c\U7684\U79df\U623f";
     },
     */
    self.titleLabel.text=dic[@"title"];
    self.areaLabel.text=dic[@"community"];
    self.quLabel.text=dic[@"simpleadd"];
    self.typeLabel.text=dic[@"housetype"];
    NSInteger price=[dic[@"price"] integerValue];
    self.priceLabel.text=[NSString stringWithFormat:@"%ld元",price];
    _dic=dic;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
