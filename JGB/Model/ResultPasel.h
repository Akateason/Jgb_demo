//
//  ResultPasel.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultPasel : NSObject

@property (nonatomic,assign) int            code                ;

@property (nonatomic,retain) NSString       *info               ;

@property (nonatomic,retain) id             data               ;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary   ;

@end
