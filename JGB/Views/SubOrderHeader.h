//
//  SubOrderHeader.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-18.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubOrderHeaderDelegate <NSObject>

- (void)seeShipDetailCallBackWithSection:(int)section ;

@end


@interface SubOrderHeader : UIView

//attrs

@property (nonatomic,retain) id <SubOrderHeaderDelegate> delegate ;

@property (nonatomic)                int     section ;

@property (nonatomic)                BOOL    canSeeShip ; // 是否能查看物流

//views
@property (weak, nonatomic) IBOutlet UIImageView *img_arrow ;

@property (weak, nonatomic) IBOutlet UILabel *lb_seeship ;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UILabel *lb_status;

@property (weak, nonatomic) IBOutlet UILabel *lb_comeFrom;

- (IBAction)pressedHeaderAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *bt_pressed;

@property (weak, nonatomic) IBOutlet UIView *baseLine;

@end
