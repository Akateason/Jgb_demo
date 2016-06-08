//
//  AboutUsController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-14.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "AboutUsController.h"
#import "Guide1.h"
#import "Guide2.h"
#import "Guide3.h"
#import "Guide4.h"
#import "StartMoveView.h"

@interface AboutUsController () <UIScrollViewDelegate>
{
    int             m_pre       ;

    NSMutableArray  *m_guidelist ;
    
    UIPageControl   *m_pageCtrl ;
    UIImageView     *m_imgView ;

}


@end

@implementation AboutUsController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    m_guidelist = [NSMutableArray array] ;
    
    [self setBackGroundImg] ;

    [self showScrollView] ;
}

- (void)setBackGroundImg
{
    UIImage *img = (!DEVICE_IS_IPHONE5) ? ([UIImage imageNamed:@"640x960.png"]) : ([UIImage imageNamed:@"640x1136.png"]) ;
    
    m_imgView = [[UIImageView alloc] initWithImage:img] ;
    m_imgView.frame = APPFRAME ;
    [self.view addSubview:m_imgView] ;
    [self.view sendSubviewToBack:m_imgView] ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning] ;
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES] ;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO] ;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    
}

#pragma mark --
#pragma mark - showScrollView

#define PAGE_NUM        4

- (void)showScrollView
{
    Guide1 *guide1 = (Guide1 *)[[[NSBundle mainBundle] loadNibNamed:@"Guide1View" owner:self options:nil] lastObject] ;
    Guide2 *guide2 = (Guide2 *)[[[NSBundle mainBundle] loadNibNamed:@"Guide2View" owner:self options:nil] lastObject] ;
    Guide3 *guide3 = (Guide3 *)[[[NSBundle mainBundle] loadNibNamed:@"Guide3View" owner:self options:nil] lastObject] ;
    Guide4 *guide4 = (Guide4 *)[[[NSBundle mainBundle] loadNibNamed:@"Guide4View" owner:self options:nil] lastObject] ;
    
    m_guidelist = @[guide1,guide2,guide3,guide4] ;
    
    m_pre = 0 ;
    UIScrollView *_scrollV = [[UIScrollView alloc] initWithFrame:APPFRAME] ;
    [self.view addSubview:_scrollV] ;
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
        
        _x += APPFRAME.size.width                                                           ;
        
    }
    
    m_pageCtrl = [[UIPageControl alloc] init] ;
    m_pageCtrl.numberOfPages = [m_guidelist count] ;
    m_pageCtrl.currentPage = 0 ;
    [self.view addSubview:m_pageCtrl] ;
    m_pageCtrl.center = CGPointMake(APPFRAME.size.width / 2, APPFRAME.size.height - 50) ;
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    int current = scrollView.contentOffset.x / APPFRAME.size.width ;
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
    
    [self.navigationController popViewControllerAnimated:YES] ;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
