//
//  SecCataCollectionCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-29.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "SecCataCollectionCell.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "SalesCatagory.h"

@implementation SecCataCollectionCell

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    [TeaCornerView setRoundHeadPicWithView:self.lb] ;
    
}




@end
