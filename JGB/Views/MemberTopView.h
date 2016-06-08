//
//  MemberTopView.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-4.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MemberTopViewDelegate <NSObject>

- (void)settingButtonPressedCallBack ;

- (void)pressedUserInfoCallBack ;

- (void)pressedHeadCallBack ;

@end



@interface MemberTopView : UIView

//  attrs
@property (nonatomic,copy) NSString *strUserName ;
@property (nonatomic,copy) NSString *strImg ;


@property (nonatomic,retain) id <MemberTopViewDelegate> delegate ;

//  views

@property (nonatomic,weak) IBOutlet UIView *topRedView ;

@property (nonatomic,weak) IBOutlet UIImageView *imgHead ;

@property (nonatomic,weak) IBOutlet UILabel *lb_userName ;

@property (nonatomic,weak) IBOutlet UIButton *bt_setting ;

- (IBAction)settingButtonPressed:(id)sender ;

- (IBAction)pressedUserInfoAndLogin:(id)sender ;

@end
