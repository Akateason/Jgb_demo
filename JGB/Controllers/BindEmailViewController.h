//
//  BindEmailViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-23.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"
#import "RootCtrl.h"

@interface BindEmailViewController : RootCtrl


@property (weak, nonatomic) IBOutlet MyTextField *tf_email;

@property (weak, nonatomic) IBOutlet UIButton *bt_bind;

- (IBAction)bindAction:(id)sender;


@end
