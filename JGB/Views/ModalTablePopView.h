//
//  ModalTablePopView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressageDetail.h"
#import "Seller.h"

@protocol ModalTablePopViewDelegate <NSObject>

- (void)clickOutSide ;

@end


@interface ModalTablePopView : UIView <UITableViewDataSource,UITableViewDelegate>

//  attrs

@property (nonatomic,retain) id <ModalTablePopViewDelegate> delegate ;

@property (nonatomic,retain) NSMutableArray     *data_priceDetail ;
@property (nonatomic,retain) ExpressageDetail   *expressDetail ;
@property (nonatomic)        BOOL               isSelfSales ; //是否自营
@property (nonatomic)        BOOL               isAddAmazon ; //是否加购
@property (nonatomic,retain) Seller             *seller ;


/********************
 *  is Exdetail Cell
 *  true    :
 *  false   :
 ********************
 */
//@property (nonatomic)        BOOL   isExdetailCell ;

//  views

@property (weak, nonatomic) IBOutlet UIButton *bgButton;

@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)tapAction:(id)sender;

@end
