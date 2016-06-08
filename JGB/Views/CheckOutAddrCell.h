//
//  CheckOutAddrCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveAddress.h"
#import "LBorderView.h"

@interface CheckOutAddrCell : UITableViewCell

//  attrs
@property (nonatomic,retain) ReceiveAddress *address ;

@property (nonatomic)       BOOL     isReadOnly ;

//  views


@property (weak, nonatomic) IBOutlet UILabel *lb_receiveName;

@property (weak, nonatomic) IBOutlet UILabel *lb_phone;

@property (weak, nonatomic) IBOutlet UILabel *lb_tel;


@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UILabel *lb_idcard;

@property (weak, nonatomic) IBOutlet UILabel *lb_email;



@end
