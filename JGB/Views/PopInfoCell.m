//
//  PopInfoCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "PopInfoCell.h"
#import "ColorsHeader.h"


@implementation PopInfoCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    self.backgroundColor = [UIColor whiteColor] ;
    
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3210, 1)] ;
    topLine.backgroundColor = COLOR_BACKGROUND ;
    [self.contentView addSubview:topLine] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end
