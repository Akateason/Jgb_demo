//
//  BagConditionHeader.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-25.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bag.h"

@protocol BagConditionHeaderDelegate <NSObject>

- (void)seeShipDetailCallBack:(int)section ;

- (void)signInOrComment:(int)section ;

@end



@interface BagConditionHeader : UIView

@property (nonatomic,retain) id <BagConditionHeaderDelegate> delegate ;

@property (nonatomic,retain) Bag *abag ;

@property (nonatomic)        int section ;

@end
