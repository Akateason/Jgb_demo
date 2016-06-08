//
//  HistoryHotCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "HistoryHotCell.h"
#import "ColorsHeader.h"


@implementation HistoryHotCell

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
    
    float wid = 10.0f ;
    UIView *baseLine = [[UIView alloc] initWithFrame:CGRectMake(wid, self.frame.size.height - 1, self.frame.size.width - wid * 2, 1)] ;
    baseLine.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:baseLine] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteAction:(id)sender
{
    NSLog(@"deleteAction") ;
    
    [self.delegate deleteHistoryStringName:_lb.text] ;
}


@end
