//
//  KillSegView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-26.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef enum {
    clock10 = 1,
    clock13,
    clock20
}SWITCH_MODE;


@protocol KillSegViewDelegate <NSObject>

- (void)sendToClockMode:(SWITCH_MODE)clockMode ;

@end


@interface KillSegView : UIView

@property (nonatomic,retain) id <KillSegViewDelegate> delegate ;

- (instancetype)initWithFrame:(CGRect)frame AndMode:(SWITCH_MODE)mode ;

- (void)switchMode:(SWITCH_MODE)mode ;


@end
