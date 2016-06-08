//
//  ConditionSubView.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-3.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "ConditionSubView.h"

@implementation ConditionSubView

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
    
    _lb_title.textColor     = [UIColor darkGrayColor] ;
    _lb_content.textColor   = [UIColor lightGrayColor] ;
    
    
    
}




@end
