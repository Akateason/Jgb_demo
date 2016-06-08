//
//  District.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *   /Area/getList
 */

@interface District : NSObject

@property (nonatomic)       int         districtID  ;
@property (nonatomic,copy)  NSString    *name       ;
@property (nonatomic)       int         upid        ;
@property (nonatomic)       int         sort        ;
@property (nonatomic)       int         zip         ;

- (instancetype)initWithDic:(NSDictionary *)diciton ;

@end
