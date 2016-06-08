//
//  KRedView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KillSegView.h"

@protocol KRedViewDelegate <NSObject>

- (void)switchToNextWithCurrent:(int)clockModeCurrent ;

- (void)clickButtonWithClock:(int)clockModeCurrent ;

@end


@interface KRedView : UIView

//  PROPERTIES
@property (nonatomic,retain) id <KRedViewDelegate> delegate     ;
@property (nonatomic)        int                   clockMode    ;

- (void)startTimeWithTimeOut:(int)timeOutParam ;

//  VIEWS

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_Hour;

@property (weak, nonatomic) IBOutlet UILabel *lb_Minute;

@property (weak, nonatomic) IBOutlet UILabel *lb_Second;

@property (weak, nonatomic) IBOutlet UIButton *pressedBt;
- (IBAction)pressedAction:(id)sender;




@end
