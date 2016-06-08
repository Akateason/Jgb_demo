//
//  CommentListCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//


#define STATUS_SEND_COMMENT         @"发表评价"
#define STATUS_SEND_FAIL            @"发表失败"
#define STATUS_WAITFORCHECK         @"审核中"
#define STATUS_SEND_SUCCESS         @"发表成功"
#define STATUS_MANAGER_REPLY        @"管理员已回复"



typedef enum
{
    
    sendCommentMode     = - 2   ,   //发表评价
    sendFailMode        = - 1   ,   //发表失败
    waitForCheckMode    = 1     ,   //审核中
    sendSuccessMode     = 2     ,   //发表成功
    managerReplyMode    = 3         //管理员已回复
    
    
}   CmtCellMode ;




#import <UIKit/UIKit.h>
#import "ListComment.h"


@protocol CommentListCellDelegate <NSObject>

- (void)pressedCommentButtonSendCellIndex:(int)index ;

@end


@interface CommentListCell : UITableViewCell

// attrs

//comment obj
@property (nonatomic,retain) ListComment    *cmt ;

//enum commentmode ...,  评论已否情况
@property (nonatomic,assign) CmtCellMode   commentMode ;    // cmt.status 赋值
//哪一行
@property (nonatomic,assign) int           row ;
//delegate
@property (nonatomic,retain) id <CommentListCellDelegate> delegate  ;


// views

@property (weak, nonatomic) IBOutlet UIImageView *img_goods ;    //img
- (IBAction)imgClickedAction:(id)sender ;

@property (weak, nonatomic) IBOutlet UILabel *lb_title  ;        //标题

@property (weak, nonatomic) IBOutlet UILabel *lb_status ;

@property (weak, nonatomic) IBOutlet UIButton *bt_comment ;
- (IBAction)commentButtonCicked:(id)sender ;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end




