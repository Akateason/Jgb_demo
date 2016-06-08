//
//  OrderDetailController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "OrderDetailController.h"
#import "CheckOutAddrCell.h"
#import "OrderShipCell.h"


#import "CheckOutGoodCell.h"
#import "ServerRequest.h"
#import "Order.h"
#import "OrderFootView.h"
#import "OrderProduct.h"
#import "ReceiveAddress.h"
#import "SellerTB.h"
#import "Seller.h"
#import "ShipViewController.h"
#import "OrderStatus.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "District.h"
#import "DistrictTB.h"
#import "SubOrderCell.h"
#import "OrderConditionCell.h"
#import "COcoupsonCell.h"
#import "PayWayCell.h"
#import "Coupon.h"
#import "COOrderMoneyCell.h"
#import "DetailCellObj.h"
#import "Payment.h"
#import "PaySuccessController.h"
#import "GoodsDetailViewController.h"
#import "YXSpritesLoadingView.h"
#import "SubOrderHeader.h"
#import "OrderBottomCell.h"


#define NOTIFICATION_PRESS_PRODUCT_IN_ORDERDETAIL   @"NOTIFICATION_PRESS_PRODUCT_IN_ORDERDETAIL"

@interface OrderDetailController ()<OrderFootViewDelegate,SubOrderHeaderDelegate>
{
    
    Order               *m_currentOrder     ;
    
    ReceiveAddress      *m_address          ;
    
    NSString            *m_addrStr          ;
    
    OrderFootView       *m_orderFootV       ;
    
    NSArray             *m_monCellList      ;     //订单 价格详情 8条
    
}
@end

@implementation OrderDetailController

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
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSuccess) name:NOTIFICATION_PAY_SUCCESS object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pressProductInOrderDetail:) name:NOTIFICATION_PRESS_PRODUCT_IN_ORDERDETAIL object:nil] ;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PAY_SUCCESS object:nil] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PRESS_PRODUCT_IN_ORDERDETAIL object:nil] ;
}

#pragma mark --
#pragma mark - NOTIFICATION_PAY_SUCCESS
// 支付成功
- (void)paymentSuccess
{
    if (!self.view.window) return ;
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    PaySuccessController *successCtrl   = [story instantiateViewControllerWithIdentifier:@"PaySuccessController"] ;
    [self.navigationController pushViewController:successCtrl animated:YES ] ;
}

- (void)pressProductInOrderDetail:(NSNotification *)notification
{
    NSString *strProduct = (NSString *)notification.object ;
    
    if (strProduct != nil)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
        GoodsDetailViewController *goodDetailVC = [story instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"] ;
        goodDetailVC.codeGoods = strProduct ;
        [self.navigationController pushViewController:goodDetailVC animated:YES ] ;
    }
}

- (void)hideBottomView
{
    _bottomViewHeightConstraint.constant = 0 ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"_orderIDStr : %@ ",_orderIDStr) ;
    
//    view style set
    [_table setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    _table.backgroundColor = COLOR_BACKGROUND ;
    
//    get data source
    m_currentOrder = [[Order alloc] init]             ;
    m_address      = [[ReceiveAddress alloc] init]    ;
    
    __block NSDictionary *resultDic ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
    [DigitInformation showHudWhileExecutingBlock:^{
            
        resultDic = [ServerRequest getOrderDetailWithOrderID:_orderIDStr] ;

    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        [self setupWithResult:resultDic] ;
        
        [_table reloadData] ;
        
    } AndWithMinSec:0] ;
    
}


- (void)setupOrderFootV
{
    m_orderFootV = (OrderFootView *)[[[NSBundle mainBundle] loadNibNamed:@"OrderFootView" owner:self options:nil] lastObject] ;
    m_orderFootV.isNeedDetail = NO  ;
    m_orderFootV.order        = m_currentOrder ;
    m_orderFootV.delegate     = self ;
    [_bottomView addSubview:m_orderFootV] ;
}

