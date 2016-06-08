

//
//  CheckOutController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CheckOutController.h"
#import "DigitInformation.h"
#import "Goods.h"
#import "CheckOutAddrCell.h"
#import "CheckOutGoodCell.h"
#import "CheckOutHeadFoot.h"
#import "COcoupsonCell.h"
#import "PayWayCell.h"
#import "ServerRequest.h"
#import "CheckOut.h"
#import "CouponsController.h"

#import "PayWayController.h"
#import "Payway.h"
#import "AddressListController.h"
#import "SellerTB.h"

#import "WareHouse_Total.h"
#import "YXSpritesLoadingView.h"

#import <AKATeasonFramework/AKATeasonFramework.h>

#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "COOrderMoneyCell.h"
#import "UseScoreController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "AliOrder.h"
#import "MonListCell.h"
#import "DetailCellObj.h"
#import "Payment.h"
#import "Order.h"
#import "PaySuccessController.h"

#import "Warehouse.h"
#import "WarehouseTB.h"


@interface CheckOutController () <CouponsControllerDelegate,PayWayControllerDelegate,AddressListControllerDelegate,UseScoreControllerDelegate,UIAlertViewDelegate>
{
    
    NSMutableDictionary         *m_dic_dataSource   ;     //商品数据源
    
    NSMutableDictionary         *m_dic_freight      ;     //运费数据源
    
    NSMutableArray              *m_pidList          ;     //商品list
    NSMutableArray              *m_cidList          ;     //购物车CID list

    CheckOut                    *m_checkout         ;
    
    NSArray                     *m_keyArr           ;
    
    ReceiveAddress              *m_addressDefault   ;     //默认地址
    
    BOOL                        m_hasCoupons        ;     //是否有 优惠券
    
    NSArray                     *m_coupsonList      ;     //可选优惠券列表
    
    int                         m_scoreWrited       ;     //用户手写使用的积分
    
    float                       m_scorePriceWrited  ;     //用户使用积分转换的金钱
    
    NSMutableArray              *m_paytypeList      ;     //支付方式 list
    
    BOOL                        m_firstTime         ;
    
    NSArray                     *m_monCellList      ;     //订单 价格详情 8条

    float                       m_sumPrice          ;     // temp sum price
    
//  此订单是否需要上传身份证
    BOOL                        m_idcard_status     ;     //true需要上传  false不需要
    
//  优惠码
    float                       m_coupsonInsteadPrice   ;   //抵扣钱
    NSString                    *m_coupsonName          ;   //优惠码名字
    NSString                    *m_coupsonCode          ;   //优惠码code
    
//    新建订单号 str
    NSString                    *m_orderIDStr           ;
    
}

@end

@implementation CheckOutController

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCoupsonCode:) name:NOTIFICATION_COUPSON_CODE object:nil] ;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSuccess) name:NOTIFICATION_PAY_SUCCESS object:nil] ;
    }
    return self;
}



//1. Get Default Addr
- (void)setDefaultAddressWithCheckOut:(CheckOut *)checkout
{
    m_addressDefault = nil ;
    for (ReceiveAddress *addr in checkout.addressList)
    {
        if (addr.isDefault) m_addressDefault = addr ;
    }
}

//2. get and parsel product Dic
- (void)setProductDataSourceWithCheckOut:(CheckOut *)checkout
{
    m_pidList = [NSMutableArray array] ;
    m_cidList = [NSMutableArray array] ;
    
    //2. get and parsel product Dic
    m_dic_dataSource = [NSMutableDictionary dictionary] ;
    m_dic_freight    = [NSMutableDictionary dictionary] ;
    m_keyArr         = [checkout.productDic allKeys] ;
    
    for (NSString *key in m_keyArr)
    {
        NSArray *pDicList = [checkout.productDic objectForKey:key] ;
        NSMutableArray *plist = [NSMutableArray array] ;
        for (NSDictionary *diction in pDicList)
        {
            ShopCarGood *shopCarg = [[ShopCarGood alloc] initWithDiction:diction] ;
            [plist addObject:shopCarg] ;
            [m_pidList addObject:shopCarg.pid] ;
            [m_cidList addObject:[NSNumber numberWithInt:shopCarg.cid]] ;
        }
        
        WareHouse *aWare = [[WarehouseTB shareInstance] getWarehouseWithId:[key intValue]] ;
        [m_dic_dataSource setObject:plist forKey:aWare.name] ;

    }
}

//  check price
- (void)checkPriceWithCheckOut:(CheckOut *)checkout
{

    NSArray *checkList = [CheckPrice onceCheckWithList:m_pidList] ;
    
    NSArray *dataKeys = [m_dic_dataSource allKeys] ;
    for (NSString *key in dataKeys)
    {
        NSArray *prolist = [m_dic_dataSource objectForKey:key] ;
        for (ShopCarGood *shopCarg in prolist)
        {
            for (CheckPrice *checkP in checkList)
            {
                if ([shopCarg.pid isEqualToString:checkP.pid])
                {
                    shopCarg.checkPrice = checkP ;
                }
            }
        }
    }
}

