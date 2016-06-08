//
//  PopSubCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "PopSubCell.h"
#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"


@implementation PopSubCell

- (void)awakeFromNib
{
    // Initialization code



    _lb_left.textColor  = [UIColor darkGrayColor] ;
    _lb_right.textColor = [UIColor lightGrayColor] ;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellObj:(DetailCellObj *)cellObj
{
    
    _cellObj        = cellObj ;
    
    _lb_left.text   = cellObj.keyChinese ;
    _lb_right.text  = cellObj.valDescrip ;
    
    if ([cellObj.keyChinese isEqualToString:KEYS_NATIONAL_FREIGHT]) // 国际运费
    {
        _lb_left.text = @"" ;
        
        //有中文英文标题
        NSDictionary* style1 = @{ @"black" : [UIColor darkGrayColor] ,
                                  @"gray"  : [UIColor lightGrayColor] ,
                                  @"small" : [UIFont systemFontOfSize:10.0f]
                                  } ;
        
        NSString *strAttri   = @""  ;
        
        strAttri = [NSString stringWithFormat:@"<small><black>%@</black><br><gray>%@</gray></small>",KEYS_NATIONAL_FREIGHT,@"0.5kg以内运费30元，超过0.5kg部分6元/0.1kg"] ;
        
        _lb_left.attributedText = [strAttri attributedStringWithStyleBook:style1];
    }
    else if ([cellObj.keyChinese hasPrefix:@"到手价"])
    {
        _lb_left.font   = [UIFont systemFontOfSize:10.0f] ;
        _lb_right.font  = [UIFont systemFontOfSize:10.0f] ;
    }

    
    
}

- (void)setCellKvo:(ExPressKVO *)cellKvo
{
    _cellKvo = cellKvo ;
    
    _lb_left.text   = cellKvo.key   ;
    _lb_right.text  = cellKvo.value ;
}

//- (void)setIsLastLine:(BOOL)isLastLine
//{
//    _isLastLine = isLastLine ;
//    
//    _lb_solidLine.hidden = isLastLine ;
//}


@end
