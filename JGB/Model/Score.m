//
//  Score.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Score.h"

@implementation Score

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        
        _scoreID = [[dic objectForKey:@"id"] intValue] ;
        _uid     = [[dic objectForKey:@"uid"] intValue] ;
        
        if (![[dic objectForKey:@"opt"] isKindOfClass:[NSNull class]])
        {
            _opt     = [dic objectForKey:@"opt"] ;
        }
        else
        {
            _opt = @"" ;
        }
        
        _credit  = [[dic objectForKey:@"credit"] intValue] ;
        _atime   = [[dic objectForKey:@"atime"] longLongValue] ;
        
    }
    
    return self;
}

/*
+ (NSString *)getScoreModeStringWithMode:(scoreMode)mode
{
    NSString *tempStr = @"" ;
    
    switch (mode)
    {
        case CREDIT_OPT_PAY:
        {
            tempStr = @"购物支付" ;
        }
            break;
        case CREDIT_OPT_VERIFYORDER:
        {
            tempStr = @"确认订单获得积分" ;
        }
            break;
        case CREDIT_OPT_COMMENT:
        {
            tempStr = @"发表评论获得积分" ;
        }
            break;
        case CREDIT_OPT_COMMENT_USEFUL:
        {
            tempStr = @"有用的评论" ;
        }
            break;
        case CREDIT_OPT_COMMENT_PHOTO:
        {
            tempStr = @"晒单的评论" ;
        }
            break;
        case CREDIT_OPT_CANCEL_ORDER:
        {
            tempStr = @"取消订单" ;
        }
            break;
        case CREDIT_OPT_ADMIN:
        {
            tempStr = @"管理员赠送积分" ;
        }
            break;
        case COMMENT_SCORE:
        {
            tempStr = @"评论积分" ;
        }
            break;
        case COMMENT_USEFUL_SCORE:
        {
            tempStr = @"有用的评论积分" ;
        }
            break;
        case COMMENT_PHOTO_SCORE:
        {
            tempStr = @"晒单积分" ;
        }
            break;
        case CREDIT_OPT_REGISTER:
        {
            tempStr = @"用户注册" ;
        }
            break;
            
        default:
            break;
    }
    
    
    return tempStr ;
}
*/

@end
