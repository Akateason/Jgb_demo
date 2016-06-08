//
//  AddressCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "AddressCell.h"
#import "ColorsHeader.h"


@implementation AddressCell

- (void)setIsDefaultAddr:(BOOL)isDefaultAddr
{
    if (isDefaultAddr) {
        //default address
        self.lb_DEFAULT_address.hidden = FALSE ;
        self.back_view.layer.borderColor = COLOR_PINK.CGColor ;

    }else {
        //not default address
        self.lb_DEFAULT_address.hidden = TRUE  ;
        self.back_view.layer.borderColor = COLOR_LIGHT_GRAY.CGColor ;

    }
}


- (void)setMyAddr:(ReceiveAddress *)myAddr
{
    //  是否默认地址
    self.isDefaultAddr = myAddr.isDefault ;

    _lb_NameAndRegion.text = [NSString stringWithFormat:@"%@ %@",myAddr.uname,myAddr.location];
    _lb_myAddress.text = myAddr.address;
    _lb_phone.text = myAddr.phone;
    _lb_email.text = myAddr.email;
    
    _myAddr = myAddr ;
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    self.back_view.backgroundColor = [UIColor whiteColor] ;
    self.back_view.layer.masksToBounds = YES ;
    self.back_view.layer.borderWidth = 1.0f ;
    self.back_view.layer.cornerRadius = CORNER_RADIUS_ALL ;
    self.lb_DEFAULT_address.backgroundColor = COLOR_PINK  ;
    
    self.backgroundColor = [UIColor whiteColor] ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
