//
//  CommentAlertCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CommentAlertCell.h"
#import "ColorsHeader.h"


@implementation CommentAlertCell

- (void)awakeFromNib
{
    // Initialization code
    
    _lb_quick.textColor         = COLOR_PINK            ;
    _lb_quick.layer.borderColor = COLOR_PINK.CGColor    ;
    _lb_quick.layer.borderWidth = 1.0f                  ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



