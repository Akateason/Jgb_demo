//
//  CouponCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"


@interface CouponCell : UITableViewCell

// properties
@property (nonatomic,retain)Coupon      *coupson ;

@property (nonatomic)   BOOL     isSelected ;

// views
@property (weak, nonatomic) IBOutlet UILabel *lb_case;      //购物满100
@property (weak, nonatomic) IBOutlet UILabel *lb_title;     //现金券

@property (weak, nonatomic) IBOutlet UILabel *lb_howMuch;   //100

@property (weak, nonatomic) IBOutlet UILabel *lb_detail;    //有效期


@property (weak, nonatomic) IBOutlet UIView *bg_coupson;
@property (weak, nonatomic) IBOutlet UIView *upLine;

@end
