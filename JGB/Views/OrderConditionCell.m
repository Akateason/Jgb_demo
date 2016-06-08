//
//  OrderConditionCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "OrderConditionCell.h"
#import "ColorsHeader.h"


@implementation OrderConditionCell

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