//3. freight data source foot view
- (void)setFreightWithCheckOut:(CheckOut *)checkout
{
    NSArray *keyFarr = [checkout.totalWarehouseDiction allKeys] ;
   
    for (NSString *key in keyFarr)
    {
        NSDictionary *dic = [checkout.totalWarehouseDiction objectForKey:key] ;
        WareHouse_Total *wareTotal = [[WareHouse_Total alloc] initWithDiction:dic] ;
        [m_dic_freight setObject:wareTotal forKey:key] ;
    }
}

//4. coupon
- (void)setCouponWithCheckOut:(CheckOut *)checkout
{
    //是否有可以用的优惠券存在 ;
    //CHANG 20150108 TEASON 现在改成一律进入, 没有优惠券也可以输入优惠码 .
    m_hasCoupons = YES ;
//    m_hasCoupons  = (checkout.couponList.count) ? YES : NO ;
    
    //可选优惠券列表
    m_coupsonList = checkout.couponList ;
}

//5. Paytype list
- (void)setPaytypeListWithCheckOUt:(CheckOut *)checkout
{
    m_paytypeList = [NSMutableArray array] ;
    for (NSString *_payStr in checkout.payType)
    {
        Payway *payway = [[Payway alloc] init] ;
        payway.isChoosen = NO ;
        payway.payStr = _payStr ;
        
        //设置当前选中的支付方式
        if ([_payStr isEqualToString:@"alipay"])
        {
            payway.isChoosen = YES ;
        }
        
        [m_paytypeList addObject:payway] ;
    }
}

//6. all price in hand
- (void)showAllPriceInHand
{
    _lb_allMoneyValue.text = [NSString stringWithFormat:@"￥%.2f",m_checkout.priceDetail.total_price] ;
}

//7. get current point
- (void)getCurrentPoint
{
    G_USER_CURRENT.score = m_checkout.credit ;
}


- (void)viewDidLoad
{
    [super viewDidLoad]         ;
    // Do any additional setup after loading the view.
    
//  Bottom view style
    
    [self setMyViewStyle]       ;
    
    [self paselData]            ;
    
    [self setup]                ;
    
    m_orderIDStr = nil          ;
    
}

- (void)paselData
{
    m_firstTime     = YES       ;
    m_sumPrice      = 0.0f      ;
    m_scoreWrited   = 0         ;
    
//  success
//  get my check out order obj .
    NSDictionary *dataDic   = [_resultDiction objectForKey:@"data"]                 ;
    
    m_idcard_status = [[dataDic objectForKey:@"m_idcard_status"] boolValue]         ;
    
//
    m_checkout              = [[CheckOut alloc] initWithDiction:dataDic ]           ;
    
//  get money cell obj list
    DetailCellObj *tempObj  = [[DetailCellObj alloc] init]                          ;
    m_monCellList           = [tempObj getObjListWithCheckOut:m_checkout]           ;
    
//  get temp sum price
    m_sumPrice              = ((DetailCellObj *)[m_monCellList lastObject]).price   ;
    
}


- (void)setup
{
    self.table.showsVerticalScrollIndicator = NO ;
    
    //1. Get Default Addr
    [self setDefaultAddressWithCheckOut:m_checkout] ;
    //2. get and parsel product Dic
    [self setProductDataSourceWithCheckOut:m_checkout] ;
    //3. freight data source foot view
    [self setFreightWithCheckOut:m_checkout] ;
    //4. coupon
    [self setCouponWithCheckOut:m_checkout] ;
    //5. Paytype list
    [self setPaytypeListWithCheckOUt:m_checkout] ;
    //6. all price in hand
    [self showAllPriceInHand] ;
    //7. get current point
    [self getCurrentPoint] ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
//
//    从积分优惠券回来 reload
    [_table reloadData] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
    
    //核价一次
    if (m_firstTime)
    {
        m_firstTime = NO ;
        // 是否要核价
        BOOL isNeedCheckPrice = NO ;

        NSArray *allkeys = [m_dic_dataSource allKeys] ;
        for (NSString *aKey in allkeys)
        {
            NSArray *shopcargoodList = [m_dic_dataSource objectForKey:aKey]             ;
            BOOL bNeed = [CheckPrice isNeedCheckPriceWithShopCarList:shopcargoodList]   ;
            if (bNeed) isNeedCheckPrice = YES ;
        }
        
        if ( !isNeedCheckPrice ) return ;  //  不需要核价, return ;
        
        //需要核价
        [YXSpritesLoadingView showWithText:WD_HUD_CHECKPRICE andShimmering:NO andBlurEffect:NO] ;
        [DigitInformation showHudWhileExecutingBlock:^{
            
            // check price
            [self checkPriceWithCheckOut:m_checkout]       ;
            
        } AndComplete:^{
            
            [YXSpritesLoadingView dismiss] ;
            //
            [_table reloadData] ;
            //6. all price in hand
            [self showAllPriceInHand] ;
            
        } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated] ;
    
    //  get temp sum price
    m_sumPrice = ((DetailCellObj *)[m_monCellList lastObject]).price ;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_COUPSON_CODE object:nil] ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_PAY_SUCCESS object:nil] ;
}

