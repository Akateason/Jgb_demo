//
//  CataSecTrdCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-7.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesCatagory.h"


@protocol CataSecTrdCellDelegate <NSObject>

- (void)pressedCataCallBack:(SalesCatagory *)cata ;

@end

@interface CataSecTrdCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate>

//attrs
@property (nonatomic,retain) NSArray *cataList ;
@property (nonatomic,retain) id <CataSecTrdCellDelegate> delegate ;
@property (nonatomic)        int     sec ;

//views
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@end
