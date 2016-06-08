//
//  Guide4.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Guide4.h"


@implementation Guide4

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


- (void)startAnimate
{
    
    [_lb_title shine] ;
    
    
}




@end
