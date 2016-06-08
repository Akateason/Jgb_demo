//
//  VersionApp.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-7.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionApp : NSObject

@property (nonatomic)           float           newestVerion ;
@property (nonatomic,copy)      NSString        *downloadPath ;

- (instancetype)initWithDictionary:(NSDictionary *)dic ;

@end