- (void)setMyViewStyle
{
    _bottomView.backgroundColor = [UIColor whiteColor]  ;
    UIView *blackLine = [[UIView alloc] init]           ;
    blackLine.backgroundColor = COLOR_LIGHT_GRAY        ;
    blackLine.frame = CGRectMake(0, 0, 320, 0.5f)       ;
    [_bottomView addSubview:blackLine]                  ;
    
    _bt_confirm.backgroundColor = COLOR_PINK            ;
    _lb_allMoneyValue.textColor = COLOR_PINK            ;
    _lb_youNeedPay.textColor    = COLOR_PINK            ;
    
    _table.backgroundColor      = COLOR_BACKGROUND      ;
    _table.separatorStyle       = UITableViewCellSeparatorStyleNone ;
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
    NSArray *allkeys = [m_dic_dataSource allKeys] ;
    
    return 1 + allkeys.count + 1 + 1;
    
    /*
     *  1.收货地址
     *  2.订单内容
     *  3.优惠券,支付方式
     *  4.订单数据总计
     */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int shopSection     = [m_dic_dataSource allKeys].count ;
    NSArray *allkeys    = [m_dic_dataSource allKeys] ;

    //收货人section
    if (section == 0)
    {
        return 1 ;
    }
    
    //商品section   订单内容
    for (int sec = 1; sec < 1 + shopSection; sec++)
    {
        if (sec == section)
        {
            return [[m_dic_dataSource objectForKey:[allkeys objectAtIndex:sec - 1]] count] ;
        }
    }
    
    //优惠,积分,支付方式 section
    if (section == shopSection + 1)
    {
        return (m_hasCoupons  ?  3 : 2) ;       //有优惠券吗, (优惠券+支付方式)     //没有优惠券(支付方式)
    }
    
    //订单数据总计
    if (section == shopSection + 2)
    {
        return 1 ;
    }
    
    /*
     *  1.收货地址
     *  2.订单内容
     *  3.优惠,积分,支付方式
     *  4.订单数据总计
     */
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int shopSection     = [m_dic_dataSource allKeys].count ;
    NSArray *allkeys    = [m_dic_dataSource allKeys] ;
    
    //收货人section
    if (indexPath.section == 0)
    {
        return [self getAddrCellWithTable:tableView] ;
    }
    
    //商品section
    for (int sec = 1; sec < 1+shopSection; sec++)
    {
        if (indexPath.section == sec)
        {
            ShopCarGood *shopcarG = (ShopCarGood *)[[m_dic_dataSource objectForKey:[allkeys objectAtIndex:sec - 1]] objectAtIndex:indexPath.row] ;
            
            static NSString *TableSampleIdentifier = @"CheckOutGoodCell";
            CheckOutGoodCell *cell = (CheckOutGoodCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
            if (cell == nil)
            {
                cell = (CheckOutGoodCell *)[[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0] ;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            [cell.img setIndexImageWithURL:[NSURL URLWithString:shopcarG.images] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(140, 140)] ;
//            [cell.img setImageWithURL:[NSURL URLWithString:shopcarG.images] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(140, 140)];
            cell.lb_title.text  = shopcarG.title ;
            cell.lb_detail.text = shopcarG.feature ;
            cell.lb_price.text  = [NSString stringWithFormat:@"￥%.2f",shopcarG.price]     ;
            cell.lb_number.text = [NSString stringWithFormat:@"x%d",shopcarG.nums]          ;

            return cell ;
        }
    }
    
    //优惠券,积分,支付方式.
    if (indexPath.section == shopSection + 1)
    {
        
        if (m_hasCoupons)       //有优惠券
        {
            
            switch (indexPath.row)
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
        else                    //无优惠券
        {
            switch (indexPath.row)
            {
                case 0:
                {   //积分
                    return [self getScoreCellWithTable:tableView]      ;
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
    }
    
    //订单数据总计
    if (indexPath.section == shopSection + 2)
    {
        return [self getOrderMoneyWithTable:tableView] ;
    }
    
    return nil ;
}


//  addr cell
- (CheckOutAddrCell *)getAddrCellWithTable:(UITableView *)tableView
{
    static NSString *TableSampleIdentifier = @"CheckOutAddrCell";
    
    CheckOutAddrCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    cell.address = m_addressDefault ;
    cell.isReadOnly = NO ;    
    cell.selectionStyle         = UITableViewCellSelectionStyleNone ;
    
    return cell ;
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
    
    cell.lb_value.text    = @"选择优惠券" ;
    cell.selectionStyle   = UITableViewCellSelectionStyleNone ;
    
    //  如果使用了优惠码
    if (m_coupsonInsteadPrice)
    {
        cell.lb_value.text = m_coupsonName ;
    }
    //  如果选择过了优惠券,显示优惠券名称
    else
    {
        for (Coupon *aCoup in m_coupsonList) if (aCoup.isChoosen) cell.lb_value.text = aCoup.name ;
    }
    
    return cell ;
}

//  score cell
- (COcoupsonCell *)getScoreCellWithTable:(UITableView *)tableView
{
    static NSString *TableSampleIdentifier = @"COcoupsonCell";
    COcoupsonCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if ( !cell )
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    cell.lb_key.text        = @"使用积分:"      ;
    
    cell.lb_value.text      = ( !m_scoreWrited ) ? @"选择积分" : [NSString stringWithFormat:@"已用%d积分,等于￥%.2f",m_scoreWrited,m_scoreWrited/100.0f] ;
    
    cell.selectionStyle     = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}

//  pay way cell
- (PayWayCell *)getPaywayCellWithTable:(UITableView *)tableView
{
    static NSString *TableSampleIdentifier = @"PayWayCell";
    PayWayCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    
    if ( !cell )
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    cell.lb_key.text        = @"支付方式";

    cell.selectionStyle     = UITableViewCellSelectionStyleNone ;
    
    for (Payway *_payw in m_paytypeList)
    {
        if (_payw.isChoosen)
        {
            PayType *type = [PayType getPaytypeWithKey:_payw.payStr] ;
            cell.paytype = type ;
            return cell ;
        }
    }
    
    return cell ;
}

//  order content cell
- (COOrderMoneyCell *)getOrderMoneyWithTable:(UITableView *)tableView
{
    static NSString *corderString = @"COOrderMoneyCell" ;
    
    COOrderMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:corderString] ;
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:corderString bundle:nil] forCellReuseIdentifier:corderString];
        cell = [tableView dequeueReusableCellWithIdentifier:corderString];
    }
    
    cell.dataSource  = [NSMutableArray arrayWithArray:m_monCellList] ;
    cell.sumAllPrice = m_sumPrice ;
    
    return cell;
}


#define PAY_WAY_HEIGHT              54.0f
#define ORDER_CONTENT_HEIGHT        77.0f
#define COUPSON_HEIGHT              40.0f
#define SCORE_HEIGHT                40.0f
#define ADDR_HEIGHT                 118.0f
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //收货地址
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if (!m_addressDefault)
            {
                return 60.0f ;
            }
            
            NSString *str = [m_addressDefault getDetailAddress];
            UIFont *font = [UIFont systemFontOfSize:12];
            CGSize size = CGSizeMake(265,200);
            CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            
            return ADDR_HEIGHT - 15 + labelsize.height ;
        }
    }
    
    int shopSection = [m_dic_dataSource allKeys].count ;
    
    //优惠支付方式
    if (indexPath.section == shopSection + 1)
    {
        if (m_hasCoupons)
        {
            switch (indexPath.row)
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
        else
        {
            switch (indexPath.row)
            {
                case 0:
                {   //积分
                    return SCORE_HEIGHT     ;
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
    }
    
    //订单数据总计
    if (indexPath.section == shopSection + 2)
    {
        return ([m_monCellList count] + 1) * 37.0f + 8;       // -- 行数   
    }
    
    //订单商品内容
    for (int sec = 1; sec < 1+shopSection; sec++)
    {
        return ORDER_CONTENT_HEIGHT ;
    }

    return  0 ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (! indexPath.section)
    {
        [self performSegueWithIdentifier:@"checkout2address" sender:nil] ;
            
        return ;
    }
    
    //
    NSLog(@"section:%d",indexPath.section);
    NSLog(@"row    :%d",indexPath.row);
    int shopSection = [m_dic_dataSource allKeys].count ;

    //  点击优惠券, 选择 ;
    //  点击 支付方式
    if (indexPath.section == shopSection + 1)
    {
        if (m_hasCoupons)       //优惠券,支付方式
        {
            // 优惠券
            if ( !indexPath.row )
            {
                //清空优惠券, 成员变量
                m_coupsonInsteadPrice = 0 ;
                m_coupsonName = @"" ;
                m_coupsonCode = @"" ;
                
                [self performSegueWithIdentifier:@"checkout2coupson" sender:m_coupsonList] ;
            }
            //  积分
            else if ( !(indexPath.row - 1) )
            {
                //m_scoreWrited = 0 ;
                
                [self performSegueWithIdentifier:@"checkout2usescore" sender:nil] ;
            }
            // 支付方式
            else if ( !(indexPath.row - 2) )
            {
//                [self performSegueWithIdentifier:@"checkout2payway" sender:m_paytypeList ];
            }
            
        }
        //支付方式(没有优惠券)
        else
        {
            //  积分
            if ( !(indexPath.row ) )
            {
                [self performSegueWithIdentifier:@"checkout2usescore" sender:nil] ;
            }
            // 支付方式
            else if ( !(indexPath.row - 1) )
            {
                // [self performSegueWithIdentifier:@"checkout2payway" sender:m_paytypeList ];
            }
        }
        
    }
    
}

#define TABLEHEADHEIGHT   34.0f

- (CheckOutHeadFoot *)getSumPriceFooterWithArray:(NSArray *)allkeys AndWithIndex:(int)i AndWithHeadOrFoot:(BOOL)noHeadYesFoot
{
    CheckOutHeadFoot *headfoot = (CheckOutHeadFoot *)[[[NSBundle mainBundle] loadNibNamed:@"CheckOutHeadFoot" owner:self options:nil] objectAtIndex:0] ;
    
    
    NSString *key              = allkeys[i]     ;
    headfoot.lb_key.text       = key            ;
    
    headfoot.lb_key.hidden     = (noHeadYesFoot) ? YES : NO     ;
    headfoot.lb_price.hidden   = (noHeadYesFoot) ? NO  : YES    ;
    
    
    WareHouse *aWareHouse = [[WarehouseTB shareInstance] getWarehouseWithName:key] ;
    WareHouse_Total *wareTotal = (WareHouse_Total *)[m_dic_freight objectForKey:[NSString stringWithFormat:@"%d",aWareHouse.idWarehouse]]    ;
    
    NSDictionary* style = @{@"gray":[UIColor darkGrayColor],
                            @"red": COLOR_PINK} ;
    NSString *attrStr = [NSString stringWithFormat:@"<gray>共 %d 件商品 合计：</gray><red>￥%.2f</red>",wareTotal.nums,wareTotal.price] ;
    headfoot.lb_price.attributedText = [attrStr attributedStringWithStyleBook:style] ;
    
    return headfoot ;
}


- (CheckOutHeadFoot *)getFreightFooterWithKey:(NSString *)key AndWithSelTotal:(WareHouse_Total *)wareTotal
{
    CheckOutHeadFoot *freightfoot = (CheckOutHeadFoot *)[[[NSBundle mainBundle] loadNibNamed:@"CheckOutHeadFoot" owner:self options:nil] objectAtIndex:0] ;
    freightfoot.lb_key.text       = key                 ;
    freightfoot.lb_key.hidden     = YES                 ;
    
    NSDictionary* style = @{@"gray":[UIColor darkGrayColor],
                            @"red": COLOR_PINK}         ;
    NSString *attrStr = [NSString stringWithFormat:@"<gray>美国境内运费：</gray><red>￥%.2f</red>",wareTotal.freight] ;
    freightfoot.lb_price.attributedText = [attrStr attributedStringWithStyleBook:style] ;
    
    return freightfoot ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *allkeys    = [m_dic_dataSource allKeys]    ;
    int shopSection     = allkeys.count                 ;

    for (int i = 0; i < shopSection ; i++)
    {
        if (i + 1 == section)
        {
            return [self getSumPriceFooterWithArray:allkeys AndWithIndex:i AndWithHeadOrFoot:NO] ;
        }
    }
    
    //优惠,积分,支付方式 section
    if (section == shopSection + 1)
    {
        UIView *back = [[UIView alloc] init] ;
        back.backgroundColor = [UIColor clearColor] ;
        
        return back ;
    }
    
    return nil ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    int shopSection  = [m_dic_dataSource allKeys].count ;

    for (int sec = 1; sec < 1+shopSection; sec++)
    {
        if (section == sec)
        {
            return TABLEHEADHEIGHT ;
        }
    }
    
    //优惠,积分,支付方式 section
    if (section == shopSection + 1)
    {
        return 4 ;
    }
    
    return 1 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSArray *allkeys    = [m_dic_dataSource allKeys]    ;
    int shopSection     = allkeys.count                 ;
    
    //商品列表
    for (int i = 0; i < shopSection ; i++)
    {
        if (i + 1 == section)
        {
            NSString     *key        = allkeys[i]     ;
            WareHouse    *warehou    = [[WarehouseTB shareInstance] getWarehouseWithName:key] ;
            WareHouse_Total *wareTotal  = (WareHouse_Total *)[m_dic_freight objectForKey:[NSString stringWithFormat:@"%d",warehou.idWarehouse]] ;
            
            if (wareTotal.freight == 0)
            {
                //  无运费
                UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, TABLEHEADHEIGHT + 4)] ;
                back.backgroundColor = COLOR_BACKGROUND ;

                CheckOutHeadFoot *foot = [self getSumPriceFooterWithArray:allkeys AndWithIndex:i AndWithHeadOrFoot:YES] ;
                [back addSubview:foot] ;
                
                return back ;
            }
            else
            {
                //  有运费
                UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, TABLEHEADHEIGHT * 2 + 4)] ;
                back.backgroundColor = COLOR_BACKGROUND ;
                
                CheckOutHeadFoot *freightFoot = [self getFreightFooterWithKey:key AndWithSelTotal:wareTotal] ;
                freightFoot.frame = CGRectMake(0, 0, freightFoot.frame.size.width, freightFoot.frame.size.height) ;
                CheckOutHeadFoot *priceFoot   = [self getSumPriceFooterWithArray:allkeys AndWithIndex:i AndWithHeadOrFoot:YES] ;
                priceFoot.frame = CGRectMake(0, TABLEHEADHEIGHT, priceFoot.frame.size.width, priceFoot.frame.size.height) ;
                
                UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, TABLEHEADHEIGHT * 2)] ;
                [footer addSubview:freightFoot] ;
                [footer addSubview:priceFoot] ;
                
                [back addSubview:footer] ;
                
                return back ;
            }

        }
    }
    
    return  nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    NSArray *allkeys    = [m_dic_dataSource allKeys]    ;

    int shopSection  = [m_dic_dataSource allKeys].count ;
    
    //  商品列表
    if (section == shopSection + 1)
    {
        return 1;
    }
    else if (!section)
    {
        return 1 ;
    }
    else
    {
        for (int i = 0; i < shopSection ; i++)
        {
            if (i + 1 == section)
            {
                NSString *key              = allkeys[i]     ;
                
                WareHouse *aWareHouse = [[WarehouseTB shareInstance] getWarehouseWithName:key] ;
                WareHouse_Total *wareTotal = (WareHouse_Total *)[m_dic_freight objectForKey:[NSString stringWithFormat:@"%d",aWareHouse.idWarehouse]]    ;
                
                if (wareTotal.freight == 0)                //  无运费
                {
                    return TABLEHEADHEIGHT + 4 ;
                }
                else                                       //  有运费
                {
                    return TABLEHEADHEIGHT * 2 + 4 ;
                }
            }
        }
    }
    
    return 1 ;
}

