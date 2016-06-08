//
//  ReplyCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reply.h"

@interface ReplyCell : UITableViewCell


@property (nonatomic,retain) Reply              *theReply   ;

@property (weak, nonatomic) IBOutlet UILabel    *lb_content ;


@end
