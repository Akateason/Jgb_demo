//
//  LoginViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "MyTextField.h"

@interface LoginViewController : RootCtrl<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet MyTextField *tf_username;
@property (weak, nonatomic) IBOutlet MyTextField *tf_password;

@property (weak, nonatomic) IBOutlet UIButton *bt_login;
- (IBAction)loginActionPressed:(id)sender;

- (IBAction)forgetSecret:(id)sender;
- (IBAction)regVipAction:(id)sender;

@end
