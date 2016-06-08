//
//  HotSearchCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-28.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotCollectionCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "HotSearch.h"

#define     WORD_LABEL_FONT     12.0

@protocol HotSearchCellDelegate <NSObject>

- (void)sendHotsearchObj:(HotSearch *)hotsearch ;

@end


@interface HotSearchCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

///properties
//@property (retain,nonatomic) NSArray *contentList ;
@property (nonatomic,retain) NSArray *hotSearchList ;

@property (nonatomic,retain) id <HotSearchCellDelegate> delegate ;

///views
@property (weak, nonatomic) IBOutlet UILabel *lb_title;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *barView;



@end
