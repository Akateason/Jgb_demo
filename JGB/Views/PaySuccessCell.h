//
//  PaySuccessCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-20.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "ReceiveAddress.h"

@protocol PaySuccessCellDelegate <NSObject>

- (void)seeOrderDetail ;

@end


@interface PaySuccessCell : UITableViewCell

//  attrs
@property (nonatomic,retain) Order              *order      ;
@property (nonatomic,retain) ReceiveAddress     *address    ;

@property (nonatomic,retain) id <PaySuccessCellDelegate> delegate ;

//  views
@property (weak, nonatomic) IBOutlet UIView *line1;

@property (weak, nonatomic) IBOutlet UIView *line2;

@property (weak, nonatomic) IBOutlet UILabel *lb_paySuccess;

@property (weak, nonatomic) IBOutlet UILabel *lb_title_receiveMan;
@property (weak, nonatomic) IBOutlet UILabel *lb_receiveMan;

@property (weak, nonatomic) IBOutlet UILabel *lb_title_phone;
@property (weak, nonatomic) IBOutlet UILabel *lb_phone;

@property (weak, nonatomic) IBOutlet UILabel *lb_title_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UILabel *lb_title_payway;
@property (weak, nonatomic) IBOutlet UILabel *lb_payway;

@property (weak, nonatomic) IBOutlet UILabel *lb_title_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;


@property (weak, nonatomic) IBOutlet UIButton *bt_seeDetail;
- (IBAction)seeOrderDetailAction:(id)sender;

@end
