 //
//  StartController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "StartController.h"
#import "StartMoveView.h"
#import "ServerRequest.h"
#import "BrandTB.h"
#import "CategoryTB.h"
#import "SellerTB.h"
#import "DistrictTB.h"
#import "District.h"
#import "LSCommonFunc.h"
#import "Guide1.h"
#import "Guide2.h"
#import "Guide3.h"
#import "Guide4.h"

#import "Warehouse.h"
#import "WarehouseTB.h"

@interface StartController ()<StartMoveViewDelegate,UIScrollViewDelegate,AVAudioPlayerDelegate,UITextFieldDelegate>
{
    int             m_pre       ;

    CGPoint         pos         ;
    
    UIImageView     *fireBall   ;

    
    NSMutableArray  *m_guidelist ;
    
    UIPageControl   *m_pageCtrl ;
    
    BOOL            m_serverSwitch  ;
    
    UITextField     *m_tf ;
    UIImageView     *m_imgView ;
}
@end

@implementation StartController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        
        self.hidesBottomBarWhenPushed = YES ;

    }
    return self;
}

#define PAGE_NUM        4

- (void)setBackGroundImg
{
    UIImage *img = (!DEVICE_IS_IPHONE5) ? ([UIImage imageNamed:@"640x960.png"]) : ([UIImage imageNamed:@"640x1136.png"]) ;
    
    m_imgView = [[UIImageView alloc] initWithImage:img] ;
    m_imgView.frame = APPFRAME ;
    [self.view addSubview:m_imgView] ;
    [self.view sendSubviewToBack:m_imgView] ;
}

- (void)insetDataBaseIfisNeed
{
    
    [[CategoryTB shareInstance] begin]  ;
    
    //  DistrictTB
    [self allDistricts] ;
    //  CategoryTB
    [SalesCatagory setupCataIfNeeded] ;
    //  SellerTB
    [self allSellers] ;
    
    [[CategoryTB shareInstance] commit] ;
    
}


- (void)setCheckSwitchIos
{
    float versionNumber = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue];
    NSLog(@"versionNumber手机当前版本:%f",versionNumber) ;
    
    ResultPasel *result = [ServerRequest checkSwitchWithVersionNum:versionNumber] ;
    if (result.code != 200)
    {
        m_serverSwitch = NO ;
        return ;
    }
    m_serverSwitch = [((NSString *)result.data) intValue] ;
    
    G_BOOL_OPEN_APPSTORE = m_serverSwitch ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hidesBottomBarWhenPushed = NO ;
    
    [self setBackGroundImg] ;
    
    [self insetDataBaseIfisNeed] ;

    m_guidelist = [NSMutableArray array] ;
    
    // 服务端开关
    [self setCheckSwitchIos] ;
    
    NSLog(@" 服务端开关 : %d",G_BOOL_OPEN_APPSTORE) ;
    
//    //测试打开
//    G_BOOL_OPEN_APPSTORE = YES ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated]  ;

//    BOOL isNotfirstLaunch = [LSCommonFunc isNotFirstLaunch] ;
//    [self straightGo2Index:isNotfirstLaunch] ;      //  b
    [self straightGo2Index:NO] ;      //  b
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
//    [_scrollV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//  status bar hidden NO
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
//  [_avPlay stop]  ;
    _avPlay = nil   ;
    
}


#pragma mark --
- (void)straightGo2Index:(BOOL)b
{
    
    if (b)
    {
        [self performSegueWithIdentifier:@"start2index" sender:nil] ;
    }
    else
    {
        [self showScrollView] ;
    }
    
}


- (void)initialAudioPlayer
{
    NSString *pathMp3 = [[NSBundle mainBundle] pathForResource:@"xiyouji" ofType:@"mp3"] ;
    NSError *playerError  ;
    _avPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initFileURLWithPath:pathMp3] error:&playerError] ;
    _avPlay.volume = 1.0f ;
    if (_avPlay == nil) NSLog(@"Error creating player: %@", [playerError description]);
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil] ;
    _avPlay.delegate = self ;
}



