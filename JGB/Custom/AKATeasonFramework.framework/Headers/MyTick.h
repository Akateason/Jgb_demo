//
//  MyTick.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-29.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTick : NSObject

#pragma mark --
//转tick
+ (long long)getTickWithDate:(NSDate *)_date;
//转tick,转出string
+ (NSString *)getDateWithTick:(long long)_tick AndWithFormart:(NSString *)formatStr;
//转tick,转出NsDate
+ (NSDate *)getNSDateWithTick:(long long)_tick;
//转str变NSdate
+ (NSDate *)getNSDateWithDateStr:(NSString *)dateStr AndWithFormat:(NSString *)format;
//转nsdate变str
+ (NSString *)getStrWithNSDate:(NSDate *)date AndWithFormat:(NSString *)format;


@end
