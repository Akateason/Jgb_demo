//
//  BannerCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-30.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "BannerCell.h"
#import "ImagePlayerView.h"
#import "UIImageView+WebCache.h"
#import "ColorsHeader.h"
#import "SaleIndex.h"

@interface BannerCell ()<ImagePlayerViewDelegate>
{
    ImagePlayerView *m_ipView ;
}

@end

@implementation BannerCell

- (void)awakeFromNib
{
    // Initialization code
    if (! m_ipView)
    {
        m_ipView = [[ImagePlayerView alloc] initWithFrame:self.frame] ;
        [self.contentView insertSubview:m_ipView atIndex:0];
        
        m_ipView.scrollInterval  = 5.0f ;
        m_ipView.hidePageControl = NO   ;
        m_ipView.pageControlPosition = ICPageControlPosition_BottomCenter ;
    }
    
}

#pragma mark --
#pragma mark - setter
- (void)setBannerList:(NSArray *)bannerList
{
    _bannerList = bannerList ;
    
    int num = _bannerList.count ;
    [m_ipView initWithCount:num delegate:self];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(int)index
{
    SaleIndex *sale = _bannerList[index] ;
    NSURL *url = [NSURL URLWithString:sale.images] ;
    [imageView setImageWithURL:url placeholderImage:IMG_LOADPRODUCT AndSaleSize:CGSizeMake(640,270)] ;
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index AndLR:(bool)lr
{
    NSLog(@"%@",lr?@"R":@"L");
    NSLog(@"did tap index = %d", (int)index);
    NSLog(@"tag:%d",imagePlayerView.tag);
    
    SaleIndex *sale = _bannerList[index] ;

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_INDEXFIRST object:sale] ;
}


@end