- (void)setupWithResult:(NSDictionary *)resultDic
{
    int code  = [[resultDic objectForKey:@"code"] intValue]           ;
    
    if (code == 200)
    {
        NSDictionary *dataDic   = [resultDic objectForKey:@"data"]              ;
        
        // order
        m_currentOrder          = [[Order alloc] initWithDictionary:dataDic]    ;
        m_address               = m_currentOrder.address                        ;
        
        DetailCellObj *tempObj  = [[DetailCellObj alloc] init] ;
        m_monCellList           = [tempObj getObjListWithOrderInfo:m_currentOrder.orderInfo] ;
    }
    else
    {
        self.isNothing = YES    ;
    }
    
    NSString *provin = [[DistrictTB shareInstance] getDistrictWithID:m_address.province].name   ;
    NSString *city   = [[DistrictTB shareInstance] getDistrictWithID:m_address.city].name       ;
    NSString *area   = [[DistrictTB shareInstance] getDistrictWithID:m_address.area].name       ;
    
    m_addrStr = [NSString stringWithFormat:@"%@ %@ %@ %@",provin,city,area,m_address.address]   ;
    
    
    //  set bottom view
    [self setupOrderFootV] ;
    
    
    //  hideBottomView if necessary
    
    if (m_orderFootV.isNull)
    {
        [self hideBottomView]  ;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    //订单状况,收货地址 + 订单数(父子订单)子订单数量 + 优惠积分支付方式 + 订单数据统计 + 下单时间
    return 4 + [m_currentOrder.parcelArray count] ;      //1 + m_productDiction.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if ( ! section )        //订单状况 + 收货地址
    {
        return 2 ;
    }
    else if ( section >= 1 && section < 1 + [m_currentOrder.parcelArray count] )  //订单数(父子订单)
    {
        Parcel *aParcel = m_currentOrder.parcelArray[section - 1] ;
        
        return aParcel.product.count ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 1)  //优惠积分支付方式
    {
        int bHasCoupson = (m_currentOrder.orderInfo.coupon_name != nil) ;   //优惠
        int bHasCredit  = ([m_currentOrder.orderInfo.credit_name intValue] != 0) ; //积分
        
        return bHasCoupson + bHasCredit + 1 ;//优惠+积分+支付方式
    }
    else if ( section == [m_currentOrder.parcelArray count] + 2 )  //订单数据统计
    {
        return 1 ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 3 ) //下单时间
    {
        return 1 ;
    }
    
    return 0 ;
}


//  coupson cell
- (COcoupsonCell *)getCoupsonCellWithTable:(UITableView *)tableView
{
    static NSString *TableSampleIdentifier = @"COcoupsonCell";
    COcoupsonCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    cell.isReadOnly       = YES ;
    cell.lb_key.text      = @"使用优惠券:" ;
    
    NSString *showStr = (m_currentOrder.orderInfo.coupon_name) ? m_currentOrder.orderInfo.coupon_name : @"无" ;

    cell.lb_value.text    = showStr ;
    cell.selectionStyle   = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}

//  score cell
- (COcoupsonCell *)getScoreCellWithTable:(UITableView *)tableView
{
    static NSString *TableSampleIdentifier = @"COcoupsonCell";
    COcoupsonCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    cell.isReadOnly         = YES ;
    cell.lb_key.text        = @"使用积分:"      ;
    
    NSString *showStr = ([m_currentOrder.orderInfo.credit_name intValue]) ? m_currentOrder.orderInfo.credit_name : @"无" ;
    
    cell.lb_value.text      = showStr ;
    cell.selectionStyle     = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}


//  pay way cell
- (PayWayCell *)getPaywayCellWithTable:(UITableView *)tableView
{
    static NSString *TableSampleIdentifier = @"PayWayCell";
    PayWayCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    cell.paytype = [PayType getPaytypeWithKey:m_currentOrder.orderInfo.pay_type] ;
    
    cell.selectionStyle     = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}

//  order content cell
- (COOrderMoneyCell *)getOrderMoneyWithTable:(UITableView *)tableView
{
    COOrderMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"COOrderMoneyCell"];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"COOrderMoneyCell" bundle:nil] forCellReuseIdentifier:@"COOrderMoneyCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"COOrderMoneyCell"];
    }
    
    cell.dataSource = [NSMutableArray arrayWithArray:m_monCellList] ;
    
    return cell;
}

