//
//  HotCollectionCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "HotCollectionCell.h"

@implementation HotCollectionCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor whiteColor] ;
    self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:0.7].CGColor ;
    self.layer.borderWidth = 1.0f ;
    self.layer.cornerRadius = 5.0f ;
    
    _lb_word.textColor = [UIColor darkGrayColor] ;

}

@end
