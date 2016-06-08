//
//  SearchViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "SearchViewController.h"
#import "CatagoryCell.h"
#import "SalesCatagory.h"
#import "HistoryHotCell.h"
#import "HeadView_history.h"
#import "ServerRequest.h"
#import "SBJson.h"
#import "Goods.h"
#import "SearchHistoryTB.h"
#import "SDImageCache.h"
#import "NSObject+MKBlockTimer.h"
#import "Select_val.h"
#import "FilterViewController.h"
#import "FilterView.h"
#import "YXSpritesLoadingView.h"
#import "GoodsDetailViewController.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "LSCommonFunc.h"
#import "MyWebController.h"

#define TABLE_CATAGORY_HEIGHT       60.0
#define MY_PAGE_SIZE                20

#define NOTIFICATION_GOTO_SEARCH    @"NOTIFICATION_GOTO_SEARCH"


@implementation CurrentSort

- (instancetype)initWithPage:(int)page
                 AndWithSize:(int)size
             AndWithSellerID:(NSString *)seller_id
                AndWithTitle:(NSString *)title
                AndWithBrand:(NSString *)brand
             AndWithCategory:(NSString *)category
             AndWithLowPrice:(float)low_price
            AndWithHighPrice:(float)hig_price
             AndWithOrderVal:(int)order_val
             AndWithOrderWay:(int)order_way
                   AndWithCN:(int)isCN
                   AndWithCX:(int)isCX
          AndWithWareHouseID:(int)wareHouseID
{
    self = [super init];
    if (self)
    {
        self.page           = page ;
        self.size           = size ;
        self.sellerID       = seller_id ;
        self.title          = title ;
        self.brand          = brand ;
        self.catagory       = category ;
        self.lowPrice       = low_price ;
        self.highPrice      = hig_price ;
        self.orderVal       = order_val ;
        self.orderWay       = order_way ;
        self.is_cn          = isCN ;
        self.is_cx          = isCX ;
        self.wareHouse_ID   = wareHouseID ;
    }
    return self;
}


- (void)shiftMode:(NSString *)shiftMode
{
    if ([shiftMode isEqualToString:SEG_WD_DEFAULT]) {
        self.orderVal = -1 ;
        self.orderWay = -1 ;
    }else if ([shiftMode isEqualToString:SEG_WD_PRI_DES]) {
        self.orderVal = 1 ;
        self.orderWay = 2 ;
    }else if ([shiftMode isEqualToString:SEG_WD_PRI_ASC]) {
        self.orderVal = 1 ;
        self.orderWay = 1 ;
    }else if ([shiftMode isEqualToString:SEG_WD_CMT_DES]) {
        self.orderVal = 2 ;
        self.orderWay = 2 ;
    }else if ([shiftMode isEqualToString:SEG_WD_CMT_ASC]) {
        self.orderVal = 2 ;
        self.orderWay = 1 ;
    }
}

@end


@interface SearchViewController ()<HMSegmentedControlDelegate,HeadViewHistoryDelegate,FilterViewDelegate,HistoryHotCellDelegate>
{
    HMSegmentedControl  *m_sg;
    
//  data source
    NSMutableArray      *m_arr_goodsList ;      //商品列表

//  sort head
    NSMutableArray      *m_arr_queue     ;      //head sort
    CurrentSort         *m_currentSort   ;      //
    int                  m_lastSeg       ;
    Select_val          *m_selectVal     ;      //筛选 . current
    
    NSArray             *m_brandlist     ;      //品牌

    FilterView          *m_filterView    ;

}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES] ;
}


- (void)setup
{

    m_arr_queue     = [NSMutableArray arrayWithArray:@[@"默认", @"价格 ↓",@"好评 ↓"]];
    m_lastSeg       = 0 ;
    
    //  initial data source
    m_brandlist     = [NSArray array] ;
    m_arr_goodsList = [NSMutableArray array] ;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = (_strBeSearch == nil) ? @"" : _strBeSearch ;

//  setup
    [self setup] ;
    
//  set all views
    [self showViews] ;
    
//  wait server load ...  getCatagories
    if (_hotSearch != nil)
    {
        //  热词搜索
        [self goDifferentViewControllerWithHotSearch:_hotSearch] ;
    }
    else if ( (!_strBeSearch) || ([_strBeSearch isEqualToString:@""]) )
    {
        //  类目搜索
        [self showGoodsListsWithCataID:_myCata.id_] ;
    }
    else
    {
        //  有搜索内容
        [self goForSearchingWithText:_strBeSearch] ;
    }
    
}


