//
//  HelpView.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-2-27.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelpViewDelegate <NSObject>

- (void)helpViewPressedCallBack ;

@end

@interface HelpView : UIView

@property (nonatomic, retain) id <HelpViewDelegate> delegate ;

- (instancetype)initWithFrame:(CGRect)frame ;

@end
