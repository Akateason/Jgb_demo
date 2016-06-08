//
//  Reply.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Reply.h"

@implementation Reply


- (instancetype)initWithDiction:(NSDictionary *)diction
{
    self = [super init];
    if (self)
    {
        
        _replyID        = [[diction objectForKey:@"id"] intValue] ;
        _commentID      = [[diction objectForKey:@"comment_id"] intValue] ;
        _uid            = [[diction objectForKey:@"uid"] intValue] ;
        _pid            = [[diction objectForKey:@"pid"] intValue] ;
        _official       = [[diction objectForKey:@"official"] intValue] ;
        _message        = [diction objectForKey:@"message"] ;
        _status         = [[diction objectForKey:@"status"] intValue] ;
        _atime          = [[diction objectForKey:@"atime"] longLongValue] ;

        _uname          = [diction objectForKey:@"uname"] ;
        if (_official)
        {
            _uname = NAME_ADMINISTRATER ;
        }
        
        _parentName     = [[diction objectForKey:@"parent"] objectForKey:@"uname"] ;
        
    }
    return self;
}


@end
