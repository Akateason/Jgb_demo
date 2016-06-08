//
//  Guide2.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Guide2.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@interface Guide2 ()
{
    float   m_angle ;
    int     m_cycle ;
}
@end

@implementation Guide2

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
    _img_umbrella.alpha = 0.0f  ;
    _img_coin.alpha = 0.0f ;
    _img_money.alpha = 0.0f ;
    
    
    m_angle = 0.0f ;
    m_cycle = 0 ;
    
    [self startSpin] ;

    
}


- (void)goldCoinFlash
{
    CABasicAnimation *flashAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    flashAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    
    flashAnimation.toValue = [NSNumber numberWithFloat:0.5];
    
    flashAnimation.autoreverses = YES;
    
    flashAnimation.duration = 0.45f;
    
    flashAnimation.repeatCount = 10;
    
    flashAnimation.removedOnCompletion = NO;
    
    flashAnimation.fillMode=kCAFillModeForwards;
    
    [_img_coin.layer addAnimation:flashAnimation forKey:nil] ;
}


- (void)startSpin
{
    if (m_cycle > 100) return ;
    
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(m_angle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.55 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _img_sun.transform = endAngle;
        
    } completion:^(BOOL finished) {
        
        m_angle += 90 ;
        m_cycle ++ ;
        
//        NSLog(@"m_cycle : %d",m_cycle) ;
        
        [self startSpin] ;
        
    }];
    
}

- (void)startAnimate
{
    m_cycle = 0 ;

    _lb_title1.alpha = 0.0f ;
    _lb_title2.alpha = 0.0f ;
    _img_umbrella.alpha = 0.0f  ;
    _img_coin.alpha = 0.0f ;
    _img_money.alpha = 0.0f ;
    

    
    [UIView animateWithDuration:0.85f animations:^{
        
        _img_umbrella.transform = CGAffineTransformMakeTranslation(100, 100);
        _img_umbrella.transform = CGAffineTransformMakeRotation(0.0f);
        _img_umbrella.alpha = 1.0f  ;
        
    } completion:^(BOOL finished) {
        
        [self goldFly] ;
        
    }] ;
    
}


- (void)goldFly
{
    [UIView animateWithDuration:0.35 animations:^{

        _img_coin.alpha = 1.0f ;
        _img_coin.transform = CGAffineTransformMakeTranslation(100, 0);
        _img_coin.transform = CGAffineTransformMakeRotation(0.0f);
        
    } completion:^(BOOL finished) {
        
        [self goldCoinFlash] ;
        
        [self moneyFly] ;
        
    }] ;
}


- (void)moneyFly
{
    [UIView animateWithDuration:0.35 animations:^{
       
        _img_money.alpha = 1.0f ;
        _img_money.transform = CGAffineTransformMakeTranslation(100, 0);
        _img_money.transform = CGAffineTransformMakeRotation(-0.2f);

        
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