- (void)goDifferentViewControllerWithHotSearch:(HotSearch *)hotsearch
{
    switch (hotsearch.type)
    {
        case typeKeywords:
        {
            [self goForSearchingWithText:hotsearch.value] ;
        }
            break;
        case typeCatagory:
        {
            [self showGoodsListsWithCataID:[hotsearch.value intValue]] ;
        }
            break;
        case typeHtml5:
        {
            [self goToHtml5View:hotsearch.value] ;
            
            return ;
        }
            break;
        default:
            break;
    }
}


- (void)goToHtml5View:(NSString *)strHtml
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyWebController *mywebCtrller = (MyWebController *)[storyboard instantiateViewControllerWithIdentifier:@"MyWebController"];
    mywebCtrller.urlStr = strHtml ;
    mywebCtrller.isActivity = YES ;
    
    [self.navigationController pushViewController:mywebCtrller animated:YES] ;
}


- (void)goForSearchingWithText:(NSString *)text
{
    if (text != nil)
    {
        [self searchingWithText:text] ;
        [_tableCategory reloadData];
    }
}


- (void)showViews
{
    //1  setBarButtonsItems
    [self setBarButtonsItems] ;
    
    //2  EGORefreshTableFooterView
    [self setFooterRefreshView] ;
}

//  EGORefreshTableFooterView
- (void)setFooterRefreshView
{
    refreshView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero];
    refreshView.delegate = self;
    [self.tableCategory addSubview:refreshView];
    reloading = NO;
    
    [self setRefreshViewFrameWithForceHeight:APPFRAME.size.height] ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    m_selectVal = G_SELECT_VAL ;
    [m_filterView.table reloadData] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSearch:) name:NOTIFICATION_GOTO_SEARCH object:nil] ;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GOTO_SEARCH object:nil] ;

}

#pragma mark --
#pragma mark - notification
- (void)postSearch:(NSNotification *)notification
{
//    self.title = @"" ;
    [m_arr_goodsList removeAllObjects] ;
    
    HotSearch *hotSearch = (HotSearch *)notification.object ;
    
    [self goDifferentViewControllerWithHotSearch:hotSearch] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
#pragma mark --
#pragma mark - show Catagories And Hud
- (void)showGoodsListsWithCataID:(int)cataID
{
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
//    _tableCategory.hidden = YES ;
        
        m_currentSort = [[CurrentSort alloc] initWithPage:1 AndWithSize:MY_PAGE_SIZE AndWithSellerID:nil AndWithTitle:nil AndWithBrand:nil AndWithCategory:[NSString stringWithFormat:@"%d",cataID] AndWithLowPrice:-1 AndWithHighPrice:-1 AndWithOrderVal:-1 AndWithOrderWay:-1 AndWithCN:-1 AndWithCX:-1 AndWithWareHouseID:0];
        NSString *response = [ServerRequest getGoodsListWithCurrentSort:m_currentSort] ;
        [self parserResponse:response AndRememberSelectVal:NO] ;
        
//        m_brandlist = [self setBrandListWithCateNum:cataID] ;
        
    }
       AndComplete:^{
            _tableCategory.hidden = NO ;
           
           [self showSearchResult] ;                    //reload table
           
           [self setRefreshViewFrameWithForceHeight:0];
           
           // set background if no network or no result return .
           [self setBackgroundWithWifiSuccess:m_arr_goodsList.count] ;

           [YXSpritesLoadingView dismiss]    ;
       }
       AndWithMinSec:0
    ];
}

