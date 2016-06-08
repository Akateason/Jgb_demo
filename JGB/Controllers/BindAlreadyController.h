//
//  BindAlreadyController.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-23.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "RootCtrl.h"
#import "MyTextField.h"
#import "PinkButton.h"
#import "BindThirdLogin.h"

@interface BindAlreadyController : RootCtrl

//  attrs
@property (nonatomic, retain) BindThirdLogin *loginObj ;

//  views
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet MyTextField *tf_account;
@property (weak, nonatomic) IBOutlet MyTextField *tf_password;

@property (weak, nonatomic) IBOutlet PinkButton *bt_bindNow;
- (IBAction)bindNowAction:(id)sender;

@end
