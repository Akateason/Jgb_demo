//
//  NavRegisterController.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-31.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"

//@protocol NavRegisterControllerDelegate <NSObject>
//
//- (void)loginFinished ;
//
//@end


@interface NavRegisterController : NavViewController

//@property (nonatomic,retain) id <NavRegisterControllerDelegate> delegate ;

+ (void)goToLoginFirstWithCurrentController:(UIViewController *)controller  ;
+ (void)goToLoginFirstWithCurrentController:(UIViewController *)controller
                           AppLoginFinished:(BOOL)bFinished                 ;

@end
