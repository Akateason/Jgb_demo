//
//  MoreCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-4.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "MoreCell.h"
#import "ColorsHeader.h"

@implementation MoreCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.backgroundColor = COLOR_BACKGROUND ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
