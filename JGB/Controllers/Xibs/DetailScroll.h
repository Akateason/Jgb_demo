//
//  DetailScroll.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#define NOTIFICATION_GOODDETAIL_DISMISS     @"NOTIFICATION_GOODDETAIL_DISMISS"

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"
#import "GoodCommentCell.h"
#import "SmallStarView.h"
#import "Goods.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import                 "WeiboSDK.h"

@protocol DetailScrollDelegate <NSObject>

- (void)addToShopCarWithGoods:(Goods *)good ;                                                         // 加入购物车

//选择商品分类 颜色
- (void)chooseGoodsCatagoryWithAttr:(NSDictionary *)attr
                   AndWithAttribute:(NSDictionary *)attribute
                       AndWithGoods:(Goods *)good
                     AndWithBuyNums:(int)buyNums                ;

- (void)buyNowWithGoods:(Goods *)good AndWithBuyNums:(int)buyNums  ;


- (void)seeGoodsDescriptionWithHTMLstr:(NSString *)str ;                        // 看 商品详情

- (void)seeMoreCommentOfGood ;                                                  //查看更多评论 (商品)

- (void)seeBigImgsWithIndex:(int)index AndWithPicsArray:(NSArray *)picArray ;   //看商品大图

- (void)goInPushGoodDetail:(Goods *)good ;                                      //你可能喜欢的商品

- (void)iWantShareThisGood:(Goods *)good ;                                      //分享商品

- (void)nothingPicShow ;

- (void)nothingPicHide ;

@end



@interface DetailScroll : UIView <ImagePlayerViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,retain)Goods           *m_goods     ;


@property (nonatomic,assign) int            m_buyNums ;   //购买数量


@property (nonatomic,copy)  NSString        *code ;     //

@property (nonatomic,retain)NSDictionary    *attr ;     //

@property (nonatomic,retain) id <DetailScrollDelegate> delegate ;

//1.goods photo scroll
@property (weak, nonatomic) IBOutlet UIView *goodsPhotoScroll;

@property (weak, nonatomic) IBOutlet UIView *goodsBar;

@property (weak, nonatomic) IBOutlet UILabel *lb_goodsTitle;

@property (weak, nonatomic) IBOutlet UIButton *likeBut;

//喜欢action
- (IBAction)ilikeOrNot:(id)sender;
//分享action
- (IBAction)share:(id)sender;


//2.prepare view
@property (weak, nonatomic) IBOutlet UIView  *prepareView;
@property (weak, nonatomic) IBOutlet UILabel *lb_getPrice;//到手价
@property (weak, nonatomic) IBOutlet UILabel *lb_orgPrice;//原价
@property (weak, nonatomic) IBOutlet UILabel *lb_saveMoney;//立省100院

@property (weak, nonatomic) IBOutlet UIImageView *img_fromWhere;//来自亚马逊img
@property (weak, nonatomic) IBOutlet UILabel *lb_daoshoujia;

@property (weak, nonatomic) IBOutlet UILabel *lb_howLong_arrive;//哪里发货,几天到达
@property (weak, nonatomic) IBOutlet UILabel *lb_exchangeRate;//汇率

@property (weak, nonatomic) IBOutlet UIView *view_goodsPropertys;//属性view(正品,海外直发,极速)

//购物车button
- (void)shopCarPressedAction ;
- (void)buyNowPressedAction ;


//3 商品信息 累计评价
@property (weak, nonatomic) IBOutlet UITableView        *table_shopInfoAndComment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_tableHeight;


//4 你可能喜欢的商品
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_goods;



//5 底部 加入购物车栏
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_img;
@property (weak, nonatomic) IBOutlet UILabel *lb_bottomPrice;
@property (weak, nonatomic) IBOutlet UILabel *lb_bottomSave;


//6 stars
@property (weak, nonatomic) IBOutlet SmallStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *lb_starLevel;
@property (weak, nonatomic) IBOutlet UILabel *lb_commentNum;

//7check price UI
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_checkPrice;
@property (weak, nonatomic) IBOutlet UILabel *lb_checkingPrice;



@end
