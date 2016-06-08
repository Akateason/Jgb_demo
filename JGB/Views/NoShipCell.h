//
//  NoShipCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinkButton.h"

@protocol NoShipCellDelegate <NSObject>
//点击查看包裹详情
- (void)sendIndexPath:(NSIndexPath *)ip ;

//签收包裹
- (void)signInBags:(NSIndexPath *)ip ;

@end


@interface NoShipCell : UITableViewCell

//  attrs

@property (nonatomic,retain)   NSArray *proArray ;      // 包裹中得商品list

@property (nonatomic)        BOOL        isBag      ;

@property (nonatomic)        BOOL        isGetBag   ; //是否确认收货

@property (nonatomic,retain) NSIndexPath *indexPath ;

@property (nonatomic,retain) id <NoShipCellDelegate> delegate ;

//  (style)是否能选择
@property (nonatomic,assign)BOOL     isCanSelect ;




//  views
@property (weak, nonatomic) IBOutlet UILabel *lb_bagName;

@property (weak, nonatomic) IBOutlet UIScrollView *smallScrolls;



@property (weak, nonatomic) IBOutlet UIButton *bt_clicked;
- (IBAction)clickedAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *img_rightArrow;

//签收包裹
@property (weak, nonatomic) IBOutlet UIButton *bt_signIn;
- (IBAction)signinPressedAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lb_signIn;


@end
