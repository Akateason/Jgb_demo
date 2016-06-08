//
//  ForgetSecretController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "MyTextField.h"
#import "CountDownButton.h"

@interface ForgetSecretController : RootCtrl<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MyTextField *tf_imputPhoneNum;

@property (weak, nonatomic) IBOutlet MyTextField *tf_checkCode;

@property (weak, nonatomic) IBOutlet CountDownButton *bt_checkCode;
- (IBAction)checkCodeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *bt_next;
- (IBAction)nextAction:(id)sender;

@end