#pragma mark --
#pragma mark - refresh sum price
- (void)refreshSumPrice
{
    float orgSumPrice = ((DetailCellObj *)[m_monCellList lastObject]).price ;
    
//1. 优惠券
    // 如果使用了优惠码
    if (m_coupsonInsteadPrice)
    {
        m_sumPrice = orgSumPrice - m_coupsonInsteadPrice ;
    }
    // 如果选择过了优惠券,显示优惠券名称
    else
    {
        for (Coupon *aCoup in m_coupsonList)
        {
            if (aCoup.isChoosen)
            {
                m_sumPrice = orgSumPrice - aCoup.coupon_money ;
            }
        }
    }
    
//2. 积分
    m_sumPrice -= m_scorePriceWrited ;
    
    _lb_allMoneyValue.text = [NSString stringWithFormat:@"￥%.2f",m_sumPrice] ;
    [_table reloadData] ;
    
}

#pragma mark - CouponsControllerDelegate
- (void)sendSelectedCousonList:(NSArray *)coupsonList
{
    m_coupsonList = coupsonList ;

    for (Coupon *aCoup in m_coupsonList)
    {
        if (aCoup.isChoosen)
        {
            for (int i = 0; i < [m_monCellList count]; i++)
            {
                DetailCellObj *obj = (DetailCellObj *)m_monCellList[i] ;
                if ([obj.keyChinese isEqualToString:KEYS_COUPSONS])
                {
                    ((DetailCellObj *)m_monCellList[i]).price = aCoup.coupon_money ;
                }
            }
            
            break ;
        }
    }
    
    
    [self refreshSumPrice] ;
    
}

