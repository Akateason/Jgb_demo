//
//  ProScroSubView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProOneCellView.h"
#import "Activity.h"

@interface ProScroSubView : UIView

//properties
@property (nonatomic,retain) Activity *activity1 ;

@property (nonatomic,retain) Activity *activity2 ;

@property (nonatomic,retain) Activity *activity3 ;

//views
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet ProOneCellView *pro1;

@property (weak, nonatomic) IBOutlet ProOneCellView *pro2;

@property (weak, nonatomic) IBOutlet ProOneCellView *pro3;



@end
