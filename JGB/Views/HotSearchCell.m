//
//  HotSearchCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "HotSearchCell.h"
#import "ColorsHeader.h"

@implementation HotSearchCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    _collectionView.collectionViewLayout = layout ;

    _barView.backgroundColor = COLOR_BACKGROUND ;
    
    _collectionView.delegate = self ;
    _collectionView.dataSource = self ;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark --
#pragma mark - collection dataSourse
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%@",wordName) ;

    HotSearch *hotsch = (HotSearch *)_hotSearchList[indexPath.row] ;
    NSString *wordName = hotsch.name ;
    
    UIFont *font = [UIFont systemFontOfSize:WORD_LABEL_FONT];
    CGSize size = CGSizeMake(291,20);
    CGSize labelsize = [wordName sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    CGSize newSize = CGSizeMake(labelsize.width + 16 , 20) ;
    
    return newSize;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_collectionView performBatchUpdates:nil completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hotSearchList.count ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the reuse identifier
    UINib *nib = [UINib nibWithNibName:@"HotCollectionCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"HotCollectionCell"];
    
    // Set up the reuse identifier
    HotCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HotCollectionCell" forIndexPath:indexPath];
    
    // load the image for this cell
    HotSearch *hotsch = (HotSearch *)_hotSearchList[indexPath.row] ;
    NSString *wordName = hotsch.name ;
    cell.lb_word.text  = wordName ;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotSearch *hotsch = (HotSearch *)_hotSearchList[indexPath.row] ;

    NSLog(@"selecetd wordName : %@",hotsch.name) ;
    
    [self.delegate sendHotsearchObj:hotsch] ;
}




@end
