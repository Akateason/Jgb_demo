//
//  SelectGoodCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"
#import "SalesProduct.h"

@interface SelectGoodCell : UITableViewCell

@property (nonatomic,retain) Goods                  *myGood     ;


@property (weak, nonatomic) IBOutlet UIImageView    *goodImgView;
@property (weak, nonatomic) IBOutlet UILabel        *lb_title1; //title

@property (weak, nonatomic) IBOutlet UILabel *lb_rmbPrice;  // rmb 价格 - 区间
@property (weak, nonatomic) IBOutlet UILabel *lb_usaPrice;  // usa 价格 - 区间

@property (weak, nonatomic) IBOutlet UILabel *lb_zhekou;    // 折扣
@property (weak, nonatomic) IBOutlet UIImageView *img_zhekou; // img 折扣

@property (weak, nonatomic) IBOutlet UILabel *lb_comeFromSeller; // 来自哪里

@end
