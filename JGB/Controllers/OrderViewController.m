//
//  OrderViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "OrderViewController.h"
#import "Goods.h"
#import "CheckOutGoodCell.h"
#import "CheckOutHeadFoot.h"
#import "OrderFootView.h"
#import "ServerRequest.h"
#import "Order.h"
#import "OrderProduct.h"
#import "UIImageView+WebCache.h"
#import "HMSegmentedControl.h"
#import "YXSpritesLoadingView.h"
#import "NSObject+MKBlockTimer.h"
#import "OrderDetailController.h"
#import "OrderStatus.h"
#import "ShipViewController.h"
#import "Payment.h"
#import "PaySuccessController.h"
#import "OrderFilterController.h"

@implementation OrderCurrentSort

- (instancetype)initWithPage:(int)page
               AndWithNumber:(int)number
               AndWithStatus:(int)status
{
    self = [super init];
    if (self)
    {
        self.page   = page ;
        self.number = number ;
        self.status = status ;
    }
    
    return self;
}

@end


#define ONE_PAGE_ORDER         10


@interface OrderViewController () <OrderFootViewDelegate,HMSegmentedControlDelegate,UIAlertViewDelegate>
{
    
    NSMutableArray      *m_orderlist ;
    
    NSMutableArray      *m_arr_queue ;      //status name list
    
    NSArray             *m_statusKey ;      //status key  list
    
    OrderCurrentSort    *m_orderCurrentSort ;
    
    HMSegmentedControl  *m_sg ;
    
//    int                  m_lastSeg ;
    
    int                 m_currentStatus ;
    
    NSArray             *m_segmentStringsList ;
    
    BOOL                m_firstTime ;
    
    NSString            *m_cancelOrderID ;
    

}

@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSuccess) name:NOTIFICATION_PAY_SUCCESS object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseOrderStatusFinished:) name:NOTIFICATION_ORDER_FILTER_POST object:nil] ;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PAY_SUCCESS         object:nil] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ORDER_FILTER_POST   object:nil] ;
}

#pragma mark --
#pragma mark - NOTIFICATION_PAY_SUCCESS
// 支付成功
- (void)paymentSuccess
{
    // push 跳到新的, 支付成功页面 .
    if (!self.view.window) return ;
    
    UIStoryboard         *story         = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    PaySuccessController *successCtrl   = [story instantiateViewControllerWithIdentifier:@"PaySuccessController"] ;
    [self.navigationController pushViewController:successCtrl animated:YES ] ;
}

#pragma mark --
#pragma mark -
// 选择筛选完成
- (void)chooseOrderStatusFinished:(NSNotification *)notification
{
    int orderstatus = [(NSNumber *)notification.object intValue] ;
    m_currentStatus = orderstatus ;
    
    @synchronized (m_orderlist)
    {
        //clear data source
        [m_orderlist removeAllObjects]          ;
        
    }
    
    //set current sort obj
    m_orderCurrentSort.status = m_currentStatus     ;
    m_orderCurrentSort.page   = 1               ;
    
    //show hud
    __block NSDictionary *resultDic ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        // get from server
        resultDic = [ServerRequest getOrderListsWithPage:m_orderCurrentSort.page AndWithNumber:m_orderCurrentSort.number AndWithStatus:m_orderCurrentSort.status] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        int code = [[resultDic objectForKey:@"code"] intValue] ;
        if (code != 200)
        {
            NSLog(@"code != 200") ;
            
            self.isNothing = YES  ;
            
            return ;
        }
        else
        {
            NSArray *dataList = [resultDic objectForKey:@"data"] ;
            
            @synchronized (m_orderlist)
            {
                // set my view
                [self setMyViewsWithResultDic:dataList] ;
            }
            
            //
            [_table reloadData] ;
            
            [self setRefreshViewFrameWithForceHeight:0] ;
        }
        
        //  scroll to sec = 0 row = 0 ;
        if (m_orderlist.count < ONE_PAGE_ORDER) return ;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
        [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES] ;
        
    } AndWithMinSec:0] ;

}


