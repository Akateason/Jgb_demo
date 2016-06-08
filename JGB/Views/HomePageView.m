//
//  HomePageView.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-10.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "HomePageView.h"

#import "ImagePlayerView.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "ServerRequest.h"
#import "Activity.h"
#import "UIImage+AddFunction.h"
#import "YXSpritesLoadingView.h"
#import "NSObject+MKBlockTimer.h"
#import "SaleCell.h"
#import "KillSecCell.h"
#import "BannerCell.h"
#import "NavRegisterController.h"
#import "MyWebController.h"
#import "LSCommonFunc.h"
#import "DigitInformation.h"

#define AD_SC_TAG                               15004
#define CX_SC_TAG                               15005

#define SCROLL_INTERVAL                         5.0f

// 拿 特卖 数据
#define MY_PAGE_SIZE                            12

@interface HomePageView () <ImagePlayerViewDelegate,UIAlertViewDelegate>
{
    //1 banner
    NSMutableArray      *m_bannerList ;         //广告datasource
    //2 秒杀
    NSMutableArray      *m_killList ;           //秒杀datasource
    //3  活动
    NSMutableArray      *m_salesIndexList   ;   //活动datasource
    
    int                 m_currentPageNumber ;   //活动页 当前页码
    
    CGRect              m_myFrame ;
    
    BOOL                m_booleanWifi ;
}



@end

@implementation HomePageView

- (instancetype)initWithMyFrame:(CGRect)myFrame
{
    self = [super initWithFrame:myFrame style:UITableViewStyleGrouped];
    if (self)
    {
        NSLog(@"myFrame : %@",NSStringFromCGRect(myFrame)) ;
        m_myFrame = myFrame ;
        
        
        [self setup] ;
        
        m_currentPageNumber = 1 ;
        [self setRefreshViewFrameWithForceHeight:0.0f] ;

    }
    return self;
}


- (void)setMyResult:(ResultPasel *)result
{
    
    if ( result.code != 200 || !result || !result.data || [result.data isKindOfClass:[NSNull class]])
    {
        [self setBackgroundWithWifiSuccess:m_salesIndexList.count] ;
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络异常,请确保您的设备在联网状态下再打开金箍棒" delegate:self cancelButtonTitle:@"知道了,我退出" otherButtonTitles:nil, nil] ;
//        [alert show] ;
        
        return ;
    }
    
    if (![result.data isKindOfClass:[NSNull class]])
    {
        [self parselIndexResult:result] ;
    }
    
    // set table back ground ,
    [self setBackgroundWithWifiSuccess:m_salesIndexList.count] ;
    
    // reload view and frame ,
    [self reloadData] ;
    [self setRefreshViewFrameWithForceHeight:0.0f] ;
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // terminate app
    [self.shutDowndelegate shutDownApp] ;
}



- (void)setup
{
    //  setViewStyle
    self.frame = m_myFrame ;
    
    self.delegate         = self ;
    self.dataSource       = self ;
    self.backgroundColor  = [UIColor whiteColor] ;
    self.separatorStyle   = UITableViewCellSeparatorStyleNone ;

    
    //  refreshTableInitial
    [self setHeaderRefreshView] ;
    [self setFooterRefreshView] ;
    
    //  dataSource
    m_bannerList = [NSMutableArray array] ;
    m_killList = [NSMutableArray array] ;
    m_salesIndexList = [NSMutableArray array] ;
    
}


#pragma mark --

