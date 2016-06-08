//
//  ColorChooseCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ColorChooseCell.h"
#import "UIImageView+WebCache.h"
#import "DigitInformation.h"
#import "ColorsHeader.h"


#define STR_ARROWS              @"-->"



@implementation ColorCollectionCell


@end


@implementation ColorChooseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    _colorCollection.backgroundColor = [UIColor whiteColor] ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark --
#pragma mark - collection dataSourse

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _valueArr.count ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the reuse identifier
    ColorCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"ColorCollectionCell"
                                                                          forIndexPath:indexPath];
    // load the image for this cell
    if ([_valueArr[indexPath.row] isKindOfClass:[NSArray class]]) {
        NSString *path = [(_valueArr[indexPath.row]) lastObject] ;
        [cell.imgView setIndexImageWithURL:[NSURL URLWithString:path] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(40*2, 40*2)] ;
    }

    //    [cell.imgView setImageWithURL:[NSURL URLWithString:path] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(40*2, 40*2)] ;
    cell.imgView.contentMode = UIViewContentModeScaleAspectFit  ;
    
    UIColor *normalColor = [UIColor lightGrayColor] ;

    cell.layer.cornerRadius  = CORNER_RADIUS_ALL                ;
    cell.layer.borderWidth   = 1.0                              ;
    cell.layer.borderColor   = normalColor.CGColor              ;   //最普通的,能够选择
    
//    
    NSString *mykey = _lb_title.text ;
    if ( (_canSelectDic.count) && (_canSelectDic != nil) )
    {
        // can not be select
        cell.alpha = 0.25f ;

        for (NSString *theKey in _canSelectDic)
        {
            if ([theKey isEqualToString:mykey])
            {
                if ([(_valueArr[indexPath.row]) isKindOfClass:[NSString class]]) {
                    continue ;
                }
                NSString *val = [(_valueArr[indexPath.row]) firstObject] ; //当前格子里的颜色name
                
                NSArray *valArr = [_canSelectDic objectForKey:mykey] ;
                for (NSString *valStr in valArr)
                {
                    if ([val isEqualToString:valStr])
                    {
                        // can select , 能够选择
                        cell.layer.borderColor = normalColor.CGColor ;
                        cell.alpha             = 1.0f                ;
                    }
                }
            }
        }
    }
    
//
    if (indexPath.row == _currentIndex) {
        //already selected
        cell.layer.borderColor = COLOR_PINK.CGColor ;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_valueArr[indexPath.row] isKindOfClass:[NSArray class]]) return ;
    
    
    NSString *colorName = [(_valueArr[indexPath.row]) firstObject];
    
    _currentIndex = indexPath.row ;
    
    [self.delegate sendKey:_lb_title.text AndSendValue:colorName] ;
}



@end
