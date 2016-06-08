//
//  CoupsonWriteView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-10.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinkButton.h"
#import "MyTextField.h"

@protocol CoupsonWriteViewDelegate <NSObject>

- (void)sendCoupsonCode:(NSString *)coupsonCode ;

@end


@interface CoupsonWriteView : UIView <UITextFieldDelegate>

//  attrs
@property (nonatomic,retain) id <CoupsonWriteViewDelegate> delegate ;

//  views
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet MyTextField *tf_input;

@property (weak, nonatomic) IBOutlet PinkButton *bt_use;

- (IBAction)usePointAction:(id)sender;


@end
