//
//  ProScrView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProScroSubView.h"


@interface ProScrView : UIView



@property (nonatomic)           int         listCount   ;       //

@property (nonatomic,retain)    NSArray     *proList    ;

@property (nonatomic)           BOOL        isAutoPlay ;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *killSegView;
@property (weak, nonatomic) IBOutlet UIView *killProView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end
