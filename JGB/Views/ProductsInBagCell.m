//
//  ProductsInBagCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-26.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "ProductsInBagCell.h"
#import "ColorsHeader.h"
#import "OrderProduct.h"
#import "BagNumView.h"
#import "UIImageView+WebCache.h"


@implementation ProductsInBagCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setProArray:(NSArray *)proArray
{
    _proArray       = proArray ;
    
    //  draw bags products scrolls
    float flexWidth = 60.0f ;
    int nums        =  0.0f ;
    for (int i = 0; i < [proArray count]; i ++ )
    {
        OrderProduct *proTemp = (OrderProduct *)[proArray objectAtIndex:i] ;
        
        BagNumView *bagView = (BagNumView *)[[[NSBundle mainBundle] loadNibNamed:@"BagNumView" owner:self options:nil] lastObject];
        bagView.frame = CGRectMake(i * flexWidth, 0, bagView.frame.size.width, bagView.frame.size.height) ;
        bagView.product = proTemp ;
        
        [_scrollView addSubview:bagView] ;
        
        nums ++ ;
    }
    
    _scrollView.contentSize   = CGSizeMake(flexWidth * nums, 62) ;
}


@end