#pragma mark --
#pragma mark - showScrollView
- (void)showScrollView
{
    Guide1 *guide1 = (Guide1 *)[[[NSBundle mainBundle] loadNibNamed:@"Guide1View" owner:self options:nil] lastObject] ;
    Guide2 *guide2 = (Guide2 *)[[[NSBundle mainBundle] loadNibNamed:@"Guide2View" owner:self options:nil] lastObject] ;
    Guide3 *guide3 = (Guide3 *)[[[NSBundle mainBundle] loadNibNamed:@"Guide3View" owner:self options:nil] lastObject] ;
    Guide4 *guide4 = (Guide4 *)[[[NSBundle mainBundle] loadNibNamed:@"Guide4View" owner:self options:nil] lastObject] ;
    
    m_guidelist = @[guide1,guide2,guide3,guide4] ;
    
    
    m_pre = 0 ;
    _scrollV.delegate = self    ;
    _scrollV.pagingEnabled = YES;
    _scrollV.showsVerticalScrollIndicator = NO ;
    _scrollV.showsHorizontalScrollIndicator = NO ;
    _scrollV.bounces = NO ;
    _scrollV.contentSize = CGSizeMake(APPFRAME.size.width * PAGE_NUM, APPFRAME.size.height )       ;
    _scrollV.backgroundColor = [UIColor colorWithRed:108.0/255.0
                                               green:196.0/255.0
                                                blue:191.0/255.0
                                               alpha:1.0] ;
    
    int _x = 0 ;
    
    for (int i = 1; i <= PAGE_NUM; i++)
    {
        NSString *imgStr      = [NSString stringWithFormat:@"s_0%d",i]                      ;
        CGRect rect           = CGRectMake(_x, 0, APPFRAME.size.width, APPFRAME.size.height)      ;
        BOOL  isShow          = (i == 4) ? YES : NO                                         ;
        BOOL  iscloud         = (i < 3) ? NO : YES                                          ;
        BOOL  isFire          = (i > 3) ? YES : NO                                          ;

        
        UIView *tempView = [m_guidelist objectAtIndex:i - 1] ;
        
        StartMoveView *startV = [[StartMoveView alloc] initWithFrame:rect
                                                       AndWithPicStr:imgStr
                                                   AndWithButtonShow:isShow
                                                        AndWithCloud:iscloud
                                                         AndWithFire:isFire
                                                       AndWithBgView:tempView]              ;
        
        startV.delegate       = self                                                        ;
        
        [_scrollV addSubview:startV]                                                        ;
        
        _x += APPFRAME.size.width                                                              ;
        
    }
    
    m_pageCtrl = [[UIPageControl alloc] init] ;
    m_pageCtrl.numberOfPages = [m_guidelist count] ;
    m_pageCtrl.currentPage = 0 ;
    [self.view addSubview:m_pageCtrl] ;
    m_pageCtrl.center = CGPointMake(APPFRAME.size.width / 2, APPFRAME.size.height - 50) ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    int current = scrollView.contentOffset.x / APPFRAME.size.width;
    m_pageCtrl.currentPage = current ;

    m_pre = current ;
    NSLog(@"current,%d",current) ;
    
    
    switch (current)
    {
        case 0:
        {
            Guide1 *guide1 = m_guidelist[current] ;
            [guide1 startAnimate] ;
        }
            break;
        case 1:
        {
            Guide2 *guide2 = m_guidelist[current] ;
            [guide2 startAnimate] ;
        }
            break;
        case 2:
        {
            Guide3 *guide3 = m_guidelist[current] ;
            [guide3 startAnimate] ;
        }
            break;
        case 3:
        {
            Guide4 *guide4 = m_guidelist[current] ;
            [guide4 startAnimate] ;
        }
        default:
            break;
    }
    
    
}


#pragma mark --
#pragma mark - StartMoveViewDelegate <NSObject>
- (void)goHome
{
// push ctrller
    [self performSegueWithIdentifier:@"start2index" sender:nil] ;
}


#pragma mark --
#pragma mark - audioPlayerDelegate call back
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
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

#pragma mark --
#pragma mark - allCatagories
//  cache all catagor


#pragma mark - allSellers
// cache all seller
- (void)allSellers
{
    NSDictionary *diction = [ServerRequest getSellerList] ;
    
    NSArray *keyArr = [diction allKeys] ;
    int num = 0 ;

    for (NSString *key in keyArr)
    {
        NSDictionary *dicSeller = [diction objectForKey:key] ;
        
        Seller *seller1 = [[Seller alloc] initWithDic:dicSeller]  ;
        [[SellerTB shareInstance] insertSeller:seller1]     ;
        num ++ ;
    }
    
    NSLog(@"num seller : %d",num) ;
}

#pragma mark - allDistrict
- (void)allDistricts
{
    if ([[DistrictTB shareInstance] hasInDB]) {
        return ;
    }
    
    
    
    NSDictionary *districtDic = [ServerRequest getAllArea] ;
    int num = 0 ;
    NSArray *districAllkey = [districtDic allKeys] ;
    for (NSString *key in districAllkey)
    {
        NSDictionary *diction = [districtDic objectForKey:key] ;
        District *district = [[District alloc] initWithDic:diction] ;
        [[DistrictTB shareInstance] insertDistrict:district] ;
        num++;
    }

    NSLog(@"num district : %d",num) ;
}


#pragma mark --
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect tfFrame = textField.frame;
    int offset = tfFrame.origin.y - (self.view.frame.size.height - 285.0);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    if (offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, - offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self keyboardBackToBase];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField resignFirstResponder])
    {
        [self keyboardBackToBase];
    }
    
    if ([textField.text isEqualToString:@"jgbnb"])
    {
        // enter
        BOOL isNotFirst = [LSCommonFunc isNotFirstLaunch] ;
        
        if (isNotFirst)
        {
            m_tf.hidden         = YES ;
            m_imgView.hidden    = YES ;
        }
        
        [self straightGo2Index:isNotFirst] ;    // b
    }
    else
    {
        [DigitInformation showWordHudWithTitle:@"测试, 那是要'有码'的"] ;
    }
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![m_tf isExclusiveTouch])
    {
        [m_tf  resignFirstResponder];
        [self keyboardBackToBase];
    }
}

- (void)keyboardBackToBase
{
    [UIView beginAnimations:@"ReturnKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}



@end
