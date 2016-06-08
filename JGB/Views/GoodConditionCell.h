//
//  GoodConditionCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionSubView.h"

@protocol GoodConditionCellDelegate <NSObject>

- (void)addShopCarCallBack ;

@end


@interface GoodConditionCell : UITableViewCell

//  attrs
@property (nonatomic,retain) id <GoodConditionCellDelegate> delegate ;

/*
 *  isSelfSupport -- 是否自营
 *  default is NO
 */
@property (nonatomic)       BOOL    isSelfSupport ;

//  是否关闭加入购物车按钮
@property (nonatomic)       BOOL    isOpenShutdownShopCarButton ;


//  views
@property (weak, nonatomic) IBOutlet UIButton *bt_addshopCar;
- (IBAction)addShopCarAction:(id)sender;

//  monkey
@property (weak, nonatomic) IBOutlet UIImageView *img_monkey;

//
@property (strong, nonatomic) IBOutletCollection(ConditionSubView) NSArray *subConditionViewList;



@end