#pragma mark --
#pragma mark - NOTIFICATION coupson code    优惠码
- (void)getCoupsonCode:(NSNotification *)notification
{
    NSDictionary *tempDic       = notification.userInfo ;
    
    //抵扣多少钱
    float       price           = [[tempDic objectForKey:@"price"] floatValue] ;
    //优惠码名字
    NSString    *name           = [tempDic objectForKey:@"name"] ;
    //优惠码code
    NSString    *coupsonCode    = (NSString *)notification.object ;
    
    
    m_coupsonInsteadPrice = price       ;
    m_coupsonName         = name        ;
    m_coupsonCode         = coupsonCode ;
    
    for (int i = 0; i < [m_monCellList count]; i++)
    {
        DetailCellObj *obj = (DetailCellObj *)m_monCellList[i] ;
        if ([obj.keyChinese isEqualToString:KEYS_COUPSONS])
        {
            ((DetailCellObj *)m_monCellList[i]).price = price ;
        }
    }
    
    //
    [self refreshSumPrice] ;
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
#pragma mark - UseScoreControllerDelegate
- (void)sendWritedScore:(int)score
{
    m_scoreWrited = score ;
    
    //使用积分
    ResultPasel *result = [ServerRequest usePointInOrderConfrimWithCredit:score] ;
    
    if (result.code == 200)
    {
        float pointUsePrice = [[(NSDictionary *)result.data objectForKey:@"price"] floatValue] ;
        
        for (int i = 0; i < [m_monCellList count]; i++)
        {
            DetailCellObj *obj = (DetailCellObj *)m_monCellList[i] ;
            if ([obj.keyChinese isEqualToString:KEYS_POINTS])
            {
                ((DetailCellObj *)m_monCellList[i]).price = pointUsePrice ;
            }
        }
        //
        m_scorePriceWrited = pointUsePrice ;
        [self refreshSumPrice] ;
    }
    else
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK] ;
    }
    
}


