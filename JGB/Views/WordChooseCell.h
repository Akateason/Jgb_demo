//
//  WordChooseCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewLeftAlignedLayout.h"

#define     WORD_LABEL_FONT     12.0

@interface WordCollectionCell : UICollectionViewCell

@property (weak,nonatomic) IBOutlet UILabel *label ;

@end

@protocol WordChooseCellDelegate <NSObject>

- (void)sendKey:(NSString *)key AndSendValue:(NSString *)value ;

@end

@interface WordChooseCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,retain) id <WordChooseCellDelegate>  delegate              ;
@property (nonatomic,assign) int                          currentIndex          ;
@property (nonatomic,retain) NSDictionary                 *canSelectDic         ;



@property (weak, nonatomic) IBOutlet UILabel              *lb_title             ;
@property (weak, nonatomic) IBOutlet UICollectionView     *WordCollectionView   ;

@property (nonatomic,retain) NSArray                      *valueArr             ;

@end




