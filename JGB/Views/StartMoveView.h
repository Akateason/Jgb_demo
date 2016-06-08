//
//  StartMoveView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinkButton.h"

@protocol StartMoveViewDelegate <NSObject>

- (void)goHome ;

@end

@interface StartMoveView : UIView

@property (nonatomic,retain) id <StartMoveViewDelegate> delegate ;

//@property (retain, nonatomic)  UIImageView *imgV;

//@property (nonatomic,retain)    UIView *backGroundView ;

@property (retain, nonatomic)   UIButton *button;


- (id)initWithFrame:(CGRect)frame
      AndWithPicStr:(NSString *)picStr
  AndWithButtonShow:(BOOL)YesOrNo
       AndWithCloud:(BOOL)cloud
        AndWithFire:(BOOL)fire
      AndWithBgView:(UIView *)bgView ;

@end
