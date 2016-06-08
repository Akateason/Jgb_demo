//
//  FilterCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "FilterCell.h"
#import "ColorsHeader.h"


@implementation FilterCell

- (void)awakeFromNib
{
    // Initialization code
    
    UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)] ;
    baseline.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:baseline] ;
    
    
    UIView *left    =   [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, self.frame.size.height)] ;
    left.backgroundColor = COLOR_BACKGROUND;
    [self addSubview:left] ;
    
    UIView *right    =   [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 4, 0, 4, self.frame.size.height)] ;
    right.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:right] ;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
