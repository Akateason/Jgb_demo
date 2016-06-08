//
//  GoodBasicCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-1.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"

@protocol GoodBasicCellDelegate <NSObject>

- (void)seeBigImgsWithIndex:(int)index AndWithPicsArray:(NSArray *)picArray ;   //看商品大图

- (void)seeLinksWithHtmlStr ;

@end


@interface GoodBasicCell : UITableViewCell

//  properties
@property (nonatomic,retain) Goods              *goods ;
@property (nonatomic,retain) id <GoodBasicCellDelegate> delegate ;


//  views
//1
//商品轮播图 view
@property (weak, nonatomic) IBOutlet UIView     *imgPptView;
//2
//商品名称
@property (weak, nonatomic) IBOutlet UILabel    *lb_title;
//来自
@property (weak, nonatomic) IBOutlet UILabel    *lb_comeFrom;
//美亚链接
@property (weak, nonatomic) IBOutlet UIButton   *btLink;
- (IBAction)linkButtonPressedAction:(UIButton *)sender;


@end
