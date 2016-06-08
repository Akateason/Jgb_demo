//
//  CatagoryCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatagoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_catagory;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_detail;

@end
