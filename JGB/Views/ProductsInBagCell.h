//
//  ProductsInBagCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-26.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductsInBagCell : UITableViewCell


@property (nonatomic,retain)   NSArray *proArray ;      // 包裹中得商品list

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
