//
//  PayWayCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayType.h"


@interface PayWayCell : UITableViewCell

//attrs
@property (nonatomic,retain) PayType *paytype ;

//views
@property (weak, nonatomic) IBOutlet UILabel *lb_key;
@property (weak, nonatomic) IBOutlet UILabel *lb_payWay;

@end
