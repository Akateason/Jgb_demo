//
//  VersionApp.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-7.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "VersionApp.h"

@implementation VersionApp

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _newestVerion = [[dic objectForKey:@"newestVersion"] floatValue] ;
        _downloadPath = [dic objectForKey:@"downloadPath"] ;
    }
    return self;
}


@end
