//
//  CataSecTrdCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-7.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "CataSecTrdCell.h"
#import "SecCataCollectionCell.h"
#import "ColorsHeader.h"

@interface CataSecTrdCell ()
{
    NSArray *m_colorList ;
}
@end

@implementation CataSecTrdCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    m_colorList = @[COLOR_CATA_1,COLOR_CATA_2,COLOR_CATA_3,COLOR_CATA_4] ;
    
    _collection.delegate = self ;
    _collection.dataSource = self ;
    
    _collection.backgroundColor = nil ; //[UIColor whiteColor] ;
}

- (void)setCataList:(NSArray *)cataList
{
    _cataList = cataList ;
    
    int lines = (cataList.count % 3 == 0) ? cataList.count / 3 : (cataList.count / 3 + 1) ;
    self.collectionHeight.constant = lines * 70.0f ;
    
}

- (void)setSec:(int)sec
{
    _sec = sec ;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
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
    return [_cataList count] ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up the reuse identifier
    UINib *nib = [UINib nibWithNibName:@"SecCataCollectionCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"SecCataCollectionCell"];
    
    // Set up the reuse identifier
    SecCataCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"SecCataCollectionCell" forIndexPath:indexPath];

    // load the image for this cell
    SalesCatagory *cata = (SalesCatagory *)[_cataList objectAtIndex:indexPath.row]   ;
    cell.lb.text = cata.name ;
  
    int colorIndex = _sec % 4 ;
    cell.lb.backgroundColor = m_colorList[colorIndex] ;
    
    //    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",cata.id_]] ;
    //    cell.img.contentMode = UIViewContentModeScaleAspectFit  ;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SalesCatagory *selectSecCata = (SalesCatagory *)[_cataList objectAtIndex:indexPath.row]   ;
    
    NSLog(@"selectSecCata : %@",selectSecCata.name) ;
    
    [self.delegate pressedCataCallBack:selectSecCata] ;
    
    //    [self performSegueWithIdentifier:@"cataSec2cataSub" sender:selectSecCata] ;
}




@end
