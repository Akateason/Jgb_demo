//
//  MonListCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLabel.h"


@interface MonListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lb_key;
@property (weak, nonatomic) IBOutlet LPLabel *lb_val;

@end
