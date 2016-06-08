//
//  BuyCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCell : UITableViewCell

//  properties
@property (nonatomic)       BOOL     isShowDecline ;    //是否显示直降30%的图片,sethidden
@property (nonatomic)       BOOL     isTimeOut ;        //是否已过期,图片文字变换


//  views
@property (weak, nonatomic) IBOutlet UIView *bgView;//底背景图

@property (weak, nonatomic) IBOutlet UIImageView *img_goods;//商品图片

@property (weak, nonatomic) IBOutlet UIImageView *img_down;//直降背景图

@property (weak, nonatomic) IBOutlet UILabel *lb_down_percent;//直降百分比

@property (weak, nonatomic) IBOutlet UILabel *lb_title;//标题

@property (weak, nonatomic) IBOutlet UILabel *lb_yesterday;//昨日价

@property (weak, nonatomic) IBOutlet UILabel *lb_salePrice;//抢购价

@property (weak, nonatomic) IBOutlet UIImageView *img_comeFrom;//来自图片


@end