//订单状况
- (OrderConditionCell *)getOrderConditionCellWithTable:(UITableView *)tableView
{
    OrderConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderConditionCell"] ;
    if ( !cell )
    {
        [tableView registerNib:[UINib nibWithNibName:@"OrderConditionCell" bundle:nil] forCellReuseIdentifier:@"OrderConditionCell"] ;
        cell = [tableView dequeueReusableCellWithIdentifier:@"OrderConditionCell"] ;
    }
    
    // 订单金额
    cell.lb_orderPrice.text = [NSString stringWithFormat:@"订单总额: ￥%.2f",m_currentOrder.orderInfo.actual_total_price] ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}


//收货地址
- (CheckOutAddrCell *)getAddressCellWithTable:(UITableView *)tableView
{
    static NSString *TableSampleIdentifier = @"CheckOutAddrCell";
    CheckOutAddrCell *cell = (CheckOutAddrCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if ( !cell )
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier] ;
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier] ;
    }
    cell.selectionStyle      = UITableViewCellSelectionStyleNone ;
    cell.address             = m_address ;
    cell.isReadOnly          =  YES ;
    
    return cell;
}

//子订单
- (CheckOutGoodCell *)getSubOrderCellWithTable:(UITableView *)tableView AndWithRow:(int)row AndSection:(int)section
{
    static NSString *TableSampleIdentifier = @"CheckOutGoodCell";
    CheckOutGoodCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier] ;
    
    if ( !cell )
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    OrderProduct *product = ((Parcel *)(m_currentOrder.parcelArray[section - 1])).product[row] ;
    
    [cell.img setIndexImageWithURL:[NSURL URLWithString:product.images] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(140, 140)] ;
    cell.lb_title.text  = product.title ;
    cell.lb_detail.text = product.features ;
    cell.lb_price.text  = [NSString stringWithFormat:@"￥%.2f",product.prices]     ;
    cell.lb_number.text = [NSString stringWithFormat:@"x%d",product.nums]          ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}

//下单时间
- (OrderBottomCell *)getOrderBottomCellWith:(UITableView *)tableView
{
    static NSString *TableSampleIdentifier = @"OrderBottomCell";
    OrderBottomCell *cell = (OrderBottomCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if ( !cell )
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier] ;
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier] ;
    }
    
    cell.selectionStyle      = UITableViewCellSelectionStyleNone ;
    
    // 下单时间
    NSString *timeStr = [MyTick getDateWithTick:m_currentOrder.orderInfo.date AndWithFormart:TIME_STR_FORMAT_6] ;
    cell.lb_orderTime.text = [NSString stringWithFormat:@"下单时间: %@",timeStr] ;
    
    return cell;
}


//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    int row     = indexPath.row     ;
    
    if ( section == 0 )    //订单状况 + 收货地址
    {
        if ( row == 0 )     //订单状况
        {
            return [self getOrderConditionCellWithTable:tableView] ;
        }
        else if ( row == 1 )  //收货地址
        {
            return [self getAddressCellWithTable:tableView] ;
        }
    }
    else if ( section >= 1 && section < 1 + [m_currentOrder.parcelArray count] )  //订单数(父子订单)
    {
        return [self getSubOrderCellWithTable:tableView AndWithRow:row AndSection:section] ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 1)  //优惠积分支付方式
    {
        int bHasCoupson = (m_currentOrder.orderInfo.coupon_name != nil) ;   //优惠
        int bHasCredit  = ([m_currentOrder.orderInfo.credit_name intValue] != 0) ; //积分
        
        int lineNum = bHasCoupson + bHasCredit + 1 ;
        
        if (lineNum == 1)
        {
            //支付方式
            return [self getPaywayCellWithTable:tableView]     ;
        }
        else if (lineNum == 2)
        {
            switch ( indexPath.row )
            {
                case 0:
                {   //优惠券
                    if (bHasCoupson && !bHasCredit)
                    {
                        return [self getCoupsonCellWithTable:tableView]    ;
                    }
                    else
                    {
                        //积分
                        return [self getScoreCellWithTable:tableView]      ;
                    }
                }
                    break;
                case 1:
                {   //支付方式
                    return [self getPaywayCellWithTable:tableView]     ;
                }
                    break;
                default:
                    break;
            }
        }
        else if (lineNum == 3)
        {
            switch ( indexPath.row )
            {
                case 0:
                {   //优惠券
                    return [self getCoupsonCellWithTable:tableView]    ;
                }
                    break;
                case 1:
                {   //积分
                    return [self getScoreCellWithTable:tableView]      ;
                }
                    break;
                case 2:
                {   //支付方式
                    return [self getPaywayCellWithTable:tableView]     ;
                }
                    break;
                default:
                    break;
            }
        }
    
    }
    else if ( section == [m_currentOrder.parcelArray count] + 2 )  //订单数据统计
    {
        return [self getOrderMoneyWithTable:tableView] ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 3 ) //下单时间
    {
        return [self getOrderBottomCellWith:tableView] ;
    }
    return nil ;
}


