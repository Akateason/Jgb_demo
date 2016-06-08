//
//  StarView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "StarView.h"

@implementation StarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _level = 0 ;
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

- (IBAction)pressedStarAction:(id)sender {
    
    UIButton *bt = (UIButton *)sender ;
    
    [self showAllStarsWithTag:bt.tag] ;
}




- (void)showAllStarsWithTag:(int)tag
{
    for (int i = TAG_STAR1; i < TAG_STAR1 + 5; i++)
    {
        UIButton *_bt ;
        for (UIButton *bt in [self subviews]) {
            if (bt.tag == i) {
                _bt = bt ;
            }
        }

        if (i <= tag)
        {
            //red
            [_bt setImage:[UIImage imageNamed:@"starY"] forState:UIControlStateNormal] ;
        }
        else
        {
            //gray
            [_bt setImage:[UIImage imageNamed:@"starN"] forState:UIControlStateNormal] ;
        }
    }
    
    _level = tag - 434200;
    
    [self.delegate sendStarLevel:_level] ;
    
}


@end
