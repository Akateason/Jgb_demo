//
//  AttrParsel.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-17.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "AttrParsel.h"

@implementation AttrParsel


- (NSDictionary *)changeLinkToJson:(NSString *)link
{
//    size_name|10 B(M) US-->color_name|Black/Cuoio
//    ...
//    color_name|Black/Cuoio
//    ...
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary] ;
    
    NSArray *arr1 = [link componentsSeparatedByString:STR_ARROWS] ;
    
    for (NSString *tempStr in arr1)
    {
        NSArray *arr2 = [tempStr componentsSeparatedByString:@"|"] ;
        
        [resultDic setObject:[arr2 lastObject] forKey:arr2[0]] ;
    }
    
    return resultDic ;
}


@end
