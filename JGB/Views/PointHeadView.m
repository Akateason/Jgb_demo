//
//  PointHeadView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "PointHeadView.h"
#import "ColorsHeader.h"


@implementation PointHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    _lb_points.textColor = COLOR_PINK ;
    _v1.backgroundColor = [UIColor clearColor] ;
    _v2.backgroundColor = COLOR_LIGHT_GRAY ;
    
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
