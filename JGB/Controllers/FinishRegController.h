//
//  FinishRegController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "MyTextField.h"
#import "PinkButton.h"
#import "CountDownButton.h"

@interface FinishRegController : RootCtrl<UITextFieldDelegate>



@property (weak, nonatomic) IBOutlet MyTextField *tf_account;//账户名

@property (weak, nonatomic) IBOutlet MyTextField *tf_checkCode;

@property (weak, nonatomic) IBOutlet CountDownButton *bt_checkCode;
- (IBAction)checkCodeAction:(id)sender;


@property (weak, nonatomic) IBOutlet MyTextField *tf_password;//密码

@property (weak, nonatomic) IBOutlet MyTextField *tf_nickName;//昵称

@property (weak, nonatomic) IBOutlet PinkButton *bt_sumit;

- (IBAction)submitAction:(id)sender;

@end
