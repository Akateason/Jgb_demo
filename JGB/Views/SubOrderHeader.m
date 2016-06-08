//
//  SubOrderHeader.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-18.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "SubOrderHeader.h"
#import "ColorsHeader.h"

@implementation SubOrderHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _lb_status.textColor = COLOR_PINK ;
    _baseLine.backgroundColor = COLOR_BACKGROUND ;
    
}

- (void)setCanSeeShip:(BOOL)canSeeShip
{
    _canSeeShip = canSeeShip ;
    
    _lb_seeship.hidden = !canSeeShip ;
    _img_arrow.hidden = !canSeeShip ;
    _bt_pressed.userInteractionEnabled = canSeeShip ;
}

- (IBAction)pressedHeaderAction:(id)sender
{
    
    NSLog(@"pressedHeaderAction") ;
    
    [self.delegate seeShipDetailCallBackWithSection:_section] ;
}



@end
