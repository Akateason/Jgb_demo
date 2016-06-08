//
//  BagNumView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-16.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderProduct.h"


@interface BagNumView : UIView

//  attrs
@property (nonatomic,retain) OrderProduct *product ;

//  views

@property (weak, nonatomic) IBOutlet UIImageView *img_pro;

@property (weak, nonatomic) IBOutlet UILabel *lb_nums;

- (IBAction)productImgClickedAction:(id)sender;

@end