// @return : 首页是否获取成功 ,
- (BOOL)getIndexListFirstTime
{
    
    ResultPasel *result = [ServerRequest getIndexListWithTagID:0] ;
    
    if (result.code != 200 || !result || !result.data || [result.data isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    
    if (![result.data isKindOfClass:[NSNull class]])
    {
        [self parselIndexResult:result] ;
        
        return YES ;
    }
    
    return NO ;
}

- (void)parselIndexResult:(ResultPasel *)result
{
    NSMutableArray *tempBanner  = [NSMutableArray array] ;
    NSMutableArray *tempKill    = [NSMutableArray array] ;
    NSMutableArray *tempSaler   = [NSMutableArray array] ;
    
    //1 get banner
    if (![[result.data objectForKey:@"banner"] isKindOfClass:[NSNull class]])
    {
        NSArray *bannerTempList = [result.data objectForKey:@"banner"] ;
        for (NSDictionary *dic in bannerTempList)
        {
            SaleIndex *bannerSale = [[SaleIndex alloc] initWithDic:dic] ;
            [tempBanner addObject:bannerSale] ;
        }
        m_bannerList = tempBanner ;
    }
    
    //2 get kill list
    if (![[result.data objectForKey:@"miaosha"] isKindOfClass:[NSNull class]])
    {
        NSArray *promotiomTempList = [result.data objectForKey:@"miaosha"] ;
        for (NSDictionary *dic in promotiomTempList)
        {
            Promotiom *promot = [[Promotiom alloc] initWithDic:dic] ;
            [tempKill addObject:promot] ;
        }
    }
    m_killList = tempKill ;
    
    //3 get sale list
    if (![[result.data objectForKey:@"topic"] isKindOfClass:[NSNull class]])
    {
        NSArray *saleTempList = [result.data objectForKey:@"topic"] ;
        for (NSDictionary *dic in saleTempList)
        {
            // 最新特卖
            SaleIndex *saleObj = [[SaleIndex alloc] initWithDic:dic] ;
            [tempSaler addObject:saleObj] ;
        }
        m_salesIndexList = tempSaler ;
    }
    
}



- (BOOL)getActivity
{
    ResultPasel *result = [ServerRequest getActivityWithPage:m_currentPageNumber AndWithTagID:0] ;
    
    if (result.code != 200 || !result || !result.data || [result.data isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    
    if (![result.data isKindOfClass:[NSNull class]])
    {
        NSMutableArray *tempList = [NSMutableArray array] ;
        
        NSArray *salesList = [NSArray array];
        if (![[(result.data) objectForKey:@"topic"] isKindOfClass:[NSNull class]])
        {
            salesList = (NSArray *)[(result.data) objectForKey:@"topic"] ;
        } else {
            return NO ;
        }
        
        for (int i = 0 ; i < [salesList count] ; i++ )
        {
            NSDictionary *tempDic = (NSDictionary *)salesList[i];
            // 最新特卖
            SaleIndex *saleObj = [[SaleIndex alloc] initWithDic:tempDic] ;
            [tempList addObject:saleObj] ;
        }
        
        [m_salesIndexList addObjectsFromArray:tempList] ;
        
        return YES ;
    }
    
    return NO ;
}


#pragma mark --
- (void)setBackgroundWithWifiSuccess:(BOOL)bSuccess
{
    m_booleanWifi = bSuccess ;
    
    if (bSuccess)
    {
        [self setBackgroundView:nil] ;
    }
    else
    {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.frame] ;
        imgV.image = [UIImage imageNamed:@"noNetWork"] ;
        imgV.contentMode = UIViewContentModeScaleAspectFit ;
        [self setBackgroundView:imgV] ;
        
        
        [m_bannerList removeAllObjects] ;
        [m_killList removeAllObjects] ;
        [m_salesIndexList removeAllObjects] ;
    }
}


#pragma mark --
// refresh Table Initial
- (void)setHeaderRefreshView
{
    if (_refreshHeaderView == nil)
    {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [self addSubview:_refreshHeaderView];
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}

//  EGORefreshTableFooterView
- (void)setFooterRefreshView
{
    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero] ;
    _refreshFooterView.delegate = self ;
    [self addSubview:_refreshFooterView] ;
    _reloadingFoot = NO ;
}



#pragma mark --
#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (!m_booleanWifi) return 0 ;
    
    return 3; // 1 banner ,2 kill ,3 activity
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!m_booleanWifi) return 0 ;
    
    
    if (section == 0) { // 1 banner
        return 1 ;
    } else if (section == 1) { // 2 kill
        return 1 ;
    } else if (section == 2) { // 3 activity
        return [m_salesIndexList count] ;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    if (section == 0) { // 1 banner
        static  NSString  *CellIdentiferId = @"BannerCell";
        BannerCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId] ;
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        }
        cell.bannerList = m_bannerList ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        return cell;
    } else if (section == 1) { // 2 kill
        if (!m_killList || !m_killList.count)
        {
            static  NSString  *CellIdentiferId = @"EmptyCell";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId] ;
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:CellIdentiferId];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            UIView *activityHeader = [[[NSBundle mainBundle] loadNibNamed:@"SaleHeader" owner:self options:nil] firstObject] ;
            [cell.contentView addSubview:activityHeader] ;
            
            return cell;
        }
        else
        {
            static  NSString  *CellIdentiferId = @"KillSecCell";
            KillSecCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId] ;
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
            }
            cell.promotionList = m_killList ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            return cell;
        }
    } else if (section == 2) { // 3 activity
        static  NSString  *CellIdentiferId = @"SaleCell";
        SaleCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId] ;
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:CellIdentiferId bundle:nil] forCellReuseIdentifier:CellIdentiferId];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        SaleIndex *saleObj = (SaleIndex *)m_salesIndexList[indexPath.row] ;
        cell.saleObj = saleObj ;
        
        return cell;
    }
    
    
    return nil ;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SaleCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2)
    { // 3 activity
        CABasicAnimation *animation = [TeaAnimation smallBigBestInCell] ;
        [cell.layer addAnimation:animation forKey:@"memeda"] ;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( (indexPath.section == 0) && (!m_bannerList.count) )
    {
        return 1.0f ; // no banner
    }
    else if (indexPath.section == 0) // 1 banner
    {
        return 135.0f ;
    }
    else if (indexPath.section == 1) { // 2 kill
        if (!m_killList || !m_killList.count)
        {
            return 36.0f ;
        } else {
            return 172.0f ;
        }
    }
    else if (indexPath.section == 2) { // 3 toplist
        return 147.0f ; // 1 or 3
    }
    
    return 1.0f ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    if ( (section == 0)|| (section == 1) ) return ;
    
    //  1 get sales url From H5
    int row = indexPath.row ;
    SaleIndex *saleObj = (SaleIndex *)m_salesIndexList[row] ;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_INDEXFIRST object:saleObj] ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;
    return backView ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f ;
}

