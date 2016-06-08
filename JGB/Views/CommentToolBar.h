//
//  CommentToolBar.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentToolBarDelegate <NSObject>

- (void)sendMsg ;

@end


@interface CommentToolBar : UIToolbar
//attrs
@property (nonatomic,retain) id <CommentToolBarDelegate> delegateComment ;

//views
@property (weak, nonatomic) IBOutlet UITextField *tf_input;

@property (weak, nonatomic) IBOutlet UIButton *bt_send;

- (IBAction)sendMsgAction:(id)sender;

@end
