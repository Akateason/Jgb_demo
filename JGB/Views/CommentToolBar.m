//
//  CommentToolBar.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CommentToolBar.h"
#import "ColorsHeader.h"


@implementation CommentToolBar

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _bt_send.layer.cornerRadius = 2.0f          ;
    _bt_send.backgroundColor    = COLOR_PINK    ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)sendMsgAction:(id)sender
{
    NSLog(@"sendMsgAction") ;
    
    [self.delegateComment sendMsg] ;

}


@end
