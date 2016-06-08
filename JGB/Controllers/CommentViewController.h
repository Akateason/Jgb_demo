//
//  CommentViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "ListComment.h"


@interface CommentViewController : RootCtrl

//  attrs
@property (nonatomic,retain) ListComment *cmt       ;


@property (nonatomic, copy) NSString *imgStr        ;
@property (nonatomic, copy) NSString *goodstitle    ;
@property (nonatomic, copy) NSString *totalPrice    ;


//  views

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;


//@property (weak, nonatomic) IBOutlet UIImageView *img_good;//商品图片
//
//
//@property (weak, nonatomic) IBOutlet UILabel *lb_goodsName;//商品名臣
//
//
//@property (weak, nonatomic) IBOutlet UIView *scoreView;//星星view
//
//
//@property (weak, nonatomic) IBOutlet UITextView *tv_comment;//评论textview
//
//@property (weak, nonatomic) IBOutlet UIButton *bt_camera;//拍照
//
//- (IBAction)cameraPressedAction:(id)sender;
//
//@property (weak, nonatomic) IBOutlet UIView *photoView;//放照片集
//
//@property (weak, nonatomic) IBOutlet UIButton *bt_send;//立即发表
//
//- (IBAction)sendPressedAction:(id)sender;

@end
