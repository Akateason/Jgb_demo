//
//  CountDownButton.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-9.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "CountDownButton.h"
#import "ColorsHeader.h"


@interface CountDownButton ()

@property (nonatomic) int numRemain ;

@end

@implementation CountDownButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder] ;
    
    if (self)
    {
        self.backgroundColor = COLOR_PINK ;
        self.layer.cornerRadius = CORNER_RADIUS_ALL ;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [self setFont:[UIFont boldSystemFontOfSize:14.0f]] ;
    }
    
    return self;
}

- (int)numberSum
{
    if (!_numberSum) {
        _numberSum = 90 ; // 默认90s
    }
    
    return _numberSum ;
}



- (void)startingCountDown
{
    _numRemain = self.numberSum ;
    
    dispatch_queue_t queue = dispatch_queue_create("countDownQueue", NULL) ;
    dispatch_async(queue, ^{
        
        BOOL bOpen = YES ;
        
        while (bOpen)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *strTitle = (!self.numRemain) ? @"短信验证" : [NSString stringWithFormat:@"重新获取(%d)",self.numRemain] ;
                [self setTitle:strTitle forState:UIControlStateNormal] ;
                self.userInteractionEnabled = (!self.numRemain) ? NO : YES ;
            }) ;
            
            sleep(1) ;
            
            _numRemain-- ;
            
            if (_numRemain == -1)
            {
                bOpen = NO ;
                self.userInteractionEnabled = YES ;
            }
            
        }
        
    }) ;
    
}





@end
