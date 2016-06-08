//
//  Guide4.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RQShineLabel.h"

@interface Guide4 : UIView

@property (weak, nonatomic) IBOutlet UIImageView *img_logo;

@property (weak, nonatomic) IBOutlet RQShineLabel *lb_title;

- (void)startAnimate ;

@end
