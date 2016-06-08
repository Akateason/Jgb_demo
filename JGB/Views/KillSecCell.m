//
//  KillSecCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-30.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "KillSecCell.h"
#import "ColorsHeader.h"
#import "TimeCountView.h"
#import "KillView.h"

@interface KillSecCell ()

@property (weak, nonatomic)     IBOutlet UILabel *lb_ttms ;

@property (weak, nonatomic)     IBOutlet UILabel *lb_ttms_descrip  ;

@property (weak, nonatomic)     IBOutlet KillView *killContentView ; // 放三个区域

@property (strong, nonatomic)   IBOutletCollection(KillView) NSArray *killViewList ; // killview collection

@end

@implementation KillSecCell



- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    [self viewStyle] ;
    
}

- (void)viewStyle
{
    _lb_ttms.textColor = COLOR_PINK ;
    _lb_ttms_descrip.textColor = [UIColor darkGrayColor] ;
    
    _killContentView.backgroundColor = COLOR_BACKGROUND ;
}

#pragma mark --
#pragma mark -
- (void)setPromotionList:(NSArray *)promotionList
{
    _promotionList = promotionList ;
    
    if (promotionList.count == 0) return ;
    
    for (int i = 0; i < promotionList.count; i++)
    {
        Promotiom *promotion = promotionList[i] ;
        KillView *killV = _killViewList[i] ;
        killV.myPromot = promotion ;
        if (i == 2) break ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
