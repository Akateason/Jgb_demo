//
//  BagConditionCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-26.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bag.h"

@interface BagConditionCell : UITableViewCell

@property (nonatomic,copy) NSString *parcelID ;

@property (nonatomic,retain) Bag *theBag ;

@property (weak, nonatomic) IBOutlet UILabel *lb_orderID; // 订单号 ?

@property (weak, nonatomic) IBOutlet UILabel *lb_bagID; // 运单号 ?

@property (weak, nonatomic) IBOutlet UILabel *lb_bagStatus; // 包裹状态

@end
