//
//  MessageCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MessageCell.h"
#import "DigitInformation.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "ColorsHeader.h"



@implementation MessageCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
      
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _upLine.hidden = NO ;
    _bottomLine.hidden = NO ;
    
    _upLine.backgroundColor = COLOR_LIGHT_PINK ;
    _bottomLine.backgroundColor = COLOR_LIGHT_PINK ;
    _corner.backgroundColor = COLOR_LIGHT_PINK ;
    
    _corner.layer.masksToBounds = YES ;
    
    _bgView.backgroundColor = COLOR_WHITE_BAI ;
    
    self.backgroundColor = COLOR_WHITE_BAI ;
    
    _borderView.backgroundColor = [UIColor whiteColor];
    _borderView.layer.borderWidth = 1 ;
    _borderView.layer.cornerRadius = 10 ;
    _borderView.layer.borderColor = COLOR_LIGHT_GRAY.CGColor ;
    
    _lb_choujiang.backgroundColor = COLOR_PINK ;
    [TeaCornerView setRoundHeadPicWithView:_lb_choujiang] ;
    [TeaCornerView setRoundHeadPicWithView:_corner] ;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;

    switch (_line_Is_FME) {
        case -1:
        {
            _upLine.hidden = YES ;
            _bottomLine.hidden = NO ;
        }
        break;
        case 0:
        {
            _upLine.hidden = NO ;
            _bottomLine.hidden = NO ;
        }
        break;
        case 1:
        {
            _upLine.hidden = NO ;
            _bottomLine.hidden = YES ;
        }
        break;
        default:
        break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --
#pragma mark - setter
- (void)setIsHavingBorder:(BOOL)isHavingBorder
{
    _isHavingBorder = isHavingBorder ;
    
    _borderView.layer.borderWidth = isHavingBorder ? 1.0f : 0.0f ;
    
}



- (void)setIsFirstPoint:(BOOL)isFirstPoint
{
    _isFirstPoint = isFirstPoint ;
    
    _corner.backgroundColor = (isFirstPoint) ? COLOR_PINK :
    COLOR_LIGHT_PINK ;
    
    _corner.layer.borderColor = COLOR_LIGHT_PINK.CGColor ;
    _corner.layer.borderWidth = isFirstPoint ? 2.0f : 0.0f ;
    
}

@end