#pragma mark - PayWayControllerDelegate
- (void)sendPayWayList:(NSArray *)list
{
    m_paytypeList = [NSMutableArray arrayWithArray:list] ;
    
    [_table reloadData] ;
}


#pragma mark - AddressListControllerDelegate
- (void)sendSelectedAddress:(ReceiveAddress *)address
{
    m_addressDefault = address ;

    [_table reloadData] ;
}


#pragma mark - confrim Action
- (IBAction)confrimAction:(id)sender
{
    if (!m_addressDefault)
    {
        [DigitInformation showWordHudWithTitle:@"请先填写收货地址"] ;
        
        return ;
    }
    
    //判断地址中, 是否添加的身份证; 判断此订单是否需要添加身份证(服务端) .
    if (m_idcard_status && !m_addressDefault.idcard_status)
    {
        [DigitInformation showWordHudWithTitle:@"请在地址中增加身份证照片，以便顺利通过海关检验。"] ;
        return ;
    }

//    
    __block BOOL bSuccess       = NO    ;
    __block BOOL bStockOver     = NO    ;
 
    //是否要核价
    BOOL isNeedCheckPrice = NO ;
    NSArray *allkeys    = [m_dic_dataSource allKeys] ;
    for (NSString *aKey in allkeys)
    {
        NSArray *shopcargoodList = [m_dic_dataSource objectForKey:aKey]             ;
        BOOL bNeed = [CheckPrice isNeedCheckPriceWithShopCarList:shopcargoodList]   ;
        if (bNeed) isNeedCheckPrice = YES ;
    }
    
    NSLog(@"支付前 : %@", isNeedCheckPrice ? @"需要核价" : @"不需要核价了") ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        //付款前,彻底核价
        if (!isNeedCheckPrice)
        {
            bSuccess = YES ;
            return ;    //不需要核价, return ;
        }
        
        // check price 需要核价
        ResultCheckOut *resultCheckOut = [self checkPriceFunction] ;
        bStockOver = resultCheckOut.bStockOver  ;
        bSuccess   = resultCheckOut.bSuccess    ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        if (bSuccess)
        {
            NSLog(@"can add order") ;
            if (!m_orderIDStr)
            {
                // 创建订单
                // add order in server
                NSDictionary *orderDic = [self getResultDicWhenCreateOrder] ;
                
                int code = [[orderDic objectForKey:@"code"] intValue] ;
                
                if (code == 200)
                {
                //  success , get order ID
                    m_orderIDStr    = [orderDic objectForKey:@"info"] ;
                    G_ORDERID_STR   = m_orderIDStr ;
                }
                else
                {
                    NSString *info  = [orderDic objectForKey:@"info"] ;
                    [DigitInformation showWordHudWithTitle:info] ;
                }
                
                if (!orderDic)
                {
                    [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK] ;
                }
            }
            
            if ( m_orderIDStr )
            {
                //  pay hud 下单成功
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"订单已提交成功,请在三十分钟内完成支付,是否去支付?" message:nil delegate:self cancelButtonTitle:@"再逛逛" otherButtonTitles:@"去支付", nil] ;
                
                [alertView show] ;
            }
            
        }
        else
        {
            NSLog(@"不能add") ;
            // can not buy  show hud
            NSString *hudStr = (bStockOver) ? WD_HUD_STOCKOVER : WD_HUD_NOT_CHECKED ;
            [DigitInformation showWordHudWithTitle:hudStr] ;
        }
        
    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
    
}

