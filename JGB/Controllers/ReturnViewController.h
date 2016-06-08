//
//  ReturnViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "MyTextField.h"
#import "MyTextView.h"

//意见反馈
@interface ReturnViewController : RootCtrl <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIImageView *imgV_cryIcon;//哭脸
@property (weak, nonatomic) IBOutlet UILabel *lb_yourQuesion;//您的问题,吐槽有奖~

@property (weak, nonatomic) IBOutlet MyTextView *tv_contents;//text view
@property (weak, nonatomic) IBOutlet MyTextField *tf_emailAddr;//email addr

@property (weak, nonatomic) IBOutlet UIButton *bt_send;//我要提交
- (IBAction)iwantSendAction:(id)sender;

@end
