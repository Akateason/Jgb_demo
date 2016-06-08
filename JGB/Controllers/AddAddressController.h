//
//  AddAddressController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "ReceiveAddress.h"


@interface AddAddressController : RootCtrl

@property (nonatomic,retain)ReceiveAddress *myAddr ;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *bt_setDefault;
- (IBAction)defaultAddressPressedAction:(UIButton *)sender;

@end
