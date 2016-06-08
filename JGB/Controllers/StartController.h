//
//  StartController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface StartController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollV;

@property (retain, nonatomic) AVAudioPlayer *avPlay;

@end