/*
- (BOOL)getIsOnlySelfSale
{
    BOOL bIsOnlySelfSale = YES ; // 是否只有自营的商品
    NSArray *allkeys    = [m_dic_dataSource allKeys] ;
    for (NSString *aKey in allkeys)
    {
        NSArray *shopcargoodList = [m_dic_dataSource objectForKey:aKey]             ;
        for (ShopCarGood *shopcar in shopcargoodList)
        {
            if (shopcar.bid != 1000) {
                bIsOnlySelfSale = NO ;
                break ;
            }
        }
    }
    NSLog(@"是否只有自营的商品bIsOnlySelfSale : %d",bIsOnlySelfSale) ;
    
    return bIsOnlySelfSale ;
}
*/

// create order in server
- (NSDictionary *)getResultDicWhenCreateOrder
{
    
    NSMutableArray *cartIdList = [NSMutableArray array]     ;
    NSArray        *dataKeys   = [m_dic_dataSource allKeys] ;
    for ( NSString *key in dataKeys )
    {
        NSArray *prolist = [m_dic_dataSource objectForKey:key] ;
        for (ShopCarGood *shopCarg in prolist)
        {
            [cartIdList addObject:[NSNumber numberWithInt:shopCarg.cid]] ;
        }
    }
    
    // push to buy view
    //  paytype
    NSString *paytypeStr = @"" ;
    for (Payway *_payw in m_paytypeList)
    {
        if (_payw.isChoosen) paytypeStr = _payw.payStr ;
    }
    //  coupson
    NSString *couponID = @"" ;
    // 如果使用了优惠码
    if (m_coupsonInsteadPrice)
    {
        //m_coupsonCode ;
    }
    // 如果使用了优惠券
    else
    {
        for (Coupon *aCoup in m_coupsonList)
        {
            if (aCoup.isChoosen) couponID = [NSString stringWithFormat:@"%d",aCoup.coupon_id] ;
        }
    }
    
    //
    NSDictionary *orderDic = [ServerRequest addOrderWithCartIDList:cartIdList AndWithAddressID:[NSString stringWithFormat:@"%d",m_addressDefault.addressId] AndWithPayType:paytypeStr AndWithCouponID:couponID AndWithCouponCode:m_coupsonCode AndWithCredit:m_scoreWrited] ;
    
    return orderDic ;
}

