//
//  SubOrderCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parcel.h"  //

@interface SubOrderCell : UITableViewCell

//  attrs
@property (nonatomic,retain) Parcel *parcel ;// 子订单

//  views


@property (weak, nonatomic) IBOutlet UILabel *lb_seeShip;//查看物流

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_products;//商品s

@property (weak, nonatomic) IBOutlet UILabel *lb_allNums;//共几件





@end
