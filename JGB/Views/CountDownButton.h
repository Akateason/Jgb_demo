//
//  CountDownButton.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-9.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

//  倒计时 button

@interface CountDownButton : UIButton

@property (nonatomic) int numberSum ;   // 时间 总数

- (void)startingCountDown ;

@end
