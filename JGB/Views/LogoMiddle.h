//
//  LogoMiddle.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-4.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoMiddle : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lb_left;
@property (weak, nonatomic) IBOutlet UILabel *lb_right;



- (void)goMoving ;



@end
