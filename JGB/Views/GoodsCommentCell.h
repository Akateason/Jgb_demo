//
//  GoodsCommentCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-3.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

/*
 *   商品详情 - 回复显示 cell
 */

@protocol GoodsCommentCellDelegate <NSObject>

- (void)seeMoreCommentCallBack ;

@end



@interface GoodsCommentCell : UITableViewCell

// attributes
@property (nonatomic,retain) Comment    *comment ;
@property (nonatomic,retain) id <GoodsCommentCellDelegate> delegate ;

//  views
@property (weak, nonatomic) IBOutlet UIImageView *img_userHead;//用户头像

@property (weak, nonatomic) IBOutlet UILabel *lb_userName;//用户昵称

@property (weak, nonatomic) IBOutlet UILabel *lb_comment;//评论内容

@property (weak, nonatomic) IBOutlet UILabel *lb_date;//日期

@property (weak, nonatomic) IBOutlet UIImageView *img_star;//喜欢程度图片







@end
