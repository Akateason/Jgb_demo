//
//  KGrayView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "KGrayView.h"

@implementation KGrayView

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
    
    self.backgroundColor = [UIColor clearColor] ;

}

- (void)setClockMode:(int)clockMode
{
    _clockMode = clockMode ;
    
    NSString *strTitle = @"" ;
    switch (_clockMode)
    {
        case clock10:
        {
            strTitle = @"10点档" ;
        }
            break;
        case clock13:
        {
            strTitle = @"13点档" ;
        }
            break;
        case clock20:
        {
            strTitle = @"20点档" ;
        }
            break;
            
        default:
            break;
    }
    
    _lb_title.text = strTitle  ;
}

- (IBAction)pressedAction:(id)sender
{
    NSLog(@"%@",_lb_title.text) ;
    
    [self.delegate clickButtonWithClock:_clockMode] ;
}

@end
