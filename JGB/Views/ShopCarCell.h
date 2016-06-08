//
//  ShopCarCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepTfView.h"
#import "ShopCarGood.h"
#import "CheckOutHeadFoot.h"

@protocol ShopCarCellDelegate <NSObject>

/*
 * section     :    传递 哪个section的cell
 * row         :    传递 section中哪个row的cell
 * isSelect   :    yes选  no取消选
 **/
- (void)sendTheCellSection:(int)section
                AndWithRow:(int)row
           AndWithIsSelect:(BOOL)isSelect;



/*
 * send shopcarGood When Click Product Pictures
 */
- (void)sendShopCarGoodWhenClickProductPictures:(ShopCarGood *)shopcarGood ;


@end


@interface ShopCarCell : UITableViewCell

//1  attrs
//shopcarGood
@property (nonatomic,retain) ShopCarGood  *shopCarG ;

//delegate
@property (nonatomic,retain) id<ShopCarCellDelegate> delegate ;

//控制checkbox 是否选中 是否勾选着
@property (nonatomic,assign) BOOL isSelected ;

//是否编辑状态
@property (nonatomic)        BOOL isEdited ;

//是否加购
@property (nonatomic)        BOOL isAddedOn ;

//是否有footer
@property (nonatomic)        BOOL isLastFooter ;

//cell属性
@property (nonatomic)        int  section   ;
@property (nonatomic)        int  row       ;

//商品是否失效 YES -- 失效 , NO -- 正常
@property (nonatomic)        BOOL isLoseEfficient ;


//2  views

@property (weak, nonatomic) IBOutlet UILabel *lb_loseEfficient;//失效

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_detail;
@property (weak, nonatomic) IBOutlet UILabel *lb_price;
@property (weak, nonatomic) IBOutlet UILabel *lb_number;

@property (weak, nonatomic) IBOutlet StepTfView *stepView;

@property (weak, nonatomic) IBOutlet UIImageView *img_goods;

@property (weak, nonatomic) IBOutlet UIImageView *img_check;

@property (weak, nonatomic) IBOutlet UIButton *bt_check;

- (IBAction)checkPressed:(id)sender;

- (IBAction)proPicClickedAction:(id)sender;

//@property (weak, nonatomic) IBOutlet CheckOutHeadFoot *footerView;

@property (weak, nonatomic) IBOutlet UILabel *lb_isAddon; //是否加购


@end
