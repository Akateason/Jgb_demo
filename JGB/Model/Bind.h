//
//  Bind.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bind : NSObject

/*  bindID
 ****************************************************
 *  0手机绑定, 1邮箱绑定, 2微信绑定, 3qq绑定, 4微博绑定   *
 ****************************************************
 */

@property (nonatomic,assign)    int         bindID          ;

@property (nonatomic,copy)      NSString    *name           ;

@property (nonatomic,copy)      NSString    *bindContent    ;

@property (nonatomic,assign)    BOOL        isBinded        ;


@end
