//
//  ReplyCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ReplyCell.h"
#import "ColorsHeader.h"

#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"


@implementation ReplyCell

- (void)awakeFromNib
{
// Initialization code
    
    [super awakeFromNib] ;
    
    self.backgroundColor = COLOR_BACKGROUND ;
}

- (void)setTheReply:(Reply *)theReply
{
    _theReply = theReply ;
    
    
    NSDictionary* style1 = @{ @"gray" : [UIColor darkGrayColor] ,
                              @"black": [UIColor blackColor]    ,
                              @"red"  : COLOR_PINK }            ;
    
    NSString *strAttri   = @""  ;
    
    if (! _theReply.parentName)
    {
        strAttri = [NSString stringWithFormat:@"<red>%@</red>: <gray>%@</gray>",_theReply.uname,_theReply.message] ;
    }
    else
    {
        strAttri = [NSString stringWithFormat:@"<red>%@</red> <black>回复</black> <red>%@</red>: <gray>%@</gray>",_theReply.uname,_theReply.parentName,_theReply.message] ;
    }
    
    _lb_content.attributedText = [strAttri attributedStringWithStyleBook:style1];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
