//
//  ProOneCellView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"


#define NOTIFICATION_PROONECELL_PRO_CLICKED     @"NOTIFICATION_PROONECELL_PRO_CLICKED"



@interface ProOneCellView : UIView

// setting properties


@property (nonatomic,retain)        Activity *activity   ;

@property (nonatomic)               BOOL    isSellFinish ;     //已妙光

@property (nonatomic)               BOOL    isSellStart  ;     //秒杀已开始


// setting views

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *lb_price ;            //原价

@property (weak, nonatomic) IBOutlet UILabel *lb_killPrice ;        //秒杀

@property (weak, nonatomic) IBOutlet UIView  *killDidFinishView ;    //已秒光view

@property (weak, nonatomic) IBOutlet UIView  *killWillStartView ;    //秒杀未开始

@property (weak, nonatomic) IBOutlet UIButton *clickButton  ;

- (IBAction)actionClick:(id)sender ;

@end
