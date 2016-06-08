//
//  CmtSendView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-15.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#define TAG_LIKE_BT     78313
#define TAG_NORMAL_BT   78314
#define TAG_HATE_BT     78315


#import "ListComment.h"
#import <UIKit/UIKit.h>


@protocol CmtSendViewDelegate <NSObject>

- (void)popBackSuperController ;

@end


@interface CmtSendView : UIView <UITextViewDelegate>

//  attrs
@property (nonatomic,retain) ListComment *cmt       ;
@property (nonatomic,retain) id <CmtSendViewDelegate> delegate ;

//@property (nonatomic, copy) NSString *imgStr        ;
//@property (nonatomic, copy) NSString *goodstitle    ;
//@property (nonatomic, copy) NSString *totalPrice    ;


//  views
@property (weak, nonatomic) IBOutlet UIView *goodInfoView;

@property (weak, nonatomic) IBOutlet UIImageView *img_good; //img

@property (weak, nonatomic) IBOutlet UILabel *lb_goodTitle; //title

@property (weak, nonatomic) IBOutlet UILabel *lb_goodPrice; //价格

@property (weak, nonatomic) IBOutlet UILabel *lb_uCanInput; //您还可以输入


@property (weak, nonatomic) IBOutlet UIView *commentWordView;

@property (weak, nonatomic) IBOutlet UIImageView *img_like; //喜欢

@property (weak, nonatomic) IBOutlet UILabel *lb_like;

@property (weak, nonatomic) IBOutlet UIImageView *img_normal;//一般

@property (weak, nonatomic) IBOutlet UILabel *lb_normal;

@property (weak, nonatomic) IBOutlet UIImageView *img_hate;//不喜欢

@property (weak, nonatomic) IBOutlet UILabel *lb_hate;

@property (weak, nonatomic) IBOutlet UITextView *tv_commentContent;//评论内容


- (IBAction)likeAction:(id)sender;

//发送
- (void)sendCommentToServer ;


@end
