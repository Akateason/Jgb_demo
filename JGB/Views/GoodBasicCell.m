//
//  GoodBasicCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-1.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "GoodBasicCell.h"
#import "ImagePlayerView.h"
#import "UIImageView+WebCache.h"

#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "ColorsHeader.h"
#import "WareHouse.h"


@interface GoodBasicCell () <ImagePlayerViewDelegate>
{
    ImagePlayerView *m_ipView ;
}
@end


@implementation GoodBasicCell




- (void)awakeFromNib
{
    // Initialization code
    

    
    self.contentView.backgroundColor = COLOR_BACKGROUND ;
}


- (void)setGoods:(Goods *)goods
{
    _goods = goods ;

//  sroll img view
    int num = _goods.galleries.count ;

    if (! m_ipView)
    {
        m_ipView = [[ImagePlayerView alloc] initWithFrame:_imgPptView.frame] ;
        [_imgPptView insertSubview:m_ipView atIndex:0];
        [_imgPptView setBackgroundColor:[UIColor whiteColor]];
        
        m_ipView.scrollInterval  = 5.0f ;
        m_ipView.hidePageControl = NO   ;
        m_ipView.pageControlPosition = ICPageControlPosition_BottomCenter ;
    }
    
    [m_ipView initWithCount:num delegate:self];

    
//  标题
    BOOL bCnAndEn = _goods.title_en && _goods.title_cn ;
    
    if (bCnAndEn)
    {
        //有中文英文标题
        NSDictionary* style1 = @{ @"black" : [UIColor blackColor] ,
                                  @"red"  : COLOR_PINK ,
                                  @"small": [UIFont systemFontOfSize:14.0f]
                                  } ;
        
        NSString *strAttri   = @""  ;
        
        strAttri = [NSString stringWithFormat:@"<small><black>%@</black> <red>%@</red></small>",_goods.title,_goods.title_en] ;
        
        _lb_title.attributedText = [strAttri attributedStringWithStyleBook:style1];
    }
    else
    {
        //只有一个标题
        _lb_title.text = _goods.title;
        _lb_title.textColor = [UIColor blackColor] ;
    }
    
    
//  来自
//    BOOL bIsThird = !( (goods.seller_id != -1) && (goods.seller_id != 0) ) ; // 是否是第三方商家
    BOOL bIsThird = NO ;
    
    WareHouse *warehouse = [WareHouse getWarehouseWithID:_goods.warehouse_id] ;
    _lb_comeFrom.text = bIsThird ? [NSString stringWithFormat:@"商品来自: %@第三方商家",warehouse.name] : [NSString stringWithFormat:@"商品来自: %@",warehouse.name] ;
    
    
//  链接
    _btLink.hidden = (!_goods.official) ? YES : NO ;
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(int)index
{
    NSURL *url = [NSURL URLWithString:(NSString *)[_goods.galleries objectAtIndex:index]] ;
    [imageView setImageWithURL:url placeholderImage:IMG_LOADPRODUCT AndSaleSize:CGSizeMake(640,640)] ;
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index AndLR:(bool)lr
{
    NSLog(@"%@",lr?@"R":@"L");
    NSLog(@"did tap index = %d", (int)index);
    NSLog(@"tag:%d",imagePlayerView.tag);
    
    
    [self.delegate seeBigImgsWithIndex:index AndWithPicsArray:_goods.galleries] ;
}


- (IBAction)linkButtonPressedAction:(UIButton *)sender
{
    [self.delegate seeLinksWithHtmlStr] ;
}


@end
