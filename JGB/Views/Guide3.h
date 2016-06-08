//
//  Guide3.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Guide3 : UIView


@property (weak, nonatomic) IBOutlet UILabel *lb_title1;

@property (weak, nonatomic) IBOutlet UILabel *lb_title2;

@property (weak, nonatomic) IBOutlet UILabel *lb_title3;


@property (weak, nonatomic) IBOutlet UIImageView *img_bgStar;

@property (weak, nonatomic) IBOutlet UIImageView *img_star;

@property (weak, nonatomic) IBOutlet UIImageView *img_moon;

@property (weak, nonatomic) IBOutlet UIImageView *img_monkey;


- (void)startAnimate ;


@end
