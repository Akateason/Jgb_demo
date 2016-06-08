//
//  ChangeSecretViewController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "RootCtrl.h"
#import "MyTextField.h"
#import "PinkButton.h"

@interface ChangeSecretViewController : RootCtrl <UITextFieldDelegate>

@property (nonatomic,copy)  NSString *account                       ;

@property (weak, nonatomic) IBOutlet MyTextField *tf_firstSecret    ;



@property (weak, nonatomic) IBOutlet MyTextField *tf_secondSecret   ;

@property (weak, nonatomic) IBOutlet PinkButton  *bt_submit         ;

- (IBAction)submitAction:(id)sender ;

@end
