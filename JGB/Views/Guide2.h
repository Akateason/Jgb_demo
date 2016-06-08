//
//  Guide2.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Guide2 : UIView

@property (weak, nonatomic) IBOutlet UILabel *lb_title1;

@property (weak, nonatomic) IBOutlet UILabel *lb_title2;

@property (weak, nonatomic) IBOutlet UIImageView *img_umbrella;

@property (weak, nonatomic) IBOutlet UIImageView *img_money;

@property (weak, nonatomic) IBOutlet UIImageView *img_coin;

@property (weak, nonatomic) IBOutlet UIImageView *img_sun;


- (void)startAnimate ;

@end
