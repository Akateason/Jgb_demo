//
//  UserHeadCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-9.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "UserHeadCell.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "DigitInformation.h"
#import "UIImageView+WebCache.h"

@implementation UserHeadCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib] ;
    
    [TeaCornerView setRoundHeadPicWithView:self.imgView] ;
    
}

- (void)setImgPhotoOver:(UIImage *)imgPhotoOver
{
    _imgPhotoOver = imgPhotoOver ;

    self.imgView.image = _imgPhotoOver ;
}

- (void)setStrImgs:(NSString *)strImgs
{
    _strImgs = strImgs ;
    
    if (!_imgPhotoOver)
    {
        [self.imgView setImageWithURL:[NSURL URLWithString:strImgs] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(_imgView.frame.size.width*2, _imgView.frame.size.height*2)] ;

    }
        

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)tagImg:(id)sender
{
    [self.delegate pressUserHeadPictureCallBack] ;
}


@end
