//
//  RootCtrl.h
//  JGB
//
//  Created by ; on 14-8-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ColorsHeader.h"
#import "AMScrollingNavbarViewController.h"

@interface RootCtrl : AMScrollingNavbarViewController  //   UIViewController

@property (retain, nonatomic) AVAudioPlayer *avPlay;

#pragma mark -- is connective
/*
** default NO ;
** if YES     : when no data is return  , show a img in the front ;
**/
@property (nonatomic,assign)  BOOL          isNothing ;

/*
** ReShow The Data ** 点击没有网络提醒的图片时, 重新刷数据 , public 在外面调用时刷新数据
**/
- (void)reShowTheData ;

#pragma mark -- shop car nothing
/** default NO ;
 *  IF YES , the bg img noting shop car.png
 */
@property (nonatomic,assign) BOOL           isShopCar ;


#pragma mark -- Order nothing
/** default NO ;
 *  IF YES , the bg img noting noOrder.png
 */
@property (nonatomic,assign) BOOL           isOrder ;

#pragma mark -- Set No Back BarButton
/** default NO ;
 *  IF YES , delete all bar buttons
 */
@property (nonatomic,assign) BOOL           isDelBarButton ;


#pragma mark -- talkingData title
@property (nonatomic,copy) NSString         *myTitle ;

@end
