//
//  TabBarController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DigitInformation.h"


@interface TabBarController : UITabBarController

@property (weak, nonatomic) IBOutlet UITabBar *myTabBar;

@property (nonatomic,retain)DigitInformation *digit;

@end
