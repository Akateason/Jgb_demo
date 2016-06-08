//
//  COcoupsonCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "COcoupsonCell.h"
#import "ColorsHeader.h"


@implementation COcoupsonCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = COLOR_BACKGROUND ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --
#pragma mark - setter
- (void)setIsReadOnly:(BOOL)isReadOnly
{
    _isReadOnly = isReadOnly ;
    
    
    _img_rightArrow.hidden = isReadOnly  ?  YES : NO ;
    
    _rightSideConstrant.constant = isReadOnly ? 13.0f : 46.0f ;
}

@end
