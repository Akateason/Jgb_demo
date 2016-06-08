//
//  AddressCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReceiveAddress.h"

@interface AddressCell : UITableViewCell

@property (nonatomic,retain) ReceiveAddress *myAddr ;



//  是否默认地址
@property (nonatomic,assign)    BOOL isDefaultAddr ;


//  subviews
@property (weak, nonatomic) IBOutlet UIView *back_view;

@property (weak, nonatomic) IBOutlet UILabel *lb_NameAndRegion;
@property (weak, nonatomic) IBOutlet UILabel *lb_myAddress;
@property (weak, nonatomic) IBOutlet UILabel *lb_phone;
@property (weak, nonatomic) IBOutlet UILabel *lb_email;

@property (weak, nonatomic) IBOutlet UILabel *lb_DEFAULT_address;





@end
