//
//  KRedView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "KRedView.h"
#import "ColorsHeader.h"


@implementation KRedView

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
    
    [self setViewStyle:_lb_Hour]    ;
    [self setViewStyle:_lb_Minute]  ;
    [self setViewStyle:_lb_Second]  ;
    
    self.backgroundColor = [UIColor clearColor] ;

  
}

- (void)setClockMode:(int)clockMode
{
    _clockMode = clockMode ;
    
    NSString *strTitle = @"" ;
    switch (_clockMode)
    {
        case clock10:
        {
            strTitle = @"10点档结束还剩" ;
        }
            break;
        case clock13:
        {
            strTitle = @"13点档结束还剩" ;
        }
            break;
        case clock20:
        {
            strTitle = @"20点档结束还剩" ;
        }
            break;
            
        default:
            break;
    }
    _lb_title.text = strTitle  ;
}


- (void)setViewStyle:(UIView *)theView
{
    [theView.layer setCornerRadius:5.0f] ;
    
    theView.layer.masksToBounds = YES ;
    
    theView.backgroundColor = COLOR_GRAY_BAR ;
}

- (IBAction)pressedAction:(id)sender
{
    NSLog(@"%@",_lb_title.text) ;
    [self.delegate clickButtonWithClock:_clockMode] ;
}




- (void)startTimeWithTimeOut:(int)timeOutParam
{
    __block int timeout = timeOutParam ;  //倒计时时间 s

    __block BOOL bRun = YES ;
    
    dispatch_queue_t queue = dispatch_queue_create("queueCountDown", NULL) ;
    dispatch_async(queue, ^{
       
        while (bRun)
        {
            if(timeout <= 0)
            {
                bRun = NO ;
                NSLog(@"倒计时结束，关闭") ;

                //倒计时结束，关闭
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.delegate switchToNextWithCurrent:_clockMode] ;

                });
            }
            else
            {
                // int minutes = timeout / 60;
                int seconds = timeout % 60              ;
                int minutes = ( timeout / 60 ) % 60     ;
                int hours   = ( timeout / 3600 )        ;
                
                NSString *strSec = [NSString stringWithFormat:@"%.2d", seconds] ;
                NSString *strMin = [NSString stringWithFormat:@"%.2d", minutes] ;
                NSString *strHou = [NSString stringWithFormat:@"%.2d", hours]   ;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //  NSLog(@"____%@",strTime);
                    [_lb_Second  setText:[NSString stringWithFormat:@"%@",strSec]];
                    [_lb_Minute  setText:[NSString stringWithFormat:@"%@",strMin]];
                    [_lb_Hour    setText:[NSString stringWithFormat:@"%@",strHou]];
                    
                });
                
                timeout -- ;
            }
            
            sleep(1.0f) ;
        }

    }) ;
    
    
    
    
    
}



@end
