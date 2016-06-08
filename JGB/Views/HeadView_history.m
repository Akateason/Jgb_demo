//
//  HeadView_history.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "HeadView_history.h"
#import "ColorsHeader.h"
@implementation HeadView_history

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _lb1.textColor = [UIColor darkGrayColor] ;
    [_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal] ;
    
    float wid = 10.0f ;
    UIView *baseLine = [[UIView alloc] initWithFrame:CGRectMake(wid, self.frame.size.height - 1, self.frame.size.width - wid * 2, 1)] ;
    baseLine.backgroundColor = COLOR_BACKGROUND ; //[UIColor lightGrayColor] ;
    [self addSubview:baseLine] ;
}



- (IBAction)deleteHistoryAction:(id)sender
{
    NSLog(@"deleteHistoryAction");
    
    [self.delegate deleteAllHistoryCallBack] ;
}




@end
