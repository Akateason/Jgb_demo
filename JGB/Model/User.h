//
//  User.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboUser.h"

@interface User : NSObject

@property (nonatomic,copy)      NSString *imageUrl ;    //第三方用户头像

@property (nonatomic,assign)    int      uid;           //用户 UID
@property (nonatomic,copy)      NSString *login ;       //用户邮箱
@property (nonatomic,copy)      NSString *nickName ;    //昵称        uname
@property (nonatomic,assign)    int      sex;           //性别        0未知, 1男, 2女
@property (nonatomic,copy)      NSString *location ;    //所在省市的字符串
@property (nonatomic,assign)    int      province ;     //省ID
@property (nonatomic,assign)    int      city;          //城市ID
@property (nonatomic,assign)    int      area ;         //地区ID
@property (nonatomic,assign)    int      is_audit;      //是否通过审核: 0-未通过, 1-已通过
@property (nonatomic,assign)    int      is_active;     //是否已激活 1：激活、0：未激活
@property (nonatomic,assign)    int      score;         //积分
@property (nonatomic,assign)    int      gold;          //金币

@property (nonatomic,retain)    NSArray  *countList;    //用户统计数据(根据实际有增)：
                                                        //question：问题数
                                                        //answer：回答数
                                                        //question_thanks：数量赞数


@property (nonatomic,retain)    NSArray  *follow;       //用户关注列表（多维）
                                                         //Q：关注的问题ID
                                                         //U：关注的用户ID
                                                         //P : 关注的商品ID
                                                         //

@property (nonatomic,retain)    NSArray  *fans;          //粉丝
@property (nonatomic,retain)    NSArray  *account;       //第三方账号列表
@property (nonatomic,retain)    NSString  *avatar;        //头像




@property (nonatomic,copy)      NSString *accountName ; //账号明
@property (nonatomic,copy)      NSString *password ;    //密码
@property (nonatomic,copy)      NSString *realName ;    //真实姓名
@property (nonatomic,copy)      NSString *email ;       //邮箱
@property (nonatomic,copy)      NSString *phone ;       //电话
@property (nonatomic,copy)      NSString *idcard ;      //身份证
@property (nonatomic,assign)    long long birth ;       //生日

@property (nonatomic)           int      coupons_number ;   //优惠券个数
//@property (nonatomic)           int      score          ;   //积分分数


- (instancetype)initWithDictionary:(NSDictionary *)dic ;

//- (instancetype)initWithWeboUser:(WeiboUser *)weiboUser ;


@end
