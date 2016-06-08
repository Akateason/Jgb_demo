//
//  Guide1.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Guide1.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@interface Guide1 ()

@end

@implementation Guide1
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
//
    [self bringSubviewToFront:_img_oversea] ;

    
    [self heartBeat] ;
    
//
    [self startAnimate] ;
}

- (void)heartBeat
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values    = @[@(0.98),@(1.0),@(1.01)];
    k.keyTimes  = @[@(0.25),@(0.5),@(0.75),@(1.0)];
    k.duration  = 0.9;
    k.calculationMode = kCAAnimationLinear;
    k.repeatCount = MAXFLOAT ;
    [_img_oversea.layer addAnimation:k forKey:@"SHOW1"];
}


- (void)startAnimate
{
    _img_plane.alpha  = 0.0f ;
    _lb_title1.alpha  = 0.0f ;
    _lb_title2.alpha  = 0.0f ;
    _img_ballon.alpha = 0.0f ;
    
    [UIView animateWithDuration:1.35f animations:^{
        
        _img_ballon.transform = CGAffineTransformMakeRotation(0.55f);
        _img_ballon.transform = CGAffineTransformMakeTranslation(20, - 50);
        _img_ballon.alpha = 1.0f ;

        
    } completion:^(BOOL finished) {
        [self planeFly] ;
    }] ;

}


- (void)planeFly
{
    [UIView animateWithDuration:1.25 animations:^{
        
        _img_plane.transform = CGAffineTransformMakeTranslation(-300, 400);
        _img_plane.transform = CGAffineTransformMakeRotation(-0.22f);
        _img_plane.alpha   = 1.0f ;
        
    } completion:^(BOOL finished) {
        
        [self titleAnimate] ;
        
        
    }] ;
}



- (void)titleAnimate
{
    [UIView animateWithDuration:0.65 animations:^{
        
        _lb_title1.transform = CGAffineTransformMakeTranslation(0, 10) ;

        _lb_title1.alpha  = 1.0f ;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.65 animations:^{
           
            _lb_title2.transform = CGAffineTransformMakeTranslation(0, 10) ;

            _lb_title2.alpha  = 1.0f ;

        } completion:nil] ;
    }] ;
}




@end
