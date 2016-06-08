//
//  GoodCommentCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

/*
 *   商品回复 delegate
 */
@protocol GoodCommentCellDelegate <NSObject>

// comment answer 晒单回复
- (void)commentAnswerButtonClickedWithCommentID:(int)commentID AndWithRow:(int)row;

// reply answer 对回复的回复
- (void)replyAnswerCellSelectedWithCommentID:(int)commentID AndWithRow:(int)commentRow AndWithReplyID:(int)replyID AndWithReplyHeight:(float)height AndWithPlaceHolderStr:(NSString *)placeHolderStr ;

// 用户未登录
- (void)userNotLoginCallBack ;

@end



/*
 *   商品回复 cell
 */
@interface GoodCommentCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate>

// attribute
@property (nonatomic,retain) Comment  *theComment ;
@property (nonatomic,retain) id <GoodCommentCellDelegate> delegate ;
@property (nonatomic)        int    row ;

// views ...
@property (weak, nonatomic) IBOutlet UILabel *lb_fakeLine;

@property (weak, nonatomic) IBOutlet UIImageView *img_ask;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *img_userHead;//头像

@property (weak, nonatomic) IBOutlet UILabel *lb_userName;//昵称

@property (weak, nonatomic) IBOutlet UILabel *lb_content;//评论内容

@property (weak, nonatomic) IBOutlet UILabel *lb_date;//日期

@property (weak, nonatomic) IBOutlet UIImageView *img_like;//喜欢程度图片

@property (weak, nonatomic) IBOutlet UILabel *lb_like;//喜欢程度

@property (weak, nonatomic) IBOutlet UIButton *askButton;
- (IBAction)askCommentAction:(id)sender;//回复评论

@property (weak, nonatomic) IBOutlet UITableView *tableReply;






@end
