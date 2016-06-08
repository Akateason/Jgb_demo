//
//  HelpView.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-2-27.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "HelpView.h"

@interface HelpView()

@property (nonatomic,retain) UIButton *button ;

@end

@implementation HelpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help_proDetail"]] ;
        imgV.frame = CGRectMake(0, frame.size.height - 101, 320, 101) ;
        [self addSubview:imgV] ;
        
        self.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.9] ;
        
        _button = [[UIButton alloc] initWithFrame:frame] ;
        [_button setTitle:@"" forState:UIControlStateNormal] ;
        [_button addTarget:self action:@selector(backgroundPressedAction) forControlEvents:UIControlEventTouchUpInside] ;
        [self addSubview:_button] ;
    }
    return self;
}


- (void)backgroundPressedAction
{
    NSLog(@"backgroundPressedAction") ;
    
    [self.delegate helpViewPressedCallBack] ;
    
}

@end