#pragma mark --
#pragma mark - setBarButtonsItems
- (void)setBarButtonsItems
{
    UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStyleBordered target:self action:@selector(filterTheGoods)] ;
    float flex1 = 10.0f ; //15
    [filterBarButton setImageInsets:UIEdgeInsetsMake(0, -flex1, 0, flex1)];

    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleBordered target:self action:@selector(goSearch)] ;
    float flex = 10.0f ;  //25.0f
    [searchBarButton setImageInsets:UIEdgeInsetsMake(0, flex, 0, -flex)];
    
    
    NSArray *items = @[filterBarButton,searchBarButton] ;
    self.navigationItem.rightBarButtonItems = items ;
    
}

- (void)goSearch
{
    [LSCommonFunc popModalSearchViewWithCurrentController:self] ;
}


- (BOOL)parserResponse:(NSString *)response AndRememberSelectVal:(BOOL)remeber
{
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *diction = [parser objectWithString:response] ;
    int code = [[diction objectForKey:@"code"] intValue];
    if (code == 200)
    {
        NSDictionary *dataDic = [diction objectForKey:@"data"] ;
        NSString *total = [dataDic objectForKey:@"total"] ;
        if (( ( !total ) || [total isKindOfClass:[NSNull class]] ) || ![total intValue] )
        {
        //  failure or nothing

            return NO;
        }
        else
        {
        //  success
            NSArray *list = (NSArray *)[dataDic objectForKey:@"list"] ;
            if ( (list == nil)||(list == NULL)||([list isKindOfClass:[NSNull class]]) )
            {
                m_currentSort.page -- ;
                return NO;
            }
            //1 good lists
            for (NSDictionary *goodDic in list)
            {
                //NSDictionary *goodDic = [list objectForKey:keyStr] ;
                Goods *goodTemp = [[Goods alloc] initWithDic:goodDic] ;
                [m_arr_goodsList addObject:goodTemp] ;
            }
            //2 select value
            NSDictionary *selectValueDic = (NSDictionary *)[dataDic objectForKey:@"select_val"] ;
            Select_val *sVal = [[Select_val alloc] initWithDictionary:selectValueDic] ;

            if (!remeber)
            {// not remember
                m_selectVal  = sVal ;
                G_SELECT_VAL = sVal ;
            }
            else
            {// remember
                sVal.currentPriceArea = m_selectVal.currentPriceArea;
                sVal.currentSellers   = m_selectVal.currentSellers  ;
//                sVal.currentCatagory  = m_selectVal.currentCatagory ;
                sVal.currentBrandSTR  = m_selectVal.currentBrandSTR ;
                sVal.isOnSales        = m_selectVal.isOnSales       ;
                sVal.isChinese        = m_selectVal.isChinese       ;
//                sVal.cataStrCache     = m_selectVal.cataStrCache    ;
                
                m_selectVal  = sVal ;
                G_SELECT_VAL = sVal ;
            }
        }
    }
    else
    {
        return NO;
    }
    
    
    return YES;
}

#pragma mark --
#pragma mark - showSearchResult
- (void)showSearchResult
{
//  _historyAndHotView.hidden = YES   ;

    [_tableCategory reloadData] ;
    
//    self.navigationItem.rightBarButtonItem = m_filterBarButton  ;
}

#pragma mark --
#pragma mark - Refresh Table
#pragma mark - refreshTableReloadData
//请求数据
- (void)refreshTableReloadData
{
    reloading = YES ;
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
        m_currentSort.page ++ ;
        NSString *response = [ServerRequest getGoodsListWithCurrentSort:m_currentSort] ;
        hasNew = [self parserResponse:response AndRememberSelectVal:NO] ;
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
	reloading = NO;
    
	[refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableCategory] ;
    
    [self.tableCategory reloadData] ;
    
    //  先刷新table 再设frame
    [self setRefreshViewFrameWithForceHeight:0] ;
    
    if (hasNew)
    {
        int row = (m_currentSort.page - 1) * MY_PAGE_SIZE ;
        NSIndexPath *ipath = [NSIndexPath indexPathForRow:row inSection:0] ;
        [self.tableCategory scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:YES] ;
    }
}