- (void)setBarButtonsItems
{
    m_currentStatus = 0 ;
    
    UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStyleBordered target:self action:@selector(filterTheGoods)] ;
    float flex1 = 10.0f ;
    [filterBarButton setImageInsets:UIEdgeInsetsMake(0, -flex1, 0, flex1)];
    
    self.navigationItem.rightBarButtonItem = filterBarButton ;    
}

- (void)filterTheGoods
{
    [self performSegueWithIdentifier:@"orderlist2orderfilter" sender:nil] ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    [self setBarButtonsItems] ;
    
    // initial
    _table.separatorStyle = UITableViewCellSeparatorStyleNone   ;
    m_orderlist           = [NSMutableArray array]              ;
    m_arr_queue           = [NSMutableArray array]              ;
    m_statusKey           = [NSArray array]                     ;
//    m_lastSeg             = 0                                   ;
    
    self.isOrder          = YES ;
    m_firstTime           = YES ;
    _table.backgroundColor = COLOR_BACKGROUND ;
    [self setupOrderList] ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated] ;
}


- (void)setupOrderList
{
    
    [m_orderlist removeAllObjects] ;

    if (!m_orderCurrentSort)
    {
        m_orderCurrentSort = [[OrderCurrentSort alloc] initWithPage:1 AndWithNumber:ONE_PAGE_ORDER AndWithStatus:0] ;
    }
    
    __block NSDictionary *resultDic ;
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        // get list from server
        resultDic = [ServerRequest getOrderListsWithPage:m_orderCurrentSort.page AndWithNumber:m_orderCurrentSort.number AndWithStatus:m_orderCurrentSort.status] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        int code = [[resultDic objectForKey:@"code"] intValue] ;
        if (code != 200)
        {
            NSLog(@"code != 200") ;
            self.isNothing = YES  ;
            
            return ;
        }
        else
        {
            NSArray *dataList = [resultDic objectForKey:@"data"] ;
            
            // EGORefreshTableFooterView
            [self setRefreshView] ;
            
            // set status
            [self setMyStatus] ;
            
            // set my view
            [self setMyViewsWithResultDic:dataList] ;
            
            // set segment ctrl
            [self setSeg] ;
            
            //
            [_table reloadData] ;
            
            //
            [self setRefreshViewFrameWithForceHeight:0] ;

            if (dataList.count)
            {
                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0] ;
                [_table scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES] ;
            }
                
            m_firstTime = NO ;
        }
        
    } AndWithMinSec:0] ;
    
    
    
}



#pragma mark --
- (void)setRefreshView
{
    if (refreshView) return ;
    
    refreshView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero] ;
    refreshView.delegate = self ;
    [self.table addSubview:refreshView] ;
    reloading = NO ;
}