#define PAY_WAY_HEIGHT              54.0f
#define COUPSON_HEIGHT              40.0f
#define SCORE_HEIGHT                40.0f
#define SUB_PARCEL_HEIGHT           78.0f
#define CONDITION_HEIGHT            34.0f
#define ADDR_HEIGHT                 118.0f

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int section = indexPath.section ;
    int row     = indexPath.row     ;
    
    //订单状况 + 收货地址
    if ( ! section )
    {
        if (row == 0)       //订单情况
        {
            return CONDITION_HEIGHT ;
        }
        else if (row == 1)  //收货地址
        {
            NSString *str = [m_address getDetailAddress] ;
            UIFont *font = [UIFont systemFontOfSize:12];
            CGSize size = CGSizeMake(265,200) ;
            CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            
            return ADDR_HEIGHT - 15 + labelsize.height ;
        }
    }
    else if ( section >= 1 && section < 1 + [m_currentOrder.parcelArray count] )  //订单数(父子订单)
    {
        return SUB_PARCEL_HEIGHT ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 1)  //优惠积分支付方式
    {
        
        int bHasCoupson = (m_currentOrder.orderInfo.coupon_name != nil) ;   //优惠
        int bHasCredit  = ([m_currentOrder.orderInfo.credit_name intValue] != 0) ; //积分
        
        int lineNum = bHasCoupson + bHasCredit + 1 ;
        
        if (lineNum == 1)
        {
            //支付方式
            return PAY_WAY_HEIGHT   ;
        }
        else if (lineNum == 2)
        {
            switch ( indexPath.row )
            {
                case 0:
                {   //优惠券
                    if (bHasCoupson && !bHasCredit)
                    {
                        return COUPSON_HEIGHT   ;
                    }
                    //积分
                    else
                    {
                        return SCORE_HEIGHT     ;
                    }
                }
                    break;
                case 1:
                {   //支付方式
                    return PAY_WAY_HEIGHT   ;
                }
                    break;
                default:
                    break;
            }
        }
        else if (lineNum == 3)
        {
            switch ( indexPath.row )
            {
                case 0:
                {   //优惠券
                    return COUPSON_HEIGHT   ;
                }
                    break;
                case 1:
                {   //积分
                    return SCORE_HEIGHT     ;
                }
                    break;
                case 2:
                {   //支付方式
                    return PAY_WAY_HEIGHT   ;
                }
                    break;
                default:
                    break;
            }
        }
    
    }
    else if ( section == [m_currentOrder.parcelArray count] + 2 )  //订单数据统计
    {
        return ( m_monCellList.count + 1 ) * 37.0f ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 3 ) //下单时间
    {
        return 40.0f ;
    }
    
    return 1.0f ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    int row     = indexPath.row ;
    
    // 订单数(父子订单)
    if ( section >= 1 && section < 1 + [m_currentOrder.parcelArray count] )
    {
        OrderProduct *product = ((Parcel *)(m_currentOrder.parcelArray[section - 1])).product[row] ;
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
        GoodsDetailViewController *goodDetailVC = [story instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"] ;
        goodDetailVC.codeGoods = product.pid ;
        [self.navigationController pushViewController:goodDetailVC animated:YES ] ;
    }
}



// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( section >= 1 && section < 1 + [m_currentOrder.parcelArray count] )  //订单数(父子订单)
    {
        Parcel *aParcel = m_currentOrder.parcelArray[section - 1] ;
        
        SubOrderHeader *head = [[[NSBundle mainBundle] loadNibNamed:@"SubOrderHeader" owner:self options:nil] firstObject];
        head.section = section ;
        head.delegate = self ;
        
        head.lb_title.text = [NSString stringWithFormat:@"订单: %@",aParcel.oid] ;
        
        NSString *strStatus = @"";
        for (OrderStatus *ordSts in G_ORDERSTATUS_DIC) if (ordSts.idStatus == aParcel.status) strStatus = ordSts.name ;
        head.lb_status.text = strStatus ;
        
        NSString *strWarehouseName = ((WareHouse *)[WareHouse getWarehouseWithID:aParcel.warehouse_id]).name ;
        head.lb_comeFrom.text = !strWarehouseName ? @"" : [NSString stringWithFormat:@"来自%@",strWarehouseName] ;
        
        head.canSeeShip = ( aParcel.status == 3 || aParcel.status == 4 ) ;
        
        return head ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 1 )  //优惠积分支付方式
    {
        return [self getEmpty] ;
    }
    
    return [self getEmpty] ;
}


- (UIView *)getEmpty
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = nil ;
    return back ;
}


#define HEIGHT_HEAD_FOOT        53.0f

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ( section >= 1 && section < 1 + [m_currentOrder.parcelArray count] )  //订单数(父子订单)
    {
        return HEIGHT_HEAD_FOOT ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 1)  //优惠积分支付方式
    {
        return 1.0 ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 2 )  //订单数据统计
    {
        return 1.0f ;
    }

    return 1.0   ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self getEmpty] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 12.0f ;
    }
    else if ( section >= 1 && section < 1 + [m_currentOrder.parcelArray count] )  //订单数(父子订单)
    {
        return 12.0f ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 1)  //优惠积分支付方式
    {
        return 10.0f ;
    }
    else if ( section == [m_currentOrder.parcelArray count] + 2 )  //订单数据统计
    {
        return 1.0f ;
    }
    
    return 1.0f ;
}


#pragma mark --
#pragma mark - OrderFootViewDelegate
/*
 *  1.section  :  表示所点击属于哪一section
 *  2.title    :  按钮文字
 */
- (void)callBackWithSection:(int)section
         AndWithButtonTitle:(NSString *)title
{
    
    NSLog(@"title : %@",title) ;
    
    if ([title isEqualToString:TITLE_CANCEL_ORDER])         //取消订单
    {
        NSString *title = NSLocalizedString(@"确认要取消订单吗?", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"不", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"确定", nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil] ;
        [alertView show] ;

    }
    else if ([title isEqualToString:TITLE_PAY_NOW])         //立即付款
    {
        G_ORDERID_STR = m_currentOrder.orderInfo.oid ;
        [Payment goToAliPayWithOrderStr:m_currentOrder.orderInfo.oid] ;
    }
    else if ([title isEqualToString:TITLE_CHECK_OUT])       //确认收货
    {
        
    }
    
}


#pragma mark --
#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //确认取消
        __block ResultPasel *result ;
        
        [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
        [DigitInformation showHudWhileExecutingBlock:^{

           result = [ServerRequest orderCancelWithOrderIDStr:m_currentOrder.orderInfo.oid] ;

        } AndComplete:^{
            
            [YXSpritesLoadingView dismiss] ;
            
            if (result.code == 200)
            {
                [self.navigationController popViewControllerAnimated:YES] ;
            } else {
                [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK] ;
            }
            
        } AndWithMinSec:0] ;
        
    }
}

#pragma mark --
#pragma mark - SubOrderHeaderDelegate
- (void)seeShipDetailCallBackWithSection:(int)section
{
    Parcel *aParcel = m_currentOrder.parcelArray[section - 1] ;

    BOOL bCanSeeShip = aParcel.status == 3 || aParcel.status == 4 ;

    if (!bCanSeeShip) return ;

    NSLog(@"查看物流, 包裹") ;
    [self performSegueWithIdentifier:@"orderdetail2ship" sender:aParcel] ;

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"orderdetail2ship"])
    {
        ShipViewController *shipCtrl = (ShipViewController *)[segue destinationViewController] ;
        shipCtrl.parcelID = ((Parcel *)sender).parcelID ;
        shipCtrl.orderIdStr = ((Parcel *)sender).oid ;
    }
    
}


@end


