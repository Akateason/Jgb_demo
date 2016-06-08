//
//  CheckOutHeadFoot.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckOutHeadFoot : UIView

//  attrs
@property (nonatomic) BOOL  isShopcarFoot  ;

@property (nonatomic) float showOrNot    ;      //是否显示

@property (nonatomic) float dollarsNeeds ;      //需要多少美元包邮(美元)
@property (nonatomic) float totalBusnessPrice ; //这一单的总价
@property (nonatomic) float compensation ;      //还差多少钱包邮(美元)

@property (nonatomic) float freightUsa   ;      //美国国内运费(人民币)

@property (nonatomic) int bid ;


//  views
@property (weak, nonatomic) IBOutlet UILabel *lb_key;

@property (weak, nonatomic) IBOutlet UILabel *lb_price;

@property (weak, nonatomic) IBOutlet UIView *bgView;

- (instancetype)initWithCoder:(NSCoder *)coder ;


@end