#pragma mark --
- (void)setSeg
{
        if (!m_firstTime) return ;
    
    NSMutableArray *titleArray = [NSMutableArray array] ;
    m_segmentStringsList = [NSMutableArray array] ;
    int index = 0 ;
    
    for (OrderStatus *status in m_arr_queue)
    {
        
        [titleArray addObject:status.name] ;
        
        index ++ ;
    }
    
    float oneWidth = 62.0f ;
    float segAllWidth = index * oneWidth + 8 ;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.segView.frame] ;
    scrollView.contentSize = CGSizeMake(segAllWidth, self.segView.frame.size.height) ;
    scrollView.bounces = NO ;
    scrollView.showsHorizontalScrollIndicator = NO ;
    
    m_segmentStringsList = titleArray ;

    m_sg = [[HMSegmentedControl alloc] initWithSectionTitles:titleArray];
    
    m_sg.delegate = self ;
    
    [m_sg setSelectionIndicatorHeight:3.0f];
    [m_sg setBackgroundColor:[UIColor whiteColor]];
    [m_sg setTextColor:COLOR_PINK];
    [m_sg setSelectionIndicatorColor:COLOR_PINK];
    [m_sg setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    [m_sg setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    [m_sg setFont:[UIFont boldSystemFontOfSize:12.0f]] ;
    
    [m_sg setFrame:CGRectMake(0, 0, segAllWidth, 35)] ;     //  APPFRAME.size.width - 8
    
    [scrollView addSubview:m_sg] ;
    
    [m_sg addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged] ;
    
    [self.segView addSubview:scrollView] ;
    self.segView.backgroundColor = [UIColor whiteColor] ;
}

#pragma mark -- set My Status
- (void)setMyStatus
{
    if (!m_firstTime) return ;
        
    
    OrderStatus *statusZero = [[OrderStatus alloc] init]    ;
    statusZero.idStatus     = 0                             ;
    statusZero.name         = @"全部"                        ;
    [m_arr_queue addObject:statusZero]                      ;
    
//  Set status name list
    for (OrderStatus *ordSts in G_ORDERSTATUS_DIC)
    {
        [m_arr_queue addObject:ordSts] ;
    }
}


#pragma mark -- set My Views
- (void)setMyViewsWithResultDic:(NSArray *)resultList
{
//-------------------------------------//
    
 //  show nothing pic
    if (! resultList.count)
    {
        if (! m_orderlist.count)
        {
            self.isNothing = YES ;
        }
    }
    else
    {
        self.isNothing = NO ;
    }
    
    [self.view bringSubviewToFront:self.segView] ;
    
 //  current sort page set
    if (! resultList.count)
    {
        if (m_orderCurrentSort.page == 1) return ;
        m_orderCurrentSort.page --               ;

        return ;
    }
    
    
 //   set data source of table
    for (NSDictionary *orderDIc in resultList)
    {
        Order *aOrder = [[Order alloc] initWithDictionary:orderDIc] ;
        [m_orderlist addObject:aOrder]                       ;
    }
    
//-------------------------------------//

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//

- (void)sendCurrentIndexEveryPressed:(int)seg
{
    
}


#pragma mark - theSelectedSegment
/*
- (void)theSelectedSegment:(int)seg
{
    //click self return
    if ( (m_lastSeg == seg)&&(!seg) ) return    ;
    
    @synchronized (m_orderlist)
    {
        //clear data source
        [m_orderlist removeAllObjects]              ;

    }
    
    // get the status key in status diction
    int theStatus = 0 ;
    
    OrderStatus *ordSts = [m_arr_queue objectAtIndex:seg] ;
    theStatus = ordSts.idStatus ;

    //set current sort obj
    m_orderCurrentSort.status = theStatus       ;
    m_orderCurrentSort.page   = 1               ;

    //show hud
    __block NSDictionary *resultDic ;

    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        // get from server
        resultDic = [ServerRequest getOrderListsWithPage:m_orderCurrentSort.page AndWithNumber:m_orderCurrentSort.number AndWithStatus:m_orderCurrentSort.status] ;

    } AndComplete:^{
        [YXSpritesLoadingView dismiss] ;

        int code = [[resultDic objectForKey:@"code"] intValue] ;
        if (code != 200)
        {
            NSLog(@"code != 200") ;
            
            self.isNothing = YES  ;
            
            return ;
        }
        else
        {
            NSArray *dataList = [resultDic objectForKey:@"data"] ;
            
            @synchronized (m_orderlist)
            {
                // set my view
                [self setMyViewsWithResultDic:dataList] ;
            }
 
            //
            [_table reloadData] ;
            
            [self setRefreshViewFrameWithForceHeight:0] ;
        }
        
        //  scroll to sec = 0 row = 0 ;
        if (m_orderlist.count < ONE_PAGE_ORDER) return ;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
        [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES] ;
        
    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
    
}


#pragma mark --
#pragma - HMSegmentedControlDelegate sendCurrentIndex ↑↓

#pragma mark - seg value changed
- (void)valueChanged
{
    NSLog(@"m_lastSeg : %d",m_lastSeg) ;
    
    [self theSelectedSegment:m_sg.selectedIndex]    ;
    
    NSLog(@"m_sg.selectedIndex  :   %d",m_sg.selectedIndex ) ;
    
    m_lastSeg = m_sg.selectedIndex ;
}
*/

#pragma mark - Refresh Table -
#pragma mark --
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

#define     OVERTIME     1.5F

- (void)requestData
{

    __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
        
        m_orderCurrentSort.page ++ ;
        
        NSDictionary *resultDic = [ServerRequest getOrderListsWithPage:m_orderCurrentSort.page AndWithNumber:m_orderCurrentSort.number AndWithStatus:m_orderCurrentSort.status] ;
        
        int code = [[resultDic objectForKey:@"code"] intValue] ;
        if (code == 200)
        {
            NSArray *dataList = [resultDic objectForKey:@"data"] ;
            
            // set my view
            [self setMyViewsWithResultDic:dataList] ;
        }
        
    } withPrefix:@"result time"] ;
    
    float sec = seconds / 1000.0f ;
    
    NSLog(@"sec : %lf",sec) ;
    
    if (sec < OVERTIME) {
        sleep(OVERTIME - sec) ;
    }
    
    //在主线程中刷新UI
    [self performSelectorOnMainThread:@selector(reloadUI)
                           withObject:nil
                        waitUntilDone:NO];
}

