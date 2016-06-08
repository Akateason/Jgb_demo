//
//  TimeCountView.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-31.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "TimeCountView.h"
#import "ColorsHeader.h"


@interface TimeCountView ()
{
    dispatch_queue_t m_queue ;
    
    BOOL             m_firstTime ;
}
@property (weak, nonatomic) IBOutlet UILabel *lb_hour;
@property (weak, nonatomic) IBOutlet UILabel *lb_min;
@property (weak, nonatomic) IBOutlet UILabel *lb_sec;
@property (weak, nonatomic) IBOutlet UILabel *lb_mh1;
@property (weak, nonatomic) IBOutlet UILabel *lb_mh2;

@end

@implementation TimeCountView

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _lb_hour.backgroundColor = COLOR_PINK ;
    _lb_min.backgroundColor = COLOR_PINK ;
    _lb_sec.backgroundColor = COLOR_PINK ;
    
    _lb_mh1.textColor = COLOR_PINK ;
    _lb_mh2.textColor = COLOR_PINK ;
    
    float corner = 3.0f ;
    
    _lb_hour.layer.cornerRadius = corner ;
    _lb_hour.layer.masksToBounds = YES ;
    _lb_min.layer.cornerRadius = corner ;
    _lb_min.layer.masksToBounds = YES ;
    _lb_sec.layer.cornerRadius = corner ;
    _lb_sec.layer.masksToBounds = YES ;
    
    m_firstTime = YES ;
}

- (void)setCountDown:(int)countDown
{
    _countDown = countDown ;
    
    if (m_firstTime) [self startTimeWithTimeOut:_countDown] ;
    
}

- (void)startTimeWithTimeOut:(int)timeOutParam
{
    __block int timeout = timeOutParam ;  //倒计时时间 s
    __block BOOL bRun = YES ;

    if(m_queue)
    {
        dispatch_suspend(m_queue);
    }
    else
    {
        m_queue = dispatch_queue_create("queueCountDown", NULL) ;
    }
    
    dispatch_async(m_queue, ^{
        
        while (bRun)
        {
            if(timeout <= 0)
            {
                bRun = NO ;
                NSLog(@"倒计时结束，关闭") ;
                
                //倒计时结束，关闭
                dispatch_async(dispatch_get_main_queue(), ^{
                    //倒计时结束
                    [self.delegate countDownIsFinished] ;
                    
                });
            }
            else
            {
                int seconds = timeout % 60              ;
                int minutes = ( timeout / 60 ) % 60     ;
                int hours   = ( timeout / 3600 )        ;
                
                NSString *strSec    = [NSString stringWithFormat:@"%.2d", seconds] ;
                NSString *strMin    = [NSString stringWithFormat:@"%.2d", minutes] ;
                NSString *strHour   = [NSString stringWithFormat:@"%.2d", hours]   ;
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    //  设置界面的按钮显示 根据自己需求设置
                    [_lb_sec    setText:[NSString stringWithFormat:@"%@",strSec]];
                    [_lb_min    setText:[NSString stringWithFormat:@"%@",strMin]];
                    [_lb_hour   setText:[NSString stringWithFormat:@"%@",strHour]];
                    
                });
                
                timeout -- ;
            }
            
            sleep(1.0f) ;
        }
        
    }) ;
    
}


- (void)dealloc
{
    if(m_queue)
    {
        dispatch_suspend(m_queue);
    }
}

@end
