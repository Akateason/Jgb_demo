//
//  IndexViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-1.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "IndexViewController.h"
#import "PopMenuView.h"
#import "DigitInformation.h"
#import "ShopCarViewController.h"
#import "MemberCenterController.h"
#import "LSCommonFunc.h"
#import "ServerRequest.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageManagerDelegate.h"
#import "SDImageCache.h"
#import "GoodsDetailViewController.h"
#import "YXSpritesLoadingView.h"
#import "UIImage+AddFunction.h"
#import "DeserveBuyView.h"
#import "MyWebController.h"
#import "VersionApp.h"
#import "LogoMiddle.h"
#import "SaleCell.h"
#import "CategoryTB.h"
#import "NSObject+MKBlockTimer.h"
#import "Apns.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "NavRegisterController.h"
#import "TagsIndex.h"
#import "HomePageView.h"
#import "DigitInformation.h"

#define NOTIFICATION_INDEXFIRST                 @"NOTIFICATION_INDEXFIRST"
#define NOTIFICATION_SECKILL                    @"NOTIFICATION_SECKILL"


#define MENUHEIHT                               40




@interface IndexViewController ()<PopMenuViewDelegate,SDWebImageManagerDelegate,MenuHrizontalDelegate,ScrollPageViewDelegate,UIAlertViewDelegate,HomePageViewDelegate>
{
//  attrs
    User                *m_userSend         ;
    
    NSString            *m_trackViewURL     ;   //新app地址
    
    LogoMiddle          *m_logoMiddleView   ;
    
    NSMutableArray      *m_tagsList ;
}
@end

@implementation IndexViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSaleObjectGoToDifferentDestinationCtrller:) name:NOTIFICATION_INDEXFIRST object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(go2GoodDetail:) name:NOTIFICATION_SECKILL object:nil] ;
 
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_INDEXFIRST  object:nil] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SECKILL     object:nil] ;
}

#pragma mark --
#pragma mark - notification
- (void)getSaleObjectGoToDifferentDestinationCtrller:(NSNotification *)notification
{
    SaleIndex *saleObj = (SaleIndex *)notification.object ;
    
    switch (saleObj.url_type)
    {
        case typeKeywords:
        case typeCatagory:
        {
            HotSearch *tempHotSch = [[HotSearch alloc] initWithType:saleObj.url_type AndWithName:saleObj.url AndWithValue:saleObj.url] ;
            
            // push
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
            SearchViewController *schVC = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"] ;
            schVC.hotSearch = tempHotSch ;
            [schVC setHidesBottomBarWhenPushed:YES] ;
            [self.navigationController pushViewController:schVC animated:YES] ;
        }
            break;
        case typeHtml5:
        {
            NSString *url = saleObj.url ;
            if (!url) return ;
            

            
            // push
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
            MyWebController *webVC = (MyWebController *)[storyboard instantiateViewControllerWithIdentifier:@"MyWebController"] ;
            webVC.urlStr = url;
            webVC.isActivity = YES ;
            [webVC setHidesBottomBarWhenPushed:YES] ;
            [self.navigationController pushViewController:webVC animated:YES] ;
        }
            break;
        default:
            break;
    }
}

- (void)go2GoodDetail:(NSNotification *)notification
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    GoodsDetailViewController *detailVC = (GoodsDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"] ;
    detailVC.codeGoods = notification.object ;
    [detailVC setHidesBottomBarWhenPushed:YES] ;
    [self.navigationController pushViewController:detailVC animated:YES] ;
}


#pragma mark -
- (void)showLogo
{
    if (!m_logoMiddleView)
    {
        m_logoMiddleView = (LogoMiddle *)[[[NSBundle mainBundle] loadNibNamed:@"LogoMiddle" owner:self options:nil] objectAtIndex:0];
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:m_logoMiddleView];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexSpacer.width = 38.0f ;
    self.navigationItem.rightBarButtonItems = @[flexSpacer,item];
    self.navigationItem.hidesBackButton = YES ;
}


/*
 ** ReShow The Data ** 点击没有网络提醒的图片时, 重新刷数据 , public 在外面调用时刷新数据
 **/
- (void)reShowTheData
{
    [super reShowTheData] ;
}



#pragma mark -- setViewStyle
- (void)setViewStyle
{
    self.myTitle = @"首页" ;
    
    self.isDelBarButton       = YES ;
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    [self showLogo] ;
    
}

#pragma mark -- setUpAndDownView 分栏标题和切换

- (void)setUpAndDownView
{

    m_tagsList = [NSMutableArray array] ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:YES] ;
    dispatch_queue_t queue = dispatch_queue_create("indexLoadQueue", NULL) ;
    dispatch_async(queue, ^{
        
        m_tagsList = [DigitInformation shareInstance].g_topTagslist ;
        
        ResultPasel *result = [ServerRequest getIndexListWithTagID:0] ;
        
        dispatch_async(dispatch_get_main_queue(), ^() {
            
            [YXSpritesLoadingView dismiss] ;

            //
//            [self dealTagListWith:result] ;
            
//            _upView = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, 320, 35) ButtonItems:m_tagsList] ;
            _upView.mItemInfoArray  = m_tagsList ;
            _upView.delegate        = self ;
//            [self.view addSubview:_upView] ;
            
            //
//            _contentView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, 35, 320, APPFRAME.size.height - 35 - 20 - 49 - 44)] ;
            [_contentView setContentOfTables:m_tagsList.count] ;  // 滑动列表
            _contentView.delegate = self ;
            [_contentView setResult:result] ;
            _contentView.backgroundColor = [UIColor whiteColor] ;
//            [self.view addSubview:_contentView] ;
            //
            [_upView clickButtonAtIndex:0] ;  // 默认选中第一个button
        });
        
    }) ;
}

