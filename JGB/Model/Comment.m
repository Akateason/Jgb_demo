//
//  Comment.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "Comment.h"
#import "Reply.h"

@implementation Comment

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _commentID = [[dictionary objectForKey:@"comment_id"] intValue] ;
        _uid       = [[dictionary objectForKey:@"uid"] intValue] ;
        _message   = [dictionary objectForKey:@"message"] ;
        _imgStr    = [dictionary objectForKey:@"img_str"] ;
        _tsin      = [dictionary objectForKey:@"tsin"] ;
        _atime     = [[dictionary objectForKey:@"atime"] longLongValue] ;
        _pid       = [dictionary objectForKey:@"pid"] ;
        _orderProductId = [[dictionary objectForKey:@"orderProductId"] intValue];
        _point     = [[dictionary objectForKey:@"point"] floatValue] ;
        _status    = [[dictionary objectForKey:@"status"] intValue] ;
        _anonymous = [[dictionary objectForKey:@"anonymous"] intValue] ;
        _uname     = [dictionary objectForKey:@"uname"] ;

        _replyCount = [[dictionary objectForKey:@"replyCount"] intValue];

 
        if (![[dictionary objectForKey:@"reply"] isKindOfClass:[NSNull class]])
        {
            NSMutableArray  *replyList = [NSMutableArray array] ;
            NSArray *replyDicArray = [dictionary objectForKey:@"reply"] ;
            for (NSDictionary *dicTemp in replyDicArray)
            {
                Reply *reply = [[Reply alloc] initWithDiction:dicTemp] ;
                [replyList addObject:reply] ;
            }
            _reply = replyList ;
        }
        
        _avatar = [dictionary objectForKey:@"avatar"] ;
    }
    
    return self;
}



//  get LikeLevel  With   Rate
- (likeLevelEnum)getLikeLevelWithRate:(float)rate
{
    if ( (rate <= 1.0f) && (rate > 0.0f) )
    {
        //不喜欢
        return LEVEL_HATE ;
    }
    else if ( (rate > 1.0f) && (rate < 5.0f) )
    {
        //一般
        return LEVEL_NORMAL ;
    }
    else if ( (rate == 5.0f) || !rate )
    {
        //很喜欢
        return LEVEL_LIKE ;
    }

    return 0 ;
}

//
- (float)getReplyTableHeight
{
    float   heightSum   = 0.0f ;
    NSArray *replyArray = self.reply ;
    
    for (int i = 0 ; i < replyArray.count; i++)
    {
        Reply *replyTemp        = replyArray[i] ;
        
        float cellOrgHeight     = 24.0f ;
        float lbOrgHeight       = 12.0f ;
        
        NSString *commentStr    = replyTemp.message;
        
        if (! replyTemp.parentName)
        {
            commentStr = [NSString stringWithFormat:@"%@: %@",replyTemp.uname,replyTemp.message] ;
        }
        else
        {
            commentStr = [NSString stringWithFormat:@"%@ 回复 %@: %@",replyTemp.uname,replyTemp.parentName,replyTemp.message] ;
        }
        
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize size = CGSizeMake(207,500);
        CGSize labelsize = [commentStr sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        float h =  cellOrgHeight - lbOrgHeight + labelsize.height ;
        
        
        heightSum += h ;
    }
    
    return  ( heightSum + 6*2 ) ;//(self.reply.count <= 1) ? 24: ( heightSum + 6*2 ) ;
}


- (float)getCommentLabelHeight
{
    float orgHeight   = 102.0f  ;
    float lbOrgHeight = 15.0f   ;
    
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(227,500);
    CGSize labelsize = [self.message sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    float h =  orgHeight - lbOrgHeight + labelsize.height ;
    
    return h ;
}


@end
