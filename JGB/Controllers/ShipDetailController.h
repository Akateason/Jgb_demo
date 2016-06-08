//
//  ShipDetailController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-14.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "Bag.h"
#import "Parcel.h"

@interface ShipDetailController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

//  attrs

@property (nonatomic)        int        parcelID        ;
@property (nonatomic)        int        bagID           ;
@property (nonatomic,copy)   NSString   *oid            ;   //parcel oid

//  views
@property (weak, nonatomic) IBOutlet UITableView *table ;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *bt_Multi;
- (IBAction)buttonClickAction:(id)sender;

@end
