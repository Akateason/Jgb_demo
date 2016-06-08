//
//  RootCtrl.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "RootCtrl.h"
#import "DigitInformation.h"
#import "YXSpritesLoadingView.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "TalkingData.h"

@interface RootCtrl ()
{
    UIImageView *m_nothingPicImgView ;
}
@end

@implementation RootCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define TAG_NOTINGPIC  7758258

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

// set Nothing Pic Img View
    [self setNothingPicImgView] ;

//  initial back img
    _isNothing = NO ;
    _isShopCar = NO ;
    
//  no net word
//    [self noNetWork] ;
    
//  initialAudioPlayer
//    [self initialAudioPlayer] ;
    
}

- (void)setNothingPicImgView
{
    m_nothingPicImgView = [[UIImageView alloc] initWithFrame:APPFRAME] ;
    m_nothingPicImgView.tag = TAG_NOTINGPIC ;
    m_nothingPicImgView.userInteractionEnabled = YES ;
    m_nothingPicImgView.image = [UIImage imageNamed:@"noNetWork"] ;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMe)] ;
    [m_nothingPicImgView addGestureRecognizer:tap] ;
}

#define MY_DURATION   0.18


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
//  NOT translucent
    self.navigationController.navigationBar.translucent = NO ;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
//    [_avPlay play] ;
    
    [TalkingData trackPageBegin:self.myTitle] ;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [m_nothingPicImgView removeFromSuperview] ;
    m_nothingPicImgView = nil ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated] ;
    
    [TalkingData trackPageEnd:self.myTitle] ;
}

#pragma mark -- initial

- (void)initialAudioPlayer
{
    NSString *pathMp3 = [[NSBundle mainBundle] pathForResource:@"skip" ofType:@"wav"];
    NSError *playerError  ;
    _avPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:pathMp3] error:&playerError];
    _avPlay.volume = 0.045f ;   //0.015f
    if (_avPlay == nil) NSLog(@"Error creating player: %@", [playerError description]);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - back Button Set
- (void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --
#pragma mark - no net word
- (void)noNetWork
{
    if ( ![DigitInformation isConnectionAvailable] )
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK] ;
    }
}

#pragma mark --
#pragma mark - Set BOOL isNothing
- (void)setIsShopCar:(BOOL)isShopCar
{
    NSString *imgStr = (isShopCar) ? @"noShopCar" : @"noNetWork"    ;
    m_nothingPicImgView.image = [UIImage imageNamed:imgStr]         ;
    
    _isShopCar = isShopCar                                          ;
}


#pragma mark --
#pragma mark - Set BOOL setIsOrder
- (void)setIsOrder:(BOOL)isOrder
{
    NSString *imgStr = (isOrder) ? @"noOrder" : @"noNetWork"        ;
    m_nothingPicImgView.image = [UIImage imageNamed:imgStr]         ;
    
    _isOrder = isOrder                                              ;
}

#pragma mark --
#pragma mark - Set BOOL is delete bar button
- (void)setIsDelBarButton:(BOOL)isDelBarButton
{
    
    _isDelBarButton = isDelBarButton ;
    
    if (isDelBarButton)
    {
        self.navigationItem.leftBarButtonItem = nil ;
        self.navigationItem.backBarButtonItem = nil ;
    }
    else
    {
//        [self backButtonSet] ;
    }
    
}

#pragma mark - Set BOOL isNothing
- (void)setIsNothing:(BOOL)isNothing
{
    if (isNothing)
    {
        // 避免重复
        for (UIView *subView in self.view.subviews)
        {
            if (subView.tag == TAG_NOTINGPIC)
            {
                return ;
            }
        }
        
        if (m_nothingPicImgView == nil)
        {
            [self setNothingPicImgView]         ;
            
            if (_isShopCar) [self setIsShopCar:YES] ;

            if (_isOrder) [self setIsOrder:YES] ;
        }
        
        m_nothingPicImgView.contentMode = UIViewContentModeScaleAspectFill ;
        m_nothingPicImgView.frame = APPFRAME        ;
        [self.view addSubview:m_nothingPicImgView]  ;
        [self.view bringSubviewToFront:m_nothingPicImgView] ;
    }
    else
    {
        for (UIView *subView in self.view.subviews)
        {
            if (subView.tag == TAG_NOTINGPIC)
            {
                [subView removeFromSuperview] ;
            }
        }
        
        m_nothingPicImgView.frame = CGRectZero      ;
        [m_nothingPicImgView removeFromSuperview]   ;
    }
    
    _isNothing = isNothing ;
}


#pragma mark --
#pragma mark - tap the nothing pic
- (void)tapMe
{
    NSLog(@"tap the nothing pic") ;
    NSLog(@"_isNothing : %d",_isNothing) ;
    
//    if (_isNothing) {
//        [self setIsNothing:NO] ;
//    }
    
    [self reShowTheData] ;
}

#pragma mark --
/*
 ** ReShow The Data ** 点击没有网络提醒的图片时, 重新刷数据 ,
 **/
- (void)reShowTheData
{
    NSLog(@"reShowTheData") ;
}

#pragma mark --
#pragma mark - Getter
- (NSString *)myTitle
{
    if (!_myTitle) {
        _myTitle = self.title ;
    }
    
    return _myTitle ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