//- (void)dealTagListWith:(ResultPasel *)result
//{
//    NSArray *tempTagsList = [result.data objectForKey:@"tags"] ;
//    
//    TagsIndex *tagFirst = [[TagsIndex alloc] init] ;
//    tagFirst.tag_id = 0 ;
//    tagFirst.tag_name = @"全部" ;
//    [m_tagsList addObject:tagFirst] ;
//    
//    for (NSDictionary *dic in tempTagsList)
//    {
//        TagsIndex *tagI = [[TagsIndex alloc] initWithDic:dic] ;
//        [m_tagsList addObject:tagI] ;
//    }
//}
//



#pragma mark --
#pragma mark - 版本检查

- (void)onCheckVersion
{
    if (!G_BOOL_OPEN_APPSTORE) return ;
    
    dispatch_queue_t queue = dispatch_queue_create("versionQueue", NULL) ;
    dispatch_async(queue, ^{
//        [self checkVersionRequest] ;
    }) ;
}

- (void)checkVersionRequest
{
    m_trackViewURL = @"" ;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //  CFShow((__bridge CFTypeRef)(infoDic)) ;
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSString *URL = @"http://itunes.apple.com/lookup?id=928359187";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSLog(@"app : %@",results) ;
    NSDictionary *dic = [results JSONValue];
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count])
    {
        NSDictionary *releaseInfo = [infoArray firstObject];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        float lastVersionFlt    = [lastVersion floatValue]      ;
        float currentVersionFlt = [currentVersion floatValue]   ;
        BOOL bNeedUpdate = currentVersionFlt < lastVersionFlt ;
        if ( bNeedUpdate )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                m_trackViewURL = [releaseInfo objectForKey:@"trackViewUrl"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                alert.tag = 10000 ;
                [alert show] ;
            }) ;
        }
        else
        {
            NSLog(@"此版本为最新版本") ;
        }
    }
}



#pragma mark --
#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==10000)
    {
        if (buttonIndex == 1)
        {
            NSURL *url = [NSURL URLWithString:m_trackViewURL];
            [[UIApplication sharedApplication]openURL:url];
        }
        else
        {
         // terminate app
            
            [LSCommonFunc shutDownAppWithCtrller:self] ;
        }
    }
    
}



#pragma mark --
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//  set View Style
    [self setViewStyle] ;
    
//  setUpAndDownView
    [self setUpAndDownView] ;
    
//  version check
    [self onCheckVersion] ;
    
//  apns call back
    [Apns goToDestinationFromController:self WithApns:[DigitInformation shareInstance].apns] ;
    
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    if (!m_tagsList || m_tagsList.count == 1) {
        m_tagsList = [DigitInformation shareInstance].g_topTagslist ;
        _upView.mItemInfoArray  = m_tagsList ;
        [_contentView setContentOfTables:m_tagsList.count] ;  // 滑动列表
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
    [m_logoMiddleView goMoving] ;
    
//    self.navigationController.navigationBar.translucent = YES ;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]  ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark MenuHrizontalDelegate
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex
{
    NSLog(@"第%d个Button点击了",aIndex);
   
    [_contentView moveScrollowViewAthIndex:aIndex];
}

#pragma mark ScrollPageViewDelegate
- (void)didScrollPageViewChangedPage:(NSInteger)aPage
{
    NSLog(@"CurrentPage:%d",aPage);
    [_upView changeButtonStateAtIndex:aPage];
    
    TagsIndex *currentTagObj = m_tagsList[aPage] ;
    UIScrollView *aScroll = [_contentView freshContentTableAtIndex:aPage WithCurrentTag:currentTagObj];
    
//    [self followScrollView:aScroll] ;

}

- (void)terminateApp
{
    [LSCommonFunc shutDownAppWithCtrller:self] ;
}


#pragma mark -- pro one cell on click notification
- (void)proOnClicked:(NSNotification *)notification
{
    NSString *proCode = (NSString *)notification.object ;
    
    NSLog(@"proCode : %@",proCode) ;
}






#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"index2goodDetail"])
    {
        //
    }
    else if ([segue.identifier isEqualToString:@"index2list"])
    {
        SearchViewController *searchVC = (SearchViewController *)[segue destinationViewController] ;
        searchVC.myCata = (SalesCatagory *)sender ;
    }
    else if ([segue.identifier isEqualToString:@"index2Web"])
    {
        MyWebController *webVC = (MyWebController *)[segue destinationViewController] ;
        webVC.urlStr = (NSString *)sender;
        webVC.isActivity = YES ;
    }
    
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}


@end
