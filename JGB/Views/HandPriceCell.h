//
//  HandPriceCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"

@interface HandPriceCell : UITableViewCell

//  attrs

@property (nonatomic,retain)    Goods           *good ;
@property (nonatomic,copy)      NSString        *predictTime ;// 从哪里发货, 预计到达时间
@property (nonatomic)           BOOL            checkPriceFinished ;
@property (nonatomic)           BOOL            selectedProducts  ;     //是否已选择过尺码?


//  views
//到手价
@property (weak, nonatomic) IBOutlet UILabel *t_inHandPrice;//title到手价
@property (weak, nonatomic) IBOutlet UILabel *lb_inHandPrice;//到手价

//售价
@property (weak, nonatomic) IBOutlet UILabel *t_salePrice;
@property (weak, nonatomic) IBOutlet UILabel *lb_salePrice;

//折扣
@property (weak, nonatomic) IBOutlet UILabel *t_zhekou;//title折扣
@property (weak, nonatomic) IBOutlet UILabel *lb_zhekou_orgPrice;//折扣,原价

//发货送达
@property (weak, nonatomic) IBOutlet UILabel *lb_comeFrom;//由发货,约送达

//loading
@property (weak, nonatomic) IBOutlet UIImageView *img_loading ;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceRightFlex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountFlex;

@property (weak, nonatomic) IBOutlet UIView *contain1;

@property (weak, nonatomic) IBOutlet UIView *contain2;

@end
