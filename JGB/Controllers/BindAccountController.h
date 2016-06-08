//
//  BindAccountController.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-22.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "RootCtrl.h"
#import "MyTextField.h"
#import "PinkButton.h"
#import "BindThirdLogin.h"
#import "CountDownButton.h"

@interface BindAccountController : RootCtrl

// attrs
@property (nonatomic, retain) BindThirdLogin *loginObj ;

// views
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet MyTextField *tf_telNum;

@property (weak, nonatomic) IBOutlet MyTextField *tf_checkCode;

@property (weak, nonatomic) IBOutlet CountDownButton *bt_sms;
- (IBAction)smsClickedAction:(id)sender;

@property (weak, nonatomic) IBOutlet MyTextField *tf_secret;

@property (weak, nonatomic) IBOutlet PinkButton *bt_createNewUser;
- (IBAction)createNewUserAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *bt_bindAlready;
- (IBAction)bingAlreadyAction:(id)sender;

@end
