//
//  HeadView_history.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadViewHistoryDelegate <NSObject>

- (void)deleteAllHistoryCallBack ;

@end

@interface HeadView_history : UIView

@property (nonatomic,retain) id <HeadViewHistoryDelegate> delegate ;

@property (weak, nonatomic) IBOutlet UILabel *lb1;

@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)deleteHistoryAction:(id)sender;

@end
