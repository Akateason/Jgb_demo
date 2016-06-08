//
//  LogoMiddle.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-4.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "LogoMiddle.h"
#import "ColorsHeader.h"
#import "AFViewShaker.h"
#import <AKATeasonFramework/AKATeasonFramework.h>


#define flt_animation   1.0f

@interface LogoMiddle ()
{
    AFViewShaker *m_viewShaker ;
}
@end

@implementation LogoMiddle

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
    
    _lb_left.textColor = COLOR_PINK ;
    _lb_right.textColor = COLOR_PINK ;
    
    
    CABasicAnimation *animation = [TeaAnimation opacityForever_Animation:flt_animation] ;
    
    [_lb_left.layer addAnimation:animation forKey:@"logoShine"] ;

    [self performSelector:@selector(delayAnimation) withObject:nil afterDelay:flt_animation / 2.0f] ;
    

}

- (void)delayAnimation
{
    CABasicAnimation *animation = [TeaAnimation opacityForever_Animation:flt_animation] ;
    [_lb_right.layer addAnimation:animation forKey:@"logoShine"] ;
}


- (void)goMoving
{
//    NSArray * viewlist = @[_lb_left,_imgLogo,_lb_right] ;
    NSArray * viewlist = @[_imgLogo] ;

    if (!m_viewShaker) {
        m_viewShaker = [[AFViewShaker alloc] initWithViewsArray:viewlist];
    }
    [m_viewShaker shake] ;
    
    
    [TeaAnimation turnRoundBackWithView:_imgLogo] ;

}


@end