- (void)reloadUI
{
    reloading = NO;
    
    [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    
    [self.table reloadData] ;
    
    [self setRefreshViewFrameWithForceHeight:0] ;
}

#pragma mark --
#pragma mark - reSet refresh View frame
- (void)setRefreshViewFrameWithForceHeight:(float)forceHeight
{
    float height = 0 ;

    height = (!forceHeight) ? ( MAX(self.table.bounds.size.height, self.table.contentSize.height)  )  : ( forceHeight  );
    
    //  如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    NSLog(@"height : %lf",height) ;
    refreshView.frame = CGRectMake(0.0f, height , self.view.frame.size.width, self.table.bounds.size.height);
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
    return m_orderlist.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // 商品section   订单内容
    Order *theOrder = (Order *)m_orderlist[section] ;

    if (theOrder == nil) return 0       ;
        
    return theOrder.product.count   ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    Order *theOrder         = (Order *)m_orderlist[indexPath.section] ;
    OrderProduct *product   = (OrderProduct *)(theOrder.product[indexPath.row]) ;
    
    static NSString *TableSampleIdentifier = @"CheckOutGoodCell";
    CheckOutGoodCell *cell = (CheckOutGoodCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier] ;
    if (cell == nil)
    {
        cell = (CheckOutGoodCell *)[[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0] ;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone  ;

    [cell.img setIndexImageWithURL:[NSURL URLWithString:product.images] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(140, 140)] ;
    
    cell.lb_detail.text = product.features ;
    cell.lb_title.text  = product.title ;
    cell.lb_price.text  = [NSString stringWithFormat:@"￥%.2f",product.prices] ;
    cell.lb_price.textColor = [UIColor darkGrayColor] ;
    cell.lb_number.text = [NSString stringWithFormat:@"x%d",product.nums] ;

    return cell ;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.0f ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section:%d",indexPath.section)      ;
    NSLog(@"row    :%d",indexPath.row)          ;
    
    Order *theOrder = (Order *)m_orderlist[indexPath.section]                   ;
    
    [self performSegueWithIdentifier:@"order2detailOrder" sender:theOrder.orderInfo.oid] ;
}


#define TABLEHEADHEIGHT             34

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Order *theOrder = (Order *)m_orderlist[section] ;
    
//  set order number
    CheckOutHeadFoot *headfoot = (CheckOutHeadFoot *)[[[NSBundle mainBundle] loadNibNamed:@"CheckOutHeadFoot" owner:self options:nil] objectAtIndex:0];
    
    NSString *strStatus = [self getStatusStrWithOrder:theOrder] ;
    headfoot.lb_key.text = [NSString stringWithFormat:@"%@",strStatus];
    headfoot.lb_key.textColor = COLOR_PINK ;
    headfoot.lb_key.font = [UIFont boldSystemFontOfSize:12.0f] ;
    
    [headfoot.lb_key sizeToFit] ;
    headfoot.lb_key.minimumScaleFactor = 0.5f ;
    
//  set order sum price
    int  proNum = 0 ;
    float sumPrice = 0.0f ;
    for ( int i = 0 ; i < theOrder.product.count ; i ++ )
    {
        OrderProduct *product   = (OrderProduct *)(theOrder.product[i]) ;
        sumPrice += product.nums * product.prices ;
        proNum ++ ;
    }
    headfoot.lb_price.text = [NSString stringWithFormat:@"共 %d 件商品  合计: ￥%.2f",proNum,sumPrice] ;

    return headfoot ;
}

- (NSString *)getStatusStrWithOrder:(Order *)order
{
    NSString *statusStr = @""       ;
    for (OrderStatus *status in G_ORDERSTATUS_DIC)
    {
        if (order.orderInfo.status == status.idStatus)
        {
            statusStr = status.name ;
        }
    }
    
    return statusStr ;
}


- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLEHEADHEIGHT ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    Order *theOrder                = (Order *)m_orderlist[section] ;
    
    OrderFootView *orderFoot       = (OrderFootView *)[[[NSBundle mainBundle] loadNibNamed:@"OrderFootView" owner:self options:nil] objectAtIndex:0] ;
    orderFoot.delegate             = self       ;
    orderFoot.section              = section    ;
    orderFoot.order                = theOrder   ;
    orderFoot.isNeedDetail         = YES ;
    
    return orderFoot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f ;
}



#pragma mark --
#pragma mark - OrderFootViewDelegate
/*
 *  1.section  :  表示所点击属于哪一section
 *  2.order
 *  3.title    :  按钮文字
 */

#define TITLE_SEE_ORDER         @"查看订单"
#define TITLE_CANCEL_ORDER      @"取消订单"
#define TITLE_PAY_NOW           @"立即付款"
#define TITLE_SEE_SHIP          @"查看物流"
#define TITLE_CHECK_OUT         @"确认收货"

- (void)callBackWithSection:(int)section
         AndWithButtonTitle:(NSString *)title
{
    NSLog(@"the current section is %d",section) ;
    NSLog(@"title : %@",title)                  ;
    
    Order *theOrder = (Order *)m_orderlist[section]                                 ;
    
    if ([title isEqualToString:TITLE_SEE_ORDER])            //查看订单
    {
        [self performSegueWithIdentifier:@"order2detailOrder" sender:theOrder.orderInfo.oid]     ;
    }
    else if ([title isEqualToString:TITLE_CANCEL_ORDER])    //取消订单
    {
        m_cancelOrderID = theOrder.orderInfo.oid ;
        
        NSString *title = NSLocalizedString(@"确认要取消订单吗?", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"不", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil] ;
        [alertView show] ;
        
    }
    else if ([title isEqualToString:TITLE_PAY_NOW])         //立即付款
    {
        G_ORDERID_STR = theOrder.orderInfo.oid ;
        [Payment goToAliPayWithOrderStr:theOrder.orderInfo.oid] ;
    }
    else if ([title isEqualToString:TITLE_SEE_SHIP])        //查看物流
    {

        [self performSegueWithIdentifier:@"order2ship" sender:theOrder] ;
                
    }
    else if ([title isEqualToString:TITLE_CHECK_OUT])       //确认收货
    {
        [self performSegueWithIdentifier:@"order2ship" sender:theOrder] ;
    }
    
}

#pragma mark --
#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //确认取消
        ResultPasel *result = [ServerRequest orderCancelWithOrderIDStr:m_cancelOrderID] ;
        if (result.code == 200)
        {
            [self setupOrderList] ;
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"order2detailOrder"])
    {
        OrderDetailController *orderDetailCtrller = (OrderDetailController *)[segue destinationViewController] ;
        orderDetailCtrller.orderIDStr             = (NSString *)sender ;
    }
    else if ([segue.identifier isEqualToString:@"order2ship"])
    {
        ShipViewController *shipVC = (ShipViewController *)[segue destinationViewController] ;
        shipVC.parcelID = ((Order *)sender).orderInfo.orderID ;
        shipVC.orderIdStr = ((Order *)sender).orderInfo.oid ;
    }
    else if ([segue.identifier isEqualToString:@"orderlist2orderfilter"])
    {
        OrderFilterController *filterVC = (OrderFilterController *)[segue destinationViewController] ;
        filterVC.orderStatus = m_currentStatus ;
    }
    
}

@end
