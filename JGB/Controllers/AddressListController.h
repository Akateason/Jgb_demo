//
//  AddressListController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "AddressCell.h"

@protocol AddressListControllerDelegate <NSObject>

- (void)sendSelectedAddress:(ReceiveAddress *)address ;

@end


@interface AddressListController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL                 isAddOrSelect ;       //NO->add mode , YES->select mode
@property (nonatomic,retain) id <AddressListControllerDelegate> delegate ;

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIButton *bt_addAddr;
- (IBAction)addAddressAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end
