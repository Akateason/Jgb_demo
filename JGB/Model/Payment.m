//
//  Payment.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-19.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "Payment.h"
#import "DigitInformation.h"
#import "ServerRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "AliOrder.h"
#import "Order.h"



@implementation Payment

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        
        _idPayment  = [[dic objectForKey:@"id"] intValue] ;
        _userID     = [[dic objectForKey:@"user_id"] intValue] ;
        _type       = [[dic objectForKey:@"type"] intValue] ;
        _domain     = [dic objectForKey:@"domain"] ;
        _price      = [[dic objectForKey:@"price"] floatValue] ;
        _subject    = [dic objectForKey:@"subject"] ;
        _ordersCode = [dic objectForKey:@"orders_code"] ;

        if (![[dic objectForKey:@"trade_code"] isKindOfClass:[NSNull class]])
        {
            _tradeCode = [dic objectForKey:@"trade_code"] ;
        }
        
        _addTime    = [[dic objectForKey:@"add_time"] longLongValue] ;
        _updateTime = [[dic objectForKey:@"update_time"] longLongValue] ;
        _status     = [[dic objectForKey:@"status"] intValue] ;
        _typeName   = [dic objectForKey:@"type_name"] ;
        _notifyUrl  = [dic objectForKey:@"notify_url"] ;
        
    }
    
    
    return self;
}


/*
 *  payment go to pay
 *  @param: orderStr :  订单号
 */
+ (void)goToAliPayWithOrderStr:(NSString *)orderStr
{
    BOOL bPayInTime = [self payInner30MinsWithOrderStr:orderStr] ;
    if (!bPayInTime)
    {
        //  超出时间
        [DigitInformation showWordHudWithTitle:WD_ORDER_OUTOFTIME] ;
        return  ;
    }
    
    //
    //收银台-查询支付流水
    ResultPasel *result = [ServerRequest cashierGetPaymentWithOrderCode:orderStr] ;
    if (result.code != 200)
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK] ;
        return ;
    }
    
    NSDictionary *paymentDic = [((NSDictionary *)result.data) objectForKey:@"payment"] ;
    Payment *payment = [[Payment alloc] initWithDic:paymentDic] ;
    if (payment.status == 2) {//已支付
        [DigitInformation showWordHudWithTitle:WD_ORDER_ALREADYPAY];
        return ;
    }
    //
    AliOrder *aliorder      = [[AliOrder alloc] initWithPayment:payment] ;
    //
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme     = @"alipayJGB"           ;
    
    //将商品信息拼接成字符串
    NSString *orderSpec     = [aliorder description] ;
    NSLog(@"orderSpec = %@",orderSpec)               ;
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(ALI_PRIVATEKEY) ;
    NSString *signedString = [signer signString:orderSpec]  ;
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil     ;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            int resultStatus = 0 ;
            resultStatus = [[resultDic objectForKey:@"resultStatus"] intValue] ;
            if (resultStatus == 9000)
            {
                //支付成功
                NSLog(@"支付成功") ;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAY_SUCCESS object:nil] ;
            }
            else
            {
                //支付失败
                NSLog(@"支付失败") ;
                [DigitInformation showWordHudWithTitle:WD_PAY_FAILURE] ;
            }
        }] ;
        
    }

}


+ (BOOL)payInner30MinsWithOrderStr:(NSString *)orderStr
{
    NSDictionary *dic = [ServerRequest getOrderDetailWithOrderID:orderStr] ;
    int code          = [[dic objectForKey:@"code"] intValue]               ;
    if (code == 200)
    {
        NSDictionary *dataDic   = [dic objectForKey:@"data"]              ;
        
        // order
        Order *newOrder         = [[Order alloc] initWithDictionary:dataDic]    ;
        if (newOrder.orderInfo.status == 1)
        {
            return YES ;    //待付款
        }
    }
    
    return NO ;
}



@end