// check price
- (ResultCheckOut *)checkPriceFunction  //  WithBsuccess:(BOOL)bSuccess AndWithBstockOver:(BOOL)bStockOver
{
    ResultCheckOut *resultCheck = [[ResultCheckOut alloc] init] ;
    
    
    NSArray *checkList  = [CheckPrice funcCheckPriceWithList:m_pidList] ;
    
    NSArray *dataKeys   = [m_dic_dataSource allKeys] ;
    for (NSString *key in dataKeys)
    {
        NSArray *prolist = [m_dic_dataSource objectForKey:key] ;
        for (ShopCarGood *shopCarg in prolist)
        {
            for (CheckPrice *checkP in checkList)
            {
                if ([shopCarg.pid isEqualToString:checkP.pid])
                {
                    shopCarg.checkPrice = checkP ;
                    
                    bool bHasMustCheck = NO ;
                    for (NSString *strSellerNeedCheck in [DigitInformation shareInstance].g_checkPriceSellerList) {
                        int sellerIDNeedCheck = [strSellerNeedCheck intValue] ;
                        if (shopCarg.checkPrice.sellerID == sellerIDNeedCheck) {
                            bHasMustCheck = YES ;
                            break ;
                        }
                    }
                    if (!bHasMustCheck) continue ;     //不需要核价的商家, 直接跳过
                    
                    
                    if (shopCarg.nums > checkP.stock)       //  超过库存
                    {
                        resultCheck.bStockOver = YES ;
                        resultCheck.bSuccess  = NO ;
                    }
                    
                    if (shopCarg.checkPrice.buyStatus == NO) { // 不能购买
                        resultCheck.bSuccess = NO ;
                    }
                    
                    long long tickNow = [MyTick getTickWithDate:[NSDate date]] ;    //已经核价过?
                    long long deta = tickNow - shopCarg.checkPrice.ts;
                    if (deta > G_AUTHORIZATION_TIME )
                    {
                        resultCheck.bSuccess = NO ;
                    }
                }
            }
        }
    }
    
    return resultCheck ;
}

#pragma mark -- 
#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //再逛逛
    if (buttonIndex == 0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES] ;
    }
    // 确认去支付 , 是
    else if (buttonIndex == 1)
    {
        //go to ali pay
        [Payment goToAliPayWithOrderStr:m_orderIDStr] ;
    }
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"checkout2coupson"])
    {
        CouponsController *coupsonCtrl = (CouponsController *)[segue destinationViewController] ;
        
        coupsonCtrl.coupsonList     = [NSMutableArray arrayWithArray:(NSArray *)sender] ;
        coupsonCtrl.LookOrSelect    = YES   ;     // can select coupon
        coupsonCtrl.cidLists        = m_cidList ; // cid list
        coupsonCtrl.delegate        = self  ;
        
    }
    else if ([segue.identifier isEqualToString:@"checkout2payway"])
    {
        PayWayController *paywayCtrl = (PayWayController *)[segue destinationViewController] ;
        
        paywayCtrl.paywayList = (NSArray *)sender ;
        paywayCtrl.delegate   = self ;
    }
    else if ([segue.identifier isEqualToString:@"checkout2address"])
    {
        AddressListController *addrListCtrl = (AddressListController *)[segue destinationViewController] ;
        
        addrListCtrl.delegate       = self  ;
        addrListCtrl.isAddOrSelect  = YES   ;
    }
    else if ( [segue.identifier isEqualToString:@"checkout2usescore"] )
    {
        UseScoreController *scoreCtrller = (UseScoreController *)[segue destinationViewController] ;
        scoreCtrller.delegate = self ;
    }
    
}



@end
