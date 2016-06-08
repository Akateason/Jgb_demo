//
//  KillSegView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-26.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "KillSegView.h"
#import "KRedView.h"
#import "KGrayView.h"
#import "ColorsHeader.h"


@interface KillSegView ()<KRedViewDelegate,KGrayViewDelegate>
{
    KRedView    *redV   ;
    KGrayView   *grayV1 ;
    KGrayView   *grayV2 ;
}
@end

@implementation KillSegView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame AndMode:(SWITCH_MODE)mode
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = COLOR_BACKGROUND ;
        
        redV   = (KRedView *)[[[NSBundle mainBundle] loadNibNamed:@"KRedView" owner:self options:nil] lastObject] ;
        grayV1 = (KGrayView *)[[[NSBundle mainBundle] loadNibNamed:@"KGrayView" owner:self options:nil] lastObject] ;
        grayV2 = (KGrayView *)[[[NSBundle mainBundle] loadNibNamed:@"KGrayView" owner:self options:nil] lastObject] ;
      
        redV.delegate   = self ;
        grayV1.delegate = self ;
        grayV2.delegate = self ;
        
        [self switchMode:mode]      ;
        
        [self addSubview:redV]      ;
        [self addSubview:grayV1]    ;
        [self addSubview:grayV2]    ;
    }
    
    return self;
}


#define RED_WIDTH   184.0f
#define GRA_WIDTH   58.0f
#define ALL_HEIGHT  30.0f

- (void)switchMode:(SWITCH_MODE)mode
{
    redV.clockMode = mode ;
    
    //设倒计时时间
    [redV startTimeWithTimeOut:5] ;
    
    switch (mode)
    {
        case clock10:
        {
            redV.clockMode   = clock10 ;
            grayV1.clockMode = clock13 ;
            grayV2.clockMode = clock20 ;
            
            redV.frame   = CGRectMake(5, 0, RED_WIDTH, ALL_HEIGHT) ;
            grayV1.frame = CGRectMake(RED_WIDTH + 5*2, 0, GRA_WIDTH, ALL_HEIGHT) ;
            grayV2.frame = CGRectMake(RED_WIDTH + 5*3 + GRA_WIDTH , 0, GRA_WIDTH, ALL_HEIGHT) ;
        }
            break;
        case clock13:
        {
            grayV1.clockMode    = clock10 ;
            redV.clockMode      = clock13 ;
            grayV2.clockMode    = clock20 ;
            
            grayV1.frame = CGRectMake(5, 0, GRA_WIDTH, ALL_HEIGHT) ;
            redV.frame   = CGRectMake(GRA_WIDTH + 5*2, 0, RED_WIDTH, ALL_HEIGHT) ;
            grayV2.frame = CGRectMake(RED_WIDTH + GRA_WIDTH + 5*3, 0, GRA_WIDTH, ALL_HEIGHT) ;
        }
            break;
        case clock20:
        {
            grayV1.clockMode    = clock10 ;
            grayV2.clockMode    = clock13 ;
            redV.clockMode      = clock20 ;
            
            grayV1.frame = CGRectMake(5, 0, GRA_WIDTH, ALL_HEIGHT) ;
            grayV2.frame = CGRectMake(GRA_WIDTH + 5*2, 0, GRA_WIDTH, ALL_HEIGHT) ;
            redV.frame   = CGRectMake(GRA_WIDTH * 2 + 5*3, 0, RED_WIDTH, ALL_HEIGHT) ;
        }
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark --
#pragma mark -  KRedViewDelegate
- (void)switchToNextWithCurrent:(int)clockModeCurrent
{
    clockModeCurrent ++ ;
    
    if (clockModeCurrent == 4)
    {
        clockModeCurrent = 1 ;
    }
    
    [self switchMode:clockModeCurrent] ;
    
    [self.delegate sendToClockMode:clockModeCurrent] ;

}

#pragma mark --
#pragma mark - KGrayViewDelegate & KRedViewDelegate
- (void)clickButtonWithClock:(int)clockModeCurrent
{
    NSLog(@"clockModeCurrent : %d",clockModeCurrent) ;
    
    [self.delegate sendToClockMode:clockModeCurrent] ;
}


@end
