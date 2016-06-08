//
//  WeiXinView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "WeiXinView.h"
#import "ColorsHeader.h"


@implementation WeiXinView

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
    
    _lb_jgb.textColor = COLOR_PINK ;
    
    _backV.borderType = BorderTypeDashed;
    _backV.dashPattern = 4;
    _backV.spacePattern = 8;
    _backV.borderWidth = 4;
    _backV.borderColor = COLOR_LIGHT_GRAY ;
    
//    _backV.cornerRadius = 20;
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
