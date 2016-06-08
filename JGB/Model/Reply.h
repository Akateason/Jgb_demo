//
//  Reply.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reply : NSObject

@property (nonatomic,assign)       int          replyID ;           //id
@property (nonatomic,assign)       int          commentID ;         //comment id
@property (nonatomic,assign)       int          uid ;               //用户id
@property (nonatomic,assign)       int          pid ;               //replyID
@property (nonatomic,assign)       BOOL         official ;          //官方回复
@property (nonatomic,copy)         NSString     *message ;          //msg
@property (nonatomic,assign)       int          status ;            //状态  1正在审核 2成功 3失败
@property (nonatomic,assign)       long long    atime ;             //发布时间
@property (nonatomic,copy)         NSString     *uname ;            //昵称
@property (nonatomic,copy)         NSString     *parentName ;           //回复父类的回复,  nil表示无父类 即对晒单的回复 ,


- (instancetype)initWithDiction:(NSDictionary *)diction ;

@end
