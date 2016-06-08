//
//  Guide1.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Guide1 : UIView

@property (weak, nonatomic) IBOutlet UILabel *lb_title1;

@property (weak, nonatomic) IBOutlet UILabel *lb_title2;

@property (weak, nonatomic) IBOutlet UIImageView *img_oversea;

@property (weak, nonatomic) IBOutlet UIImageView *img_plane;

@property (weak, nonatomic) IBOutlet UIImageView *img_ballon;


- (void)startAnimate ;


@end
