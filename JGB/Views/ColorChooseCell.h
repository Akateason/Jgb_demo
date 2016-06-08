//
//  ColorChooseCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ColorCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView ;
@end



@protocol ColorChooseCellDelegate <NSObject>

- (void)sendKey:(NSString *)key AndSendValue:(NSString *)value ;

@end

@interface ColorChooseCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,retain) id <ColorChooseCellDelegate> delegate              ;
@property (nonatomic,assign) int                          currentIndex          ;
@property (nonatomic,assign) NSDictionary                 *canSelectDic         ;


@property (weak, nonatomic) IBOutlet UILabel              *lb_title             ;
@property (weak, nonatomic) IBOutlet UICollectionView     *colorCollection      ;

@property (nonatomic,retain) NSArray                      *valueArr             ;

@end