#pragma mark --
#pragma mark - reSet refresh View frame
- (void)setRefreshViewFrameWithForceHeight:(float)forceHeight
{
    float height = 0 ;
    height = (!forceHeight) ? MAX(self.tableCategory.bounds.size.height, self.tableCategory.contentSize.height) : forceHeight ;

    refreshView.frame = CGRectMake(0.0f, height, self.view.frame.size.width, self.tableCategory.bounds.size.height);
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
    return reloading;
}

//返回刷新时间
- (NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view
{
    return [NSDate date];
}

#pragma mark --
#pragma mark - UIScrollView
//此代理在scrollview滚动时就会调用
//在下拉一段距离到提示松开和松开后提示都应该有变化，变化可以在这里实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
}

//松开后判断表格是否在刷新，若在刷新则表格位置偏移，且状态说明文字变化为loading...
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == _tableCategory)
    {
        //结果
        return [m_arr_goodsList count] ;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableCategory)
    {
        //搜索结果good list
        SelectGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectGoodCell"];
        if (cell == nil)
        {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SelectGoodCell" owner:self options:nil];
            cell = [nibs objectAtIndex:0];
        }
        if (indexPath.row > m_arr_goodsList.count)
        {
            return cell ;
        }
        
        cell.myGood = (Goods *)[m_arr_goodsList objectAtIndex:indexPath.row] ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置cell的显示动画为3D缩放
    CABasicAnimation *animation = [TeaAnimation smallBigBestInCell] ;
    [cell.layer addAnimation:animation forKey:@"memeda"] ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableCategory)
    {
        //详情
        //result  go to good s detail .. .
        Goods *myGood = (Goods *)[m_arr_goodsList objectAtIndex:indexPath.row]  ;
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
        GoodsDetailViewController *detailVC = (GoodsDetailViewController *)[story instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"] ;
        detailVC.codeGoods = myGood.code        ;
        
        NSString *cate = [[myGood.category componentsSeparatedByString:@","] firstObject];
        detailVC.category  = cate ;
        [self.navigationController pushViewController:detailVC animated:YES] ;
    }
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableCategory)
    {
        //结果
        return 115.0f ;
    }
    
    return 1.0 ;
}

#define TABLEHEADHEIGHT     40
#pragma mark -- 将排序暂时注销
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    if (tableView == _tableCategory)
    {
        //结果
        if (m_sg == nil)
        {
        //  @"↑↓"
            [self newTableHead] ;
        }
        
        return m_sg;
    }
    
    return nil;
}

