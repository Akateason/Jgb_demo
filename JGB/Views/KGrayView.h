//
//  KGrayView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KillSegView.h"

@protocol KGrayViewDelegate <NSObject>

- (void)clickButtonWithClock:(int)clockModeCurrent ;

@end

@interface KGrayView : UIView

//properties
@property (nonatomic)        int                   clockMode    ;

@property (nonatomic,retain) id <KGrayViewDelegate> delegate    ;


//views
@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UIButton *pressedBt;

- (IBAction)pressedAction:(id)sender;

@end
