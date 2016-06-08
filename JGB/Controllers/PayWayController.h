//
//  PayWayController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "Payway.h"


@interface PayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end

@protocol PayWayControllerDelegate <NSObject>

- (void)sendPayWayList:(NSArray *)list ;

@end

@interface PayWayController : RootCtrl<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,retain) NSArray *paywayList ;
@property (nonatomic,retain) id <PayWayControllerDelegate> delegate ;



@property (weak, nonatomic) IBOutlet UITableView *table;




@end