#pragma - newTableHead
- (void)newTableHead
{
    m_sg = [[HMSegmentedControl alloc] initWithSectionTitles:m_arr_queue];
    m_sg.delegate = self ;
    [m_sg setSelectionIndicatorHeight:4.0f];
    [m_sg setBackgroundColor:[UIColor whiteColor]];
    [m_sg setTextColor:COLOR_PINK];
    [m_sg setSelectionIndicatorColor:COLOR_PINK];
    [m_sg setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    [m_sg setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    [m_sg setFont:[UIFont boldSystemFontOfSize:15]] ;
    [m_sg setCenter:CGPointMake([UIScreen mainScreen].applicationFrame.size.width/2.0f, 120)];
    [m_sg addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged] ;
    BOOL b = NO ;
    for (UIView *sub in self.view.subviews)
    {
        if ([sub isKindOfClass:[HMSegmentedControl class]])
        {
            b = YES ;
            return ;
        }
    }
    if (!b)
    {
        [self.view addSubview:m_sg];
    }
}


#pragma --
#pragma - HMSegmentedControlDelegate sendCurrentIndex ↑↓
// only shift asc des
- (void)sendCurrentIndexEveryPressed:(int)seg
{
//    @"↑↓"
//    @[@"默认", @"热卖", @"价格↓",@"好评↓"]
    NSString *newStr ;
    NSString *str = [m_arr_queue objectAtIndex:seg] ;
    int toIndex = 3 ;   //价格↓,
    if ([str hasSuffix:@"↓"])
    {
        NSString *substr = [str substringToIndex:toIndex];
        newStr = [substr stringByAppendingString:@"↑"] ;
        [self changeStr:newStr AndWithSeg:seg];
    }
    else if([str hasSuffix:@"↑"])
    {
        NSString *substr = [str substringToIndex:toIndex];
        newStr = [substr stringByAppendingString:@"↓"] ;
        [self changeStr:newStr AndWithSeg:seg];
    }

    [self theSelectedSegment:m_sg.selectedIndex]    ;
}

- (void)changeStr:(NSString *)newStr AndWithSeg:(int)seg
{
    [m_arr_queue replaceObjectAtIndex:seg withObject:newStr] ;
    
    [m_sg setSectionTitles:m_arr_queue] ;
    [m_sg setNeedsDisplay]              ;
}

#pragma mark --
#pragma mark - seg value changed
- (void)valueChanged
{
    [self theSelectedSegment:m_sg.selectedIndex] ;
}

#pragma mark - the Selected Segment
- (void)theSelectedSegment:(int)seg
{
    m_currentSort.page = 1 ;
    
    if ( (m_lastSeg == seg)&&(!seg) )
    {
        return ;
    }
    
    [m_arr_goodsList removeAllObjects] ;
    NSString *string = [m_arr_queue objectAtIndex:seg] ;
    NSLog(@"string : %@",string) ;
    __block NSString *response ;
    [m_currentSort shiftMode:string] ;

    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        if ([string isEqualToString:SEG_WD_DEFAULT])
        {
            response = [ServerRequest getGoodsListWithCurrentSort:m_currentSort];
        }
        else if ([string isEqualToString:SEG_WD_PRI_DES])
        {
            response = [ServerRequest getGoodsListWithCurrentSort:m_currentSort];
        }
        else if ([string isEqualToString:SEG_WD_PRI_ASC])
        {
            response = [ServerRequest getGoodsListWithCurrentSort:m_currentSort];
        }
        else if ([string isEqualToString:SEG_WD_CMT_DES])
        {
            response = [ServerRequest getGoodsListWithCurrentSort:m_currentSort];
        }
        else if ([string isEqualToString:SEG_WD_CMT_ASC])
        {
            response = [ServerRequest getGoodsListWithCurrentSort:m_currentSort];
        }
    } AndComplete:^{
        m_lastSeg = seg ;
        [self ShowNewGoodsListWithRespose:response] ;
        
        //  scroll to sec = 0 row = 0 ;
        if (m_arr_goodsList.count < MY_PAGE_SIZE) return ;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
        [self.tableCategory scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES] ;
        
        [YXSpritesLoadingView dismiss] ;
    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;

}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableCategory)
    {
        return TABLEHEADHEIGHT  ;
    }
    
    return 32;
}
*/
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *back            = [[UIView alloc] init];
    back.backgroundColor    = [UIColor clearColor] ;
    return back;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}



#pragma mark --
#pragma mark - searchingWithText
- (void)searchingWithText:(NSString *)text
{
    __block NSString *response ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        m_currentSort = [[CurrentSort alloc] initWithPage:1 AndWithSize:MY_PAGE_SIZE AndWithSellerID:nil AndWithTitle:text AndWithBrand:nil AndWithCategory:nil AndWithLowPrice:-1 AndWithHighPrice:-1 AndWithOrderVal:-1 AndWithOrderWay:-1 AndWithCN:-1 AndWithCX:-1 AndWithWareHouseID:0] ;
        response = [ServerRequest getGoodsListWithCurrentSort:m_currentSort] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        [self ShowNewGoodsListWithRespose:response] ;
        
        if (m_arr_goodsList.count)
        {
            // 有东西返回
            dispatch_queue_t queue = dispatch_queue_create("DBq1",NULL) ;
            dispatch_async(queue, ^{
                [self updateOrNewHistoryWithText:text] ;
            }) ;
        }

        // set background if no network or no result return .
        [self setBackgroundWithWifiSuccess:m_arr_goodsList.count] ;
        
    } AndWithMinSec:0] ;
}



