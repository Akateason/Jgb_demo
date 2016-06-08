//
//  SaleCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-27.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleIndex.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@interface SaleCell : UITableViewCell
//  attrs
@property (nonatomic,retain)        SaleIndex *saleObj ;    //obj


//  views
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;

@property (weak, nonatomic) IBOutlet UIView *bgView_NoStart;
@property (weak, nonatomic) IBOutlet UIView *startCornerView;
@property (weak, nonatomic) IBOutlet UILabel *lb_willStart;




@property (weak, nonatomic) IBOutlet UILabel *lb_words;
@property (weak, nonatomic) IBOutlet UIImageView *img_mask;



@end
