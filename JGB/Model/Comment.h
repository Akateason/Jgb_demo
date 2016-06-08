//
//  Comment.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    LEVEL_HATE = 1,
    LEVEL_NORMAL,
    LEVEL_LIKE
} likeLevelEnum ;


@interface Comment : NSObject

@property (nonatomic)           int         commentID       ;//评论id
@property (nonatomic)           int         uid             ;//用户id
@property (nonatomic,copy)      NSString    *message        ;//内容
@property (nonatomic,copy)      NSString    *imgStr         ;
@property (nonatomic,copy)      NSString    *tsin           ;
@property (nonatomic)           long long   atime           ;//添加时间
@property (nonatomic,copy)      NSString    *pid            ;
@property (nonatomic)           int         orderProductId  ;//订单id,
@property (nonatomic)           float       point           ;//分数
@property (nonatomic)           int         status          ;//状态  1正在审核 2成功 3失败
@property (nonatomic)           int         anonymous       ;//是否匿名
@property (nonatomic,copy)      NSString    *uname          ;//昵称
@property (nonatomic,copy)      NSArray     *reply          ;//回复 集合
@property (nonatomic)           int         replyCount      ;//回复数
@property (nonatomic,copy)      NSString    *avatar         ;//头像

//  initial
- (instancetype)initWithDictionary:(NSDictionary *)dictionary ;


//  get LikeLevel  With   Rate
- (likeLevelEnum)getLikeLevelWithRate:(float)rate ;

//  get reply table height
- (float)getReplyTableHeight ;

//  get comment label height
- (float)getCommentLabelHeight ;

@end
