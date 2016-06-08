
//  DealPhotoVideoViewController.h
//  TDIMap
//
//  Created by mini1 on 13-10-24.
//  Copyright (c) 2013年 SHJEC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollView.h"
#import "RootCtrl.h"

@interface DealPhotoVideoViewController : RootCtrl<UIScrollViewDelegate,ImageScrollViewDelegate>
{
    UIScrollView *_scrollView;
 
    //be sended in the dic
    int m_currentImgVideoIndex;
    int m_cplaceIdCurrent;
    
    //imgageScrollView
    ImageScrollView *_firstView;
    ImageScrollView *_secondView;
    ImageScrollView *_thirdView;
    
    int _count;
    int _index;                 //当前的index
    int _currentType;
    BOOL _isDecelerating;
    
    //image
//    NSMutableArray *imgsArr;
}

/* 
 *  此图是否有随机数
 *  DEFAULT IS FALSE
 */
@property (nonatomic,assign)BOOL      isRandom ;    //此图是否有随机数

//
@property (nonatomic,retain)NSArray   *m_imgKeyArray             ;
@property (nonatomic,assign)int       m_currentImgVideoIndex    ;       //current index


@end
