//
//  PointCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "PointCell.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "ColorsHeader.h"


@implementation PointCell

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    if ([_lb_detaPoints.text hasPrefix:@"+"] || [_lb_detaPoints.text hasPrefix:@"＋"]) {
        _lb_detaPoints.textColor = COLOR_PINK ;
    }else if ([_lb_detaPoints.text hasPrefix:@"-"] || [_lb_detaPoints.text hasPrefix:@"－"]) {
        _lb_detaPoints.textColor = COLOR_WD_GREEN ;
    }
}

- (void)setViewStyle
{
    [TeaCornerView setRoundHeadPicWithView:_roundView] ;
    
}

- (void)setPointMode:(MyPointCellMode)pointMode
{
    switch (pointMode)
    {
        case isUp:
        {
            _upLine.hidden      = YES   ;
            _bottonLine.hidden  = NO    ;
        }
            break;
        case isMiddle:
        {
            _upLine.hidden      = NO    ;
            _bottonLine.hidden  = NO    ;
        }
            break;
        case isBottom:
        {
            _upLine.hidden      = NO    ;
            _bottonLine.hidden  = YES   ;
        }
            break;
        default:
            break;
    }
}


- (void)setTheScore:(Score *)theScore
{
    
    _theScore = theScore ;
    
    _lb_time.text       = [MyTick getDateWithTick:theScore.atime AndWithFormart:TIME_STR_FORMAT_3] ;
    
    NSString *scoreShow = (theScore.credit > 0) ? [NSString stringWithFormat:@"+%d",theScore.credit] : [NSString stringWithFormat:@"%d",theScore.credit] ;
    _lb_detaPoints.text = scoreShow     ;
    _lb_content.text    = theScore.opt  ;
    
}


- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    [self setViewStyle] ;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
