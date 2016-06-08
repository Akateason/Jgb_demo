//
//  TimeCountView.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-31.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeCountViewDelegate <NSObject>

- (void)countDownIsFinished ;

@end



@interface TimeCountView : UIView

@property (nonatomic,retain)    id <TimeCountViewDelegate>  delegate  ;
@property (nonatomic)           int                         countDown ;

@end