- (void)setBackgroundWithWifiSuccess:(BOOL)bSuccess
{
    if (bSuccess)
    {
        [_tableCategory setBackgroundView:nil] ;
    }
    else {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:_tableCategory.frame] ;
        imgV.image = [UIImage imageNamed:@"noGoods"] ;
        imgV.contentMode = UIViewContentModeScaleAspectFit ;
        [_tableCategory setBackgroundView:imgV] ;
    }
}



#pragma mark --
#pragma mark - 筛选

#define ANIMATIONDURATION  0.3f

- (void)filterTheGoods
{
    [self animationWithDuration:ANIMATIONDURATION AndWithIsEnter:YES] ;
    [self showFilterViewWithBrandList:m_brandlist] ;
}


- (NSArray *)setBrandListWithCateNum:(int)cateNum
{
    NSMutableArray *arrTemp = [NSMutableArray array] ;
    if ( !([m_selectVal.hotBrandArray isKindOfClass:[NSNull class]] || m_selectVal.hotBrandArray == nil) )
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:m_selectVal.hotBrandArray forKey:@"热"] ;
        [arrTemp addObject:dic] ;
    }
    
    NSDictionary *dataDic = [ServerRequest getBrandListWithCateNum:cateNum] ;   //_myCata.id_
    NSArray *letterKey = [dataDic allKeys] ;
    
    if (dataDic != nil)
    {
        for (NSString *letter in letterKey)
        {
            NSArray *arrDic = [dataDic objectForKey:letter]     ;
            NSMutableArray *newList = [NSMutableArray array]    ;
            for (NSDictionary *dicBrand in arrDic)
            {
                Brand *abrand = [[Brand alloc] initWithDic:dicBrand] ;
                [newList addObject:abrand] ;
            }
            NSDictionary *newDic = [NSDictionary dictionaryWithObjectsAndKeys:newList,letter, nil] ;
            [arrTemp addObject:newDic] ;
        }
    }
    
    return arrTemp ;
}

- (void)showFilterViewWithBrandList:(NSArray *)brandList
{
    m_filterView = (FilterView *)[[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] lastObject];
    m_filterView.delegate = self ;
    m_filterView.m_selectVal = m_selectVal  ;
    m_filterView.brandList = brandList ;
    
    [self.view addSubview:m_filterView]     ;
    
    m_filterView.frame = [UIScreen mainScreen].bounds ;
}


- (void)animationWithDuration:(double)duration AndWithIsEnter:(BOOL)isEnter
{
    if (isEnter) {
        [TeaAnimation animationRevealFromLeft:self.view] ;
    }
    else {
        [TeaAnimation animationRevealFromRight:self.view] ;
    }
    
    if (isEnter)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES] ;
    }
    
   
}

#pragma mark --
#pragma mark - FilterViewDelegate
/*
 * when selectValue = nil means cancel
 * otherwise commit and send param
 **/
