//
//  LabelNoteVIew.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-3.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "LabelNoteVIew.h"
#import "ColorsHeader.h"

@interface LabelNoteVIew ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead ;
@property (weak, nonatomic) IBOutlet UILabel *lb_content  ;

// red 1 , blue 2
- (void)setColorStyle:(int)colorStyle ;

@end


@implementation LabelNoteVIew


// red 1 , blue 2
- (void)setColorStyle:(int)colorStyle
{
    
    if (colorStyle == 1)
    {
        _imgHead.image = [UIImage imageNamed:@"noteRed.png"] ;
        _lb_content.backgroundColor = COLOR_PINK ;
    }
    else if (colorStyle == 2)
    {
        _imgHead.image = [UIImage imageNamed:@"noteBlue.png"] ;
        _lb_content.backgroundColor = COLOR_MYBLUE ;
    }
    
}

- (void)setNoteMode:(ModeForGoodsNotes)noteMode
{
    _noteMode = noteMode ;
    
    switch (noteMode) {
        case modeAddons:
        {
            self.lb_content.text = @"加购商品 " ;
            [self setColorStyle:2] ;
        }
            break;
        case modeDaiGou:
        {
            self.lb_content.text = @"代购商品 " ;
            [self setColorStyle:1] ;
        }
            break;
        case modeZiYin:
        {
            self.lb_content.text = @"金箍棒精选 " ;
            [self setColorStyle:1] ;
        }
            break;
            
        default:
            break;
    }
    

    
    
}

@end