// custom view for footer. will be adjusted to default or specified footer height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;
    return backView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f ;
}



#pragma mark --
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark --
#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    [self reloadTableViewDataSource];
    
    [self doneLoadingTableViewData] ;
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloadingHead; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark --
#pragma mark - Refresh Header Table
#pragma mark - Header Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloadingHead = YES;
}

- (void)doneLoadingTableViewData
{
    
    float sec = 1.5f ;
    __block BOOL bSuccess ;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0) ;
    dispatch_async(queue, ^{
        
        __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
            
            m_currentPageNumber = 1 ;
            
            bSuccess = [self getIndexListFirstTime] ;
            
        } withPrefix:@"result time"] ;
        
        float smallsec = seconds / 1000.0f ;
        
        if (sec > smallsec) {
            float sleepTime = sec - smallsec ;
            
            dispatch_async(dispatch_get_main_queue(), ^() {
                sleep(sleepTime) ;
                [self finishPullUpMainThreadUIWithSuccess:bSuccess] ;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self finishPullUpMainThreadUIWithSuccess:bSuccess] ;
            });
        }
        
    }) ;
    
}

- (void)finishPullUpMainThreadUIWithSuccess:(BOOL)bSuccess
{
    [self setBackgroundWithWifiSuccess:bSuccess] ;
    
    [self reloadData] ;
    
    //  model should call this when its done loading
    _reloadingHead = NO ;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self] ;
    
    [self setRefreshViewFrameWithForceHeight:0.0f] ;
    
}



#pragma mark --
#pragma mark - Refresh Footer Table
#pragma mark - refreshTableReloadData
//请求数据
- (void)refreshTableReloadData
{
    _reloadingFoot = YES ;
    //新建一个线程来加载数据
    [NSThread detachNewThreadSelector:@selector(requestData)
                             toTarget:self
                           withObject:nil] ;
}

- (void)requestData
{
    //  m_currentSort ;
    __block BOOL hasNew = NO ;
    
    __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
        m_currentPageNumber ++ ;
        hasNew = [self getActivity] ;
        if (!hasNew) m_currentPageNumber-- ;
    } withPrefix:@"result time"] ;
    
    float sec = seconds / 1000.0f ;
    
    NSLog(@"sec : %lf",sec) ;
    
    if (sec < 1.5f) sleep(1.5f - sec) ;
    
    //在主线程中刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadUI:hasNew] ;
    }) ;
}

- (void)reloadUI:(BOOL)hasNew
{
    _reloadingFoot = NO;
    
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self] ;
    
    [self reloadData] ;
    
    //  先刷新table 再设frame
    [self setRefreshViewFrameWithForceHeight:0] ;
    
    if (!hasNew) {
        [DigitInformation showWordHudWithTitle:WD_HUD_NOMORE] ;
    }
    
}

#pragma mark --
#pragma mark - reSet refresh View frame
- (void)setRefreshViewFrameWithForceHeight:(float)forceHeight
{
    float height = 0 ;
    height = (!forceHeight) ? MAX(self.bounds.size.height, self.contentSize.height) : forceHeight ;
    
    _refreshFooterView.frame = CGRectMake(0.0f, height, self.frame.size.width, self.bounds.size.height);
}

#pragma mark - EGORefreshTableFooterDelegate
//出发下拉刷新动作，开始拉取数据
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    [self refreshTableReloadData];
}

//返回当前刷新状态：是否在刷新
- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return _reloadingFoot;
}

//返回刷新时间
- (NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view
{
    return [NSDate date];
}





@end
