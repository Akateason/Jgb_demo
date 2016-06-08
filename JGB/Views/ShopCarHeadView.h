//
//  ShopCarHeadView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goods.h"

@protocol ShopCarHeadViewDelegate <NSObject>

/*
 * section     :    传递 哪个section的headview
 * allselect   :    yes全选  no取消全选
**/
- (void)sendTheSelectedSection:(int)section AndWithAllSelect:(BOOL)allSelect;


//编辑所属商家的购买数量
- (void)editBuyNumWithSection:(int)section AndWithEditOrNot:(BOOL)b ;


@end

//--------------------------------------------------------//

@interface ShopCarHeadView : UIView

//attributes
@property (nonatomic)   BOOL    isAllHead ;



//views

@property (nonatomic,assign) int  section    ; //表示哪个section的headview
@property (nonatomic,assign) BOOL isSelected ; //check box 是否选中
@property (nonatomic,retain) id <ShopCarHeadViewDelegate> delegate ;

@property (nonatomic)        BOOL isEdited ;

//--------------------------------------------------------//

@property (weak, nonatomic) IBOutlet UIImageView *img_checkBox;//checkbox
@property (weak, nonatomic) IBOutlet UILabel *lb_orgShop;//发货地,厂商

@property (weak, nonatomic) IBOutlet UIButton *bt_check;


@property (weak, nonatomic) IBOutlet UIButton *bt_edit;

- (IBAction)editAction:(id)sender;

- (IBAction)checkPressedAction:(id)sender;


@end
