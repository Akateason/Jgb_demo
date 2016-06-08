//
//  Guide3.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Guide3.h"
#import <AKATeasonFramework/AKATeasonFramework.h>


@implementation Guide3

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
    
    _lb_title1.alpha = 0.0f ;
    _lb_title2.alpha = 0.0f ;
    _lb_title3.alpha = 0.0f ;
    
    
    [self monkeyMoving] ;

    [self moonMoving]   ;
   
    
    CABasicAnimation *animation = [TeaAnimation opacityForever_Animation:0.85] ;
    [_img_star.layer addAnimation:animation forKey:nil] ;
}


- (void)moonMoving
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    float tempAngle = 0 * ( M_PI / 2 ) ;
    
    animation.duration = 2.25f;
    
    float flex = 0.2 * ( M_PI / 2 ) ;
    
    animation.values = @[ @(tempAngle), @(tempAngle - flex), @(tempAngle + flex), @(tempAngle) ];
    
    animation.keyTimes = @[ @(0), @(0.33),@(0.66), @(1) ];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    animation.repeatCount = FLT_MAX ;
    
    [_img_moon.layer addAnimation:animation forKey:@"moonAnimation"];
    
}


- (void)monkeyMoving
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    
    CGFloat currentTy = _img_monkey.transform.ty;
    
    animation.duration = 1.65f;
    
    animation.values = @[ @(currentTy), @(currentTy + 10), @(currentTy - 10), @(currentTy) ];
    
    animation.keyTimes = @[ @(0), @(0.33),@(0.66), @(1) ];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    animation.repeatCount = FLT_MAX ;
    
    [_img_monkey.layer addAnimation:animation forKey:@"monkeyShake"];

}


- (void)startAnimate
{
    _lb_title1.alpha = 0.0f ;
    _lb_title2.alpha = 0.0f ;
    _lb_title3.alpha = 0.0f ;
    
    
    [UIView animateWithDuration:0.85f animations:^{
        
        _lb_title1.transform = CGAffineTransformMakeTranslation(0, 10);

        _lb_title1.alpha = 1.0f  ;
        
    } completion:^(BOOL finished) {
        
        [self subTitles] ;
        
    }] ;

    
}


- (void)subTitles
{
    [UIView animateWithDuration:0.65 animations:^{
        
        _lb_title2.transform = CGAffineTransformMakeTranslation(0, 10);

        _lb_title2.alpha = 1.0f  ;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.65 animations:^{
            _lb_title3.transform = CGAffineTransformMakeTranslation(0, 10);

            _lb_title3.alpha = 1.0f  ;
        } completion:nil] ;
        
    }] ;
}



@end
