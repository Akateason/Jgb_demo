//
//  CatagoryCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CatagoryCell.h"

@implementation CatagoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    float flexWid = 70.0f ;
    
    UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(flexWid, self.frame.size.height - 1, self.frame.size.width - flexWid, 1)] ;
    baseline.backgroundColor = [UIColor lightGrayColor] ;
    [self addSubview:baseline] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
