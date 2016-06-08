//
//  Score.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
typedef enum
{
    CREDIT_OPT_PAY                 = 1, 	//  购物支付
    CREDIT_OPT_VERIFYORDER         = 11,	//  确认订单获得积分
    CREDIT_OPT_COMMENT             = 12,	//  发表评论获得积分
    CREDIT_OPT_COMMENT_USEFUL      = 13,	//  有用的评论
    CREDIT_OPT_COMMENT_PHOTO       = 14,	//  晒单的评论
    CREDIT_OPT_CANCEL_ORDER        = 15,	//  取消订单
    CREDIT_OPT_REGISTER            = 16,    //  注册
    CREDIT_OPT_ADMIN               = 21,	//  管理员赠送积分
    COMMENT_SCORE                  = 100,	//  评论积分
    COMMENT_USEFUL_SCORE           = 300,	//  有用的评论积分
    COMMENT_PHOTO_SCORE            = 500,	//  晒单积分
}  scoreMode ;
*/

#define CREDIT_PROPORTION           0.01	//  积分抵扣现金比率


@interface Score : NSObject

@property (nonatomic)           int         scoreID ;
@property (nonatomic)           int         uid     ;
@property (nonatomic,copy)      NSString    *opt     ;   //option scoreMode
@property (nonatomic)           int         credit  ;

@property (nonatomic)           long long   atime   ;

- (instancetype)initWithDic:(NSDictionary *)dic     ;

//+ (NSString *)getScoreModeStringWithMode:(scoreMode)mode ;

@end
