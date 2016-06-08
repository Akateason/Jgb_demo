//
//  SearchViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySearchBar.h"
#import "SelectGoodCell.h"
#import "HMSegmentedControl.h"
#import "RootCtrl.h"
#import "EGORefreshTableFooterView.h"
#import "SalesCatagory.h"
#import "HotSearch.h"

@interface CurrentSort : NSObject

@property (nonatomic) int page ;
@property (nonatomic) int size ;
@property (nonatomic,copy)  NSString *sellerID      ;
@property (nonatomic,copy)  NSString *title         ;
@property (nonatomic,copy)  NSString *brand         ;
@property (nonatomic,copy)  NSString *catagory      ;
@property (nonatomic) float lowPrice    ;
@property (nonatomic) float highPrice   ;
@property (nonatomic) int orderVal ;
@property (nonatomic) int orderWay ;
@property (nonatomic) int is_cn    ;        //中文说明
@property (nonatomic) int is_cx    ;        //促销
@property (nonatomic) int wareHouse_ID              ;

- (instancetype)initWithPage:(int)page
                 AndWithSize:(int)size
             AndWithSellerID:(NSString *)seller_id
                AndWithTitle:(NSString *)title
                AndWithBrand:(NSString *)brand
             AndWithCategory:(NSString *)category
             AndWithLowPrice:(float)low_price
            AndWithHighPrice:(float)hig_price
             AndWithOrderVal:(int)order_val
             AndWithOrderWay:(int)order_way
                   AndWithCN:(int)isCN
                   AndWithCX:(int)isCX
          AndWithWareHouseID:(int)wareHouseID ;

- (void)shiftMode:(NSString *)shiftMode ;

@end

//@"默认", @"价格 ↓",@"好评 ↓"
//asc升序↑, des降序↓
#define SEG_WD_DEFAULT  @"默认"
#define SEG_WD_PRI_DES  @"价格 ↓"
#define SEG_WD_PRI_ASC  @"价格 ↑"
#define SEG_WD_CMT_DES  @"好评 ↓"
#define SEG_WD_CMT_ASC  @"好评 ↑"


// 商品列表
@interface SearchViewController : RootCtrl<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableFooterDelegate>
{
    EGORefreshTableFooterView *refreshView;
    BOOL reloading;
}

//传入, 当前第三级分类
@property (nonatomic,retain) SalesCatagory *myCata ;
//传入, 搜索文字
@property (nonatomic,copy)   NSString      *strBeSearch ;
//传入, 热刺
@property (nonatomic,retain) HotSearch     *hotSearch ;




@property (weak, nonatomic) IBOutlet UITableView *tableCategory;            //goods category and goods result



@end





