//
//  LikeCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeProduct.h"


@interface LikeCell : UITableViewCell

//properties
@property (weak,nonatomic)  LikeProduct             *likePro ;

//views
@property (weak, nonatomic) IBOutlet UIImageView    *img_good;

@property (weak, nonatomic) IBOutlet UILabel        *lb_name;//商品名臣

//@property (weak, nonatomic) IBOutlet UILabel        *lb_onSale;//距收藏降价
//
//@property (weak, nonatomic) IBOutlet UILabel        *lb_likeTime;//收藏时间

@end