- (void)commitOrCancelWithFlag:(BOOL)b
{

    //shut down filter View
    [self shutDownFilterView] ;
    
    if (![DigitInformation isConnectionAvailable]) {
        return ;
    }
    
    
    if (!b)
    {
    //  CANCEL
        [self refreshSearchResult] ;
        return ;
    }
    
    //  COMMIT
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    
    [DigitInformation showHudWhileExecutingBlock:^{
        
        //  do select server with new select value
        
        //1 wareHouse ID
        int wareID = 0 ;
        if (m_selectVal.currentSellers  != -1)
        {
            wareID = ((WareHouse *)[[DigitInformation shareInstance].g_wareHouseList objectAtIndex:m_selectVal.currentSellers]).idWarehouse ;            
        }
        //2 catagoryStr
        NSString *catagoryStr = [NSString stringWithFormat:@"%d",_myCata.id_] ;
        
        //3 price area
        int priceMin = -1 ;
        int priceMax = -1 ;
        if (m_selectVal.currentPriceArea != -1)
        {
            Price_area *area = (Price_area *)[m_selectVal.priceAreaArray objectAtIndex:m_selectVal.currentPriceArea] ;
            priceMin = area.price_min ;
            priceMax = area.price_max ;
        }
        //4 is chinese / is on sale already initial
        
        //5 brand name
        NSString *brand = m_selectVal.currentBrandSTR;
        
        // Do select server with new select value //
        m_currentSort = [[CurrentSort alloc] initWithPage:1 AndWithSize:MY_PAGE_SIZE AndWithSellerID:nil AndWithTitle:nil AndWithBrand:brand AndWithCategory:catagoryStr AndWithLowPrice:priceMin AndWithHighPrice:priceMax AndWithOrderVal:-1 AndWithOrderWay:-1 AndWithCN:m_selectVal.isChinese AndWithCX:m_selectVal.isChinese AndWithWareHouseID:wareID] ;
        
        NSString *response = [ServerRequest getGoodsListWithCurrentSort:m_currentSort] ;
        
        [m_arr_goodsList removeAllObjects] ;
        
        [self parserResponse:response AndRememberSelectVal:YES] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        [self refreshSearchResult] ;

        // set background if no network or no result return .
        [self setBackgroundWithWifiSuccess:m_arr_goodsList.count] ;

    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
    
}

- (void)refreshSearchResult
{
    [self showSearchResult] ;
    [self setRefreshViewFrameWithForceHeight:0] ;
    if (m_arr_goodsList.count)
    {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0] ;
        [self.tableCategory scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionNone animated:YES] ;
    }
}


//shut down filter View
- (void)shutDownFilterView
{
    [self animationWithDuration:ANIMATIONDURATION AndWithIsEnter:NO] ;
    m_filterView.delegate = nil         ;
    [m_filterView removeFromSuperview]  ;
}

/*
 ** flag             品牌 价格 商城
 ** selectValue      ...
 **/
- (void)go2FliterControllerWithFlag:(NSString *)flag
                       AndWithValue:(Select_val *)selectValue
                   AndWithBrandList:(NSArray *)brandlist
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    FilterViewController *filterVC = (FilterViewController *)[story instantiateViewControllerWithIdentifier:@"FilterViewController"] ;
    filterVC.m_selectValue = selectValue                    ;
    filterVC.flag          = flag                           ;
    filterVC.cateNum       = _myCata.id_                    ;
    filterVC.m_brandList   = brandlist                      ;
    
    [self.navigationController pushViewController:filterVC animated:YES] ;
}



#pragma mark --
#pragma mark - updateOrNewHistoryWithText
//---  if list not null, save search history to DB  ---//
//1. select first ,
//2. if is  exist , update old,  time and schNum
//3. if not exist , new one insert
- (void)updateOrNewHistoryWithText:(NSString *)text
{
    SchHistory *extHistory = [[SearchHistoryTB shareInstance] isExistSelectHistory: text] ;
    
    BOOL success ;
    
    if (extHistory.searchID)
    {
        // exist    ,   update old
        int sum = extHistory.searchSum + 1;
        success = [[SearchHistoryTB shareInstance] updateTime:[MyTick getTickWithDate:[NSDate date]] AndWithSum:sum AndWithID:extHistory.searchID] ;
    }
    else
    {
        // not exist ,  insert new
        SchHistory *insertHistory = [[SchHistory alloc] init] ;
        insertHistory.searchID = [[SearchHistoryTB shareInstance] getMaxCID] + 1;
        insertHistory.searchString    = text ;
        insertHistory.lastSearchTime  = [MyTick getTickWithDate:[NSDate date]] ;
        insertHistory.searchSum = 1 ;
        
        success = [[SearchHistoryTB  shareInstance] insertSchHistory:insertHistory
                   ];
    }
    
    NSLog(@"success : %d",success) ;
}


#pragma mark --
#pragma mark - ShowNewGoodsListWithRespose
- (BOOL)ShowNewGoodsListWithRespose:(NSString *)response
{
    BOOL bSuccess = [self parserResponse:response AndRememberSelectVal:NO] ;
    
    [self showSearchResult] ;
    [self setRefreshViewFrameWithForceHeight:0];
    
    return bSuccess ;
}




@end



