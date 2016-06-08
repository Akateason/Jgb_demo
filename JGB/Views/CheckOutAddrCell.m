//
//  CheckOutAddrCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CheckOutAddrCell.h"
#import "ColorsHeader.h"


@implementation CheckOutAddrCell

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
//    self.backgroundColor = COLOR_PINK ;
    
    
}


- (void)awakeFromNib
{
    // Initialization code
    


    
    self.backgroundColor    = COLOR_WHITE_BAI ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsReadOnly:(BOOL)isReadOnly
{
    _isReadOnly = isReadOnly ;

    self.accessoryType = isReadOnly ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator ;

}


- (void)setAddress:(ReceiveAddress *)address
{
    _address = address ;
    
    if (_address == nil)
    {
        self.textLabel.text =  @"点击新增收货地址" ;
        self.textLabel.font = [UIFont systemFontOfSize:13.0f] ;
        self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator ;
        
        _lb_address.hidden = YES ;
        _lb_email.hidden = YES;
        _lb_idcard.hidden = YES ;
        _lb_phone.hidden = YES;
        _lb_receiveName.hidden = YES ;
        _lb_tel.hidden = YES ;
        
        self.accessoryType = UITableViewCellAccessoryNone ;
        return ;
    }
    
    self.textLabel.text = nil ;
    self.accessoryType  = UITableViewCellAccessoryNone ;

    _lb_address.hidden = NO ;
    _lb_email.hidden = NO;
    _lb_idcard.hidden = NO ;
    _lb_phone.hidden = NO;
    _lb_receiveName.hidden = NO ;
    _lb_tel.hidden = NO ;

    
    
    _lb_receiveName.text    = address.uname ;
    _lb_phone.text          = address.phone ;
    _lb_tel.text            = address.tel ;
    _lb_address.text        = [address getDetailAddress] ;
    _lb_idcard.text         = address.idcard ;
    _lb_email.text          = address.email ;
    
    if (!address.idcard)    _lb_idcard.hidden = YES ;
    
    if (!address.email)     _lb_email.hidden = YES ;
        
    if (!address.tel)       _lb_tel.hidden = YES ;
    
    

}




@end
