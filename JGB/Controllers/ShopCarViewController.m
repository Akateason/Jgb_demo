//
//  ShopCarViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ShopCarViewController.h"
#import "ShopCarCell.h"
#import "PopMenuView.h"
#import "DigitInformation.h"
#import "ShopCarHeadView.h"
#import "Goods.h"
#import "LSCommonFunc.h"
#import "ServerRequest.h"
#import "YXSpritesLoadingView.h"
#import "UIImageView+WebCache.h"
#import "CheckOutHeadFoot.h"
#import "NSObject+MKBlockTimer.h"
#import "KeyBoardTopBar.h"
#import "SellerTB.h"
#import "Seller.h"
#import "CheckPrice.h"
#import "CheckOutController.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

#import "NoteCantBuy.h"
#import "GoodsDetailViewController.h"
#import "CartFreightMode.h"
#import "ShopCarFreight.h"
#import "ShopCarTotal.h"
#import "NavRegisterController.h"
#import "WarehouseTB.h"



#define GET_TAG_WITH_SECTION(x)     (3456+x)



@interface ShopCarViewController ()<ShopCarHeadViewDelegate,ShopCarCellDelegate,StepTfViewDelegate,KeyBoardTopBarDelegate>
{
    
    int                  m_NUM_orgShop          ;                     //来源商家数量
    
    NSMutableDictionary *m_dicDataSource        ;                     //购物车数据源
    NSMutableArray      *m_KeyArray             ;                     //商家list
    NSMutableArray      *m_headViewArray        ;                     //head view list
    NSMutableArray      *m_footViewArray        ;                     //foot view list
    NSMutableArray      *m_editSectionList      ;                     //要编辑的section list
    
//    NSMutableArray      *m_selectTotalPriceList ;                   //购物车勾选的商品总价list, 按照商家分组, 几个商家几个值, 传入商家bid
    
    BOOL                m_is_Add_On             ;                     //是否勾选了addon的商品
    
    KeyBoardTopBar      *m_keyboardbar          ;                     //

    BOOL                m_hasProductChoosed     ;                     //有物品结算
    
    
    BOOL                m_isDelBarbutton        ;
    
    
    //购物车运费情况
    ShopCarFreight      *m_shopcarFreight       ;
    //购物车总价
    ShopCarTotal        *m_shopcarTotal         ;
    
    
    NSMutableArray      *m_neverCheckFinishedProductCidList ;         //永远不能通过核价的商品 cid list
    
//    NSMutableArray      *m_selectAllCollectionList ;                  //保存全选的section号
    
}
@end

@implementation ShopCarViewController
@synthesize table_shopCar,lb_price_title,lb_price_value,button_checkout;
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
        
    }
    return self;
}

- (void)hideBackBarButton
{
    m_isDelBarbutton = YES ;
}

#pragma mark -- IS NOTING CALL BACK
/*
 ** ReShow The Data ** 点击没有网络提醒的图片时, 重新刷数据 ,
 **/
- (void)reShowTheData
{
    NSLog(@"reShowTheData") ;

    self.isNothing = NO     ;
    
    if (_isPop) {
        [self.navigationController popViewControllerAnimated:YES] ;
    } else {
        [self.tabBarController setSelectedIndex:0] ;
    }
}


#pragma mark --
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//  refreshTableInitial
    [self refreshTableInitial] ;
    
//  keyBoardToolBar
    [self keyBoardToolBar] ;
    
//1 . setMyViews
    [self setMyViews] ;
    
//2 . initial
    [self setup] ;
    
//3 . login if needed .
    if (G_TOKEN == nil || [G_TOKEN isEqualToString:@""])
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
    }
    
}




// some thing initial
- (void)setup
{
    self.isShopCar          = YES ;

    m_dicDataSource             = [NSMutableDictionary dictionary] ;
    m_KeyArray                  = [NSMutableArray array] ;
    m_headViewArray             = [NSMutableArray array] ;
    m_footViewArray             = [NSMutableArray array] ;
    m_editSectionList           = [NSMutableArray array] ;
    m_neverCheckFinishedProductCidList = [NSMutableArray array] ;
    
    table_shopCar.separatorStyle = UITableViewCellSeparatorStyleNone ;
    table_shopCar.backgroundColor = COLOR_BACKGROUND ;
    
    m_is_Add_On                 = NO ;
    m_hasProductChoosed         = NO ;
    
//    m_selectAllCollectionList   = [NSMutableArray array] ;
}


// refresh Table Initial
- (void)refreshTableInitial
{
    if (_refreshHeaderView == nil)
    {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, - table_shopCar.bounds.size.height, self.view.frame.size.width, table_shopCar.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [table_shopCar addSubview:_refreshHeaderView];
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}

//
- (void)keyBoardToolBar
{
    m_keyboardbar     = [[KeyBoardTopBar alloc] init] ;
    [m_keyboardbar    setAllowShowPreAndNext:NO]      ;
    [m_keyboardbar    setIsInNavigationController:NO] ;
    m_keyboardbar.delegate = self                     ;
    [self.view addSubview:m_keyboardbar.view]         ;
}

#pragma mark --
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    self.navigationController.navigationBar.translucent = YES ;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBackBarButton) name:NOTIFICATION_HIDE_SHOPCAR_BACK object:nil] ;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numKeyBoardShow:) name:NOTIFICATION_SHOW_NUM_KEY_BOARD object:nil] ;
    
    //  del back button
    self.isDelBarButton = m_isDelBarbutton ;
    
    if (G_TOKEN == nil || [G_TOKEN isEqualToString:@""])
    {
        //  未登录, 不能看购物车
        self.isNothing = YES ;
    }
    else
    {
        [self egoRefreshTableHeaderDataSourceIsLoading:_refreshHeaderView] ;
        [self egoRefreshTableHeaderDidTriggerRefresh:_refreshHeaderView] ;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    if ( m_NUM_orgShop)
    {
        [m_dicDataSource removeAllObjects] ;
        [m_KeyArray      removeAllObjects] ;
        [m_headViewArray removeAllObjects] ;
        [m_footViewArray removeAllObjects] ;
        [m_editSectionList removeAllObjects] ;
        m_is_Add_On = NO ;
        m_NUM_orgShop = 0 ;

        [self checkOutButtonOnOff:NO]   ;
        //  订单合计 (到手价)
        lb_price_value.text = [NSString stringWithFormat:@"￥0.0"] ;
        
        [table_shopCar reloadData] ;
    }
    
    [self setupTotalViewWithSelected:NO] ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOW_NUM_KEY_BOARD object:nil] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HIDE_SHOPCAR_BACK  object:nil] ;
}




#pragma mark --
#pragma mark - parsel shop car and config
- (void)getDataAndparselProductListAndConfig
{
    NSDictionary *dataDic = [ServerRequest showShopCars]      ;
    
//    1.set up shop car pro list
    [self setupShopCarProductList:dataDic] ;
}


- (void)setupShopCarProductList:(NSDictionary *)dataDic
{
    NSDictionary *productDic = [dataDic objectForKey:@"product"] ;
    
// @TEASON   20150306   UPDATE BEGIN
    ///1  warehouse id list
    NSArray *keyarr = [productDic allKeys] ;
    
    //2 shop car num
    int shopcarNum  = 0 ;
    
    [m_KeyArray removeAllObjects] ;
    
    for (NSString *key in keyarr)
    {
        NSArray *pList = [productDic objectForKey:key]  ;
        
        shopcarNum += pList.count                       ;
        
        int wareHouseID = [key intValue]                ;
        
        WareHouse *aWarehouse = [[WarehouseTB shareInstance] getWarehouseWithId:wareHouseID] ;
        
        [m_KeyArray addObject:aWarehouse]                  ;
    }
    
    G_SHOP_CAR_COUNT = shopcarNum ;
    
    //    NSLog(@"m_KeyArray : %@",m_KeyArray) ;
    
    //3 good list
    NSMutableArray *productList = [NSMutableArray array] ;
    for (WareHouse *ware in m_KeyArray)
    {
        for (NSString *key in keyarr)
        {
            NSMutableArray *tempArr = [NSMutableArray array] ;
            
            NSArray *pList = [productDic objectForKey:key] ;
            for (NSDictionary *pDic in pList)
            {
                ShopCarGood *shopCar = [[ShopCarGood alloc] initWithDiction:pDic] ;
                [tempArr addObject:shopCar] ;
                [productList addObject:shopCar.pid] ;
            }
            
            if ([key intValue] == ware.idWarehouse)
            {
                [m_dicDataSource setObject:tempArr forKey:ware.name] ;
            }
        }
    }
    
    // 来源仓库的数量
    m_NUM_orgShop = (int)[m_KeyArray count] ;
    
    //    nothing in shop car , Return
    if (! m_NUM_orgShop) return ;
    
    //    check price or not
    //proCode list       //check one time
    NSArray *checkedList = [CheckPrice onceCheckWithList:productList]  ;
    
    NSLog(@" checkedList : %@",checkedList) ;
    
    [self putCheckListIntoShopCarListWith:checkedList] ;
    
    
}

// 处理核价后的 放到购物车
- (void)putCheckListIntoShopCarListWith:(NSArray *)checkedList
{
    for (WareHouse *awarehouse in m_KeyArray)
    {
        NSArray *proList = [m_dicDataSource objectForKey:awarehouse.name];
        for (ShopCarGood *shopcar in proList)
        {
            for (CheckPrice *checkP in checkedList)
            {
                if ([shopcar.pid isEqualToString:checkP.pid])
                {
                    shopcar.checkPrice = checkP ;
                }
            }
            
            NSLog(@"buy stat : %d",shopcar.checkPrice.buyStatus) ;
        }
    }
    
    
}

#pragma mark --
#pragma mark - setMyViews
- (void)setMyViews
{
    self.title = @"购物车" ;
    
    //1.bottom Bar
    lb_price_title.textColor = [UIColor blackColor]             ;
    lb_price_value.textColor = COLOR_PINK                       ;
    [button_checkout.layer setCornerRadius:2.0f]                ;
    
    //
    _bottomView.backgroundColor = [UIColor whiteColor]          ;
    UIView *blackLine = [[UIView alloc] init]                   ;
    blackLine.backgroundColor = COLOR_LIGHT_GRAY                ;
    blackLine.frame = CGRectMake(0, 0, 320, 0.5f)               ;
    [_bottomView addSubview:blackLine]                          ;
    
    //
    [self checkOutButtonOnOff:NO] ;
    
    //
    _lb_interFreight.hidden     = YES ;
    _lb_sellerFreight.hidden    = YES ;
    
    //
    table_shopCar.showsVerticalScrollIndicator = NO ;
    

}


#pragma mark --

- (void)setHeadViewArray
{
    [m_headViewArray removeAllObjects] ;
    
    if (!m_KeyArray.count) return ;
    
    
    for (int i = 0; i <= m_KeyArray.count; i++)
    {
        NSArray *nibs   = [[NSBundle mainBundle] loadNibNamed:@"ShopCarHeadView" owner:self options:nil];
        ShopCarHeadView *headV = (ShopCarHeadView *)[nibs objectAtIndex:0];
        headV.tag       = GET_TAG_WITH_SECTION(i) ;
        headV.delegate  = self ;
        headV.section   = i ;
        
        if (i == 0)
        {
            headV.lb_orgShop.text = @"全选" ;
        }
        else
        {
            headV.lb_orgShop.text = ((WareHouse *)[m_KeyArray objectAtIndex:i - 1]).name ;
        }
        
        [m_headViewArray addObject:headV] ;
    }
    
    
}


#pragma mark --
#pragma mark - PopMenuViewDelegate
//点击 menu 外部
- (void)clickOutSide
{
    [PopMenuView showHidePopMenuWithVC:self AndWithMustRemove:NO] ;
}

//点击前往 controller
- (void)goToContollerWithTag:(int)tag
{
    [PopMenuView showHidePopMenuWithVC:self AndWithMustRemove:YES] ;
    
    NSLog(@"tag : %d",tag) ;
    NSLog(@"VCS: %@",self.navigationController.viewControllers) ;
    NSLog(@"now in shop car vc");
    
    [LSCommonFunc dealNavigationPushOrPopWithViewControllers:self AndWithTag:tag] ;
}


#pragma mark --
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
    return 1 + m_NUM_orgShop;
    //section数量 + 1, 1代表全选,
    //m_NUM_orgShop代表商家来源地数量
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {      //全选 ,没有cell
        return 1 ;
    }
    
    for (int i = 1; i <= m_NUM_orgShop; i ++)
    {      //
        if (section == i)
        {
            return [[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:i-1]).name] count];
        }
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    int row     = indexPath.row     ;
    //全选 ,没有cell
    if (section == 0) return [self getNullCell:tableView] ;
    
    for (int i = 1; i <= m_NUM_orgShop; i ++)
    {
        if (indexPath.section == i)
        {
            static NSString *TableSampleIdentifier = @"ShopCarCell";
            ShopCarCell *cell = (ShopCarCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
            if ( !cell )
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0];
            }
            cell.selectionStyle     = UITableViewCellSelectionStyleNone ;
            cell.section            = section       ;
            cell.row                = row           ;
            cell.delegate           = self          ;
            
            ShopCarGood *shopCarGood = (ShopCarGood *)[[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:i-1]).name] objectAtIndex:row] ;
            
            cell.shopCarG           = shopCarGood   ;
            
            cell.stepView.delegate  = self          ;
            cell.stepView.section   = section       ;
            cell.stepView.row       = row           ;
            
            // is edit or not
            cell.isEdited           = NO            ;
            
            @synchronized (m_editSectionList)
            {
                if (m_editSectionList.count)
                {
                    for (int i = 0; i < m_editSectionList.count; i++)
                    {
                        if ([m_editSectionList[i] intValue] == indexPath.section)
                        {
                            cell.isEdited = YES ;
                        }
                    }
                }
            }
            
            return cell ;
        }
    }
    
    return [self getNullCell:tableView] ;
}

- (UITableViewCell *)getNullCell:(UITableView *)tableView
{
    static NSString *TableNoCellIdentifier = @"NOCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableNoCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableNoCellIdentifier];
    }
    cell.contentView.backgroundColor = nil ;
    cell.backgroundColor = nil ;
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //全部
    if (!indexPath.section) return 1.0f ;
    
    //为空与否
    for (int index = 0; index < m_KeyArray.count; index ++)
    {
        NSString *key = ((WareHouse *)m_KeyArray[index]).name ;
        NSMutableArray *arraylist = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
        
        if (!arraylist.count) return 1.0f ; //null
        else return 78.0f ;                 //normal
    }
    
    return 1.0f ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_editSectionList.count) return ;
    
    ShopCarGood *shopCarGood = (ShopCarGood *)[[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:indexPath.section-1]).name] objectAtIndex:indexPath.row] ;
    
    [self performSegueWithIdentifier:@"shopcar2gooddetail" sender:shopCarGood.pid] ;
}

#pragma mark -- 
#pragma mark - Delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES ;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        int section  = indexPath.section ;
        int row      = indexPath.row     ;
        
//  DEL DATA SOURCE FROM CLIENT AND SERVER
        ShopCarGood *shopCar = ((ShopCarGood *)[[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:section - 1]).name] objectAtIndex:row]);
        //  DEL DATA SOURCE FROM CLIENT
        [[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:section - 1]).name] removeObjectAtIndex:row] ;
        //  DEL DATA SOURCE FROM SERVER
        dispatch_queue_t queue = dispatch_queue_create("deleteShopCartProductQueue", NULL) ;
        dispatch_async(queue, ^{
            BOOL b = [ServerRequest deleteShopCarWithCid:shopCar.cid] ;
            if (b) {
                NSLog(@"购物车,删除成功,cid : %d",shopCar.cid) ;
            }
        }) ;

        
//  DEL FROM VIEW
        //DEL  TABLE VIEW CELL
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationBottom];
        
        //DEL  SECTION
        NSArray *list = [m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:section - 1]).name] ;
        
        //  DEL SECTION HEAD VIEW
        if (! list.count)
        {
            // HEAD
            int headCount =  m_headViewArray.count ;
            //m_headViewArray.count - 1;
            
            for (int i = 0; i < headCount; i++)
            {
                ShopCarHeadView *headV = (ShopCarHeadView *)[m_headViewArray objectAtIndex:i] ;
                if (headV.section == section)
                {
                    [m_headViewArray removeObjectAtIndex:i] ;
                    break ;
                }
            }
            
            int sumNum = 0 ;
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:m_KeyArray] ; // 用于操作的临时变量
            
            for (int index = 0; index < m_KeyArray.count; index ++)
            {
                NSString *key   = ( (WareHouse *)m_KeyArray[index] ).name ;
                NSMutableArray *arraylist = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
                
                if (!arraylist.count) {
                    [tempArray removeObjectAtIndex:index] ;
                    m_NUM_orgShop-- ;
                }
                
                sumNum += arraylist.count ;
            }
            
            m_KeyArray = tempArray ;
            
            if (! sumNum)
            {
                // nothing products show
                self.isNothing = YES ;
            }
            

        }
        
        [ShopCarGood getShopCartCount] ;
        
        [self checkEverySelectGoodsTotalPrice] ;
        
        NSLog(@"m_dicDataSource%@",m_dicDataSource);
        
        // Reload data
        [table_shopCar reloadData] ;

    }
}



#define     TABLEHEADHEIGHT             40.0f
#define     HEGHT_FOOT                  35.0f

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *emptyView = [[UIView alloc] init] ;
    emptyView.backgroundColor = nil ;
    
    if ( !m_KeyArray.count ) return emptyView ;
    
    ShopCarHeadView *headV = (ShopCarHeadView *)[[[NSBundle mainBundle] loadNibNamed:@"ShopCarHeadView" owner:self options:nil] firstObject] ;
    headV.frame = CGRectMake(0, 0, 320, 40) ;
    
    headV.delegate  = self ;
    headV.section   = section ;
    
    headV.isSelected = NO ;
    
    if (!section) // 全选
    {
        headV.lb_orgShop.text = @"全选" ;
        
        // 是否全选
        int allnum  = 0 ;
        
        for (int index = 0; index < m_KeyArray.count; index ++)
        {
            int loseNum = 0 ;

            NSString *key = ( (WareHouse *)m_KeyArray[index] ).name ;
            NSMutableArray *arraylist = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
            int partAllNum = 0 ;
            for (int i = 0 ; i < arraylist.count ; i++)
            {
                ShopCarGood *shopCarGood = (ShopCarGood *)arraylist[i] ;
                partAllNum = shopCarGood.isSelectedInShopCar ? partAllNum+1 : partAllNum ;
                shopCarGood.isLoseEfficient ? loseNum++ : loseNum ;
            }
            
            allnum = (partAllNum + loseNum == arraylist.count) ? allnum + 1 : allnum ;
            
            headV.isAllHead = YES ;
            headV.isSelected = ( allnum == m_KeyArray.count ) ? YES : NO ;
            headV.backgroundColor = COLOR_BACKGROUND ;
            headV.bt_edit.hidden = YES ; //不编辑
            
        }
        
    }
    else // 商家 全选
    {
        
        for (int index = 0; index < m_KeyArray.count; index++)
        {
            if ( index + 1 == section )
            {
                int loseNum = 0 ;
                
                NSString *key = ( (WareHouse *)m_KeyArray[index] ).name ;
                NSMutableArray *arraylist = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
                
                headV.lb_orgShop.text = key ;
                
                int partAllnum = 0 ;
                for (int i = 0; i < arraylist.count; i++)
                {
                    ShopCarGood *shopCarGood = (ShopCarGood *)arraylist[i];
                    partAllnum = shopCarGood.isSelectedInShopCar ? partAllnum+1 : partAllnum;
                    shopCarGood.isLoseEfficient ? loseNum++ : loseNum ;
                }
                
                headV.isSelected = (partAllnum + loseNum == arraylist.count) ? YES : NO ;
                
                break ;
            }
        }
    }
    
    
    @synchronized (m_editSectionList)
    {
        BOOL edited = NO;
        
        if (m_editSectionList.count)
        {
            for (int i = 0; i < m_editSectionList.count; i++)
            {
                if ([m_editSectionList[i] intValue] == section)
                {
                     edited = YES ;
                }
            }
            
            headV.isEdited = edited ;
        }
    }
    
    return headV;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (! m_KeyArray.count) return 1.0f ;
    
    for (int index = 0; index < m_KeyArray.count; index++)
    {

        NSString *key = ( (WareHouse *)m_KeyArray[index] ).name ;
        NSMutableArray *arraylist = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
        if (!arraylist.count)
        {
            if (section - 1 == index) return 1.0f ;
        }
        else
        {
            return TABLEHEADHEIGHT ;
        }
    }
    
    if (!section)
    {
        return TABLEHEADHEIGHT ;
    }
    
    return 1.0f ;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//  Footer View list
    UIView *emptyView   = [[UIView alloc] init] ;
    emptyView.frame     = CGRectMake(0, 0, 320, 1) ;
    
    return emptyView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 1.0f ;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource
{
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    
    float sec = 1.0f ;

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0) ;
    dispatch_async(queue, ^{
        
        __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
            
            [self getDataAndparselProductListAndConfig] ;               // 获取购物车list

        } withPrefix:@"result time"] ;
        
        float smallsec = seconds / 1000.0f ;
        
        if (sec > smallsec)
        {
            float sleepTime = sec - smallsec ;

            dispatch_async(dispatch_get_main_queue(), ^() {
                sleep(sleepTime) ;
                [self finishPullUpMainThreadUI] ;
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^() {
                [self finishPullUpMainThreadUI] ;
            });
        }
        
    }) ;
 
}

- (void)finishPullUpMainThreadUI
{
    //
    [YXSpritesLoadingView dismiss] ;
    
    //  get from server
    //  seller list
    //  set Head View s, foot view s
    [self setHeadViewArray] ;
    
    // set all selected 全选
    [self sendTheSelectedSection:0 AndWithAllSelect:YES] ;
    
    // 保存不能勾选的
    [self setTheLoseEfficientShopCartProductsWhenNeeded] ;

    //算钱
    [self checkEverySelectGoodsTotalPrice] ;
    
    //  model should call this when its done loading
    _reloading = NO ;
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:table_shopCar] ;
    
    if ( (!m_dicDataSource.count) || (!m_KeyArray.count) )
    {
        self.isNothing = YES ;
    }
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    
    [self reloadTableViewDataSource];
    
    [self doneLoadingTableViewData] ;
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    
    return [NSDate date]; // should return date data source was last changed
    
}


#pragma mark --
#pragma mark - show Note Can not buy
- (void)showNoteCannotBuyWithCheckPrice:(CheckPrice *)aCheck
{
    NSString *notCheckStr = @"" ;
    
    if ( (aCheck.noteinfo == nil) || ([aCheck.noteinfo isKindOfClass:[NSNull class]]) )
    {
//        [DigitInformation showWordHudWithTitle:WD_HUD_NOT_SELL_BY_US] ;
        return ;
    }
    
    
    for (NSString *noteStr in aCheck.noteinfo)
    {
        int noteID = [noteStr intValue] ;
        
        for (NoteCantBuy *note in G_NOTE_CANT_BUY)
        {
            if (note.idNote == noteID)
            {
                notCheckStr = [notCheckStr stringByAppendingString:[NSString stringWithFormat:@" %@",note.name]] ;
            }
        }
    }
    
    [DigitInformation showWordHudWithTitle:notCheckStr] ;
}


#pragma mark --
#pragma mark - ShopCarHeadViewDelegate 全选
/*
 * section     :    传递 哪个section的headview
 * allselect   :    yes全选  no取消全选
 */
- (void)sendTheSelectedSection:(int)section AndWithAllSelect:(BOOL)allSelect
{
//1 勾选
    
    //全选,非全选
    if (!section) // 总的 全选
    {
        for (int index = 0; index < m_KeyArray.count; index ++)
        {
            WareHouse *aWarehouse = (WareHouse *)m_KeyArray[index] ;
            NSString *key = aWarehouse.name ;
            NSMutableArray *arraylist = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
            for (int i = 0 ; i < arraylist.count ; i++)
            {
                //判断核价通过否
                ShopCarGood *shopCarg = (ShopCarGood *)[arraylist objectAtIndex:i] ;
                CheckPrice *aCheck = shopCarg.checkPrice ;
                BOOL bResult = [self getResult:shopCarg] ;
                
                if (! bResult)
                {
                    if (allSelect) [self showNoteCannotBuyWithCheckPrice:aCheck] ;
                    ((ShopCarGood *)[arraylist objectAtIndex:i]).isSelectedInShopCar = NO ;
                }
                else
                {
                    ((ShopCarGood *)[arraylist objectAtIndex:i]).isSelectedInShopCar = allSelect ;
                }
            }
        }
        

        
    }
    else    // 商家的 全选
    {
        int sectionRows = [table_shopCar numberOfRowsInSection:section] ;
        for (int i = 0; i < sectionRows; i ++)
        {
            //判断核价通过否
            ShopCarGood *shopCarg = (ShopCarGood *)[[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:(section-1)]).name] objectAtIndex:i] ;
            CheckPrice *aCheck = shopCarg.checkPrice ;
            BOOL bResult = [self getResult:shopCarg] ;
            
            if (!bResult)
            {
                if (allSelect) [self showNoteCannotBuyWithCheckPrice:aCheck] ;
                ((ShopCarGood *)[[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:(section-1)]).name] objectAtIndex:i]).isSelectedInShopCar = NO;
            }
            else
            {
                ((ShopCarGood *)[[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:(section-1)]).name] objectAtIndex:i]).isSelectedInShopCar = allSelect;
            }
        }
        

    }
    
//2  计算并显示所有勾选商品的总价
    [self checkEverySelectGoodsTotalPrice] ;
    

    
    [table_shopCar reloadData] ;
}

//- (void)setAll:(BOOL)allselect WithSection:(int)section
//{
//    if (allselect) {
//        [m_selectAllCollectionList addObject:[NSNumber numberWithInt:section]] ;
//    } else {
//        [m_selectAllCollectionList removeObject:[NSNumber numberWithInt:section]] ;
//    }
//    
//    if ( (m_selectAllCollectionList.count == m_KeyArray.count + 1) && (!allselect) )
//    {
//        [m_selectAllCollectionList removeObject:[NSNumber numberWithInt:0]] ;
//    }
//    if ( (allselect) && (m_selectAllCollectionList.count == m_KeyArray.count) ) {
//        [m_selectAllCollectionList addObject:[NSNumber numberWithInt:0]] ;
//    }
//    
//}



//  编辑所属商家的购买数量
- (void)editBuyNumWithSection:(int)section AndWithEditOrNot:(BOOL)b
{
    //  通知cell, 编辑状态
    NSLog(@"section edit : %d",section) ;
    
    b = !b ;
    
    if (b)
    {
        [self addEditDataSourceWithSec:section] ;
    }
    else
    {
        [self delEditDataSourceWithSec:section] ;
    }
    
    [table_shopCar reloadData] ;
}


- (void)addEditDataSourceWithSec:(int)section
{
    @synchronized (m_editSectionList)
    {
        if (m_editSectionList.count)
        {
            BOOL has = NO ;
            
            for (int i = 0; i < m_editSectionList.count; i++)
            {
                if ([m_editSectionList[i] intValue] == section)
                {
                    has = YES ;
                }
            }
          
            if (!has)
            {
                [m_editSectionList addObject:[NSNumber numberWithInt:section]] ;
            }
        }
        else
        {
            [m_editSectionList addObject:[NSNumber numberWithInt:section]] ;
        }
    }
}


- (void)delEditDataSourceWithSec:(int)section
{
    @synchronized (m_editSectionList)
    {
        if (m_editSectionList.count)
        {
            for (int i = 0; i < m_editSectionList.count; i++)
            {
                if ([m_editSectionList[i] intValue] == section)
                {
                    [m_editSectionList removeObjectAtIndex:i] ;
                }
            }
        }
    }
}


#pragma mark --
#pragma mark - ShopCarCellDelegate  单选
/*
 * section     :    传递 哪个section的cell
 * row         :    传递 section中哪个row的cell
 * isSelect    :    yes选  no取消选
**/
- (void)sendTheCellSection:(int)section
                AndWithRow:(int)row
           AndWithIsSelect:(BOOL)isSelect
{
//    NSLog(@"key arr :%@",m_KeyArray);
//1-- 勾选显示 --
    for (int sec = 1; sec <= m_KeyArray.count; sec ++)
    {
        NSString *key = ((WareHouse *)[m_KeyArray objectAtIndex:sec - 1]).name ;

        NSMutableArray *arr = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
        
        for (int r = 0 ; r < arr.count; r ++)
        {
            if ( (sec == section)&&(r == row) )
            {
                // judge ? 是否通过核价 ? 通过:能勾上, 未通过:不能勾上
                ShopCarGood *shopCarg = ((ShopCarGood *)[arr objectAtIndex:r]) ;
                CheckPrice *aCheck = shopCarg.checkPrice ;
                BOOL bResult = [self getResult:shopCarg] ;
                //
                if ( !bResult )
                {
                    [self showNoteCannotBuyWithCheckPrice:aCheck] ;     //这是不能勾选, 原因是失效的或者是buystatus为false
                    ((ShopCarGood *)[arr objectAtIndex:r]).isSelectedInShopCar = NO ;
                }
                else
                { //正常勾选, 取消勾选
                    ((ShopCarGood *)[arr objectAtIndex:r]).isSelectedInShopCar = !((ShopCarGood *)[arr objectAtIndex:r]).isSelectedInShopCar ;
                }
            }
        }
    }
    
//2-- 核对总价 --
    [self checkEverySelectGoodsTotalPrice] ;
    
    [table_shopCar reloadData] ;
}

- (BOOL)getResult:(ShopCarGood *)shopCarg
{
    CheckPrice *aCheck = shopCarg.checkPrice ;
    BOOL bCheckSuccess = [aCheck checkBoxCanSelected] ;
    BOOL bResult = !shopCarg.isLoseEfficient && bCheckSuccess ;
    
    return bResult ;
}

/*
 * send shopcarGood When Click Product Pictures
 */
- (void)sendShopCarGoodWhenClickProductPictures:(ShopCarGood *)shopcarGood
{
    [self performSegueWithIdentifier:@"shopcar2gooddetail" sender:shopcarGood.pid] ;
}


#pragma mark --
#pragma mark - 亚马逊勾选总价  加购
- (float)amazeTotal
{
    float amazeTotalPrice = 0.0f ;

    for (int sec = 1; sec <= m_KeyArray.count; sec ++)
    {

        WareHouse *aWarehouse = (WareHouse *)[m_KeyArray objectAtIndex:sec - 1];
        
        if (aWarehouse.idWarehouse == 8) // 美亚
        {
            //  amazeing
            NSString *key       = ((WareHouse *)[m_KeyArray objectAtIndex:sec - 1]).name ;
            NSMutableArray *arr = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
            
            for (int r = 0 ; r < arr.count; r ++)
            {
                ShopCarGood *shopCarG = ((ShopCarGood *)[arr objectAtIndex:r]) ;
                
                if (shopCarG.isSelectedInShopCar)
                {
                    float strPrice = shopCarG.checkPrice.usaPrice ;     //(g.promotiom == nil) ? g.actual_price : g.promotiom.price ;
                    float pri = shopCarG.nums * strPrice    ;
                    amazeTotalPrice += pri                  ;
                }
            }
            
            return amazeTotalPrice  ;
        }
    }
    
    return 0 ;
}

#pragma mark --
#pragma mark - 计算并显示所有勾选商品的总价 check Every Select Goods Total Price
- (void)checkEverySelectGoodsTotalPrice
{
    [self checkOutButtonOnOff:NO] ;
    
//1 .是否加购
    [self isAddOn] ;
   
//2 .算钱
    [self calculation] ;
    
}


//是否加购
- (void)isAddOn
{
    m_is_Add_On           = NO  ;
    
    for (int sec = 1; sec <= m_KeyArray.count; sec ++)
    {
        NSString *key = ((WareHouse *)[m_KeyArray objectAtIndex:sec - 1]).name ;
        NSMutableArray *arr = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
        
        for (int r = 0 ; r < arr.count; r ++)
        {
            ShopCarGood *shopCarG = ((ShopCarGood *)[arr objectAtIndex:r]) ;
            Goods       *g        = shopCarG.good ;
            
            if (shopCarG.isSelectedInShopCar)
            {
                
                //float strPrice = (g.promotiom == nil) ? g.actual_price : g.promotiom.price ;
                //float pri = shopCarG.nums * strPrice ;
                //total_handPrice += pri ;
                
                for (int i = 0; i < g.type.count ; i++)
                {
                    NSString *str = g.type[i]   ;
                    if ([str isEqualToString:@"addon"])
                    {
                        m_is_Add_On = YES ;
                    }
                }
            }
        }
    }
    
    
    //2 是否能下单 (不能购买的原因) 亚马逊 addon
    if (m_is_Add_On)
    {
        float amazeTotalPrice = [self amazeTotal] ; //美元
        
        NSLog(@"amazeTotalPrice : %lf",amazeTotalPrice) ;
        NSLog(@"ADDON : %f ",G_ADDON) ;
        
        
        if (amazeTotalPrice < G_ADDON)
        {      //ADDON * EXCHANGE_RATE)
            NSLog(@"不能下单, 亚马逊加购 不满25美元") ;
            [self checkOutButtonOnOff:NO] ;
            [DigitInformation showWordHudWithTitle:WD_HUD_ADDBUYGOODS] ;
        }
        else
        {
            NSLog(@"满足加购条件,可以购买") ;
            [self checkOutButtonOnOff:YES] ;
        }
    }
}

//算钱
- (void)calculation
{
    NSMutableArray *selectedCartIDList = [NSMutableArray array] ;
    for (int sec = 1; sec <= m_KeyArray.count; sec ++)
    {
        NSString        *key = ((WareHouse *)[m_KeyArray objectAtIndex:sec - 1]).name  ;
        NSMutableArray  *arr = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
        
        for (int r = 0 ; r < arr.count; r ++)
        {
            ShopCarGood *shopCarG = ((ShopCarGood *)[arr objectAtIndex:r]) ;
            
            if (shopCarG.isSelectedInShopCar && !shopCarG.isLoseEfficient)
            {
                [selectedCartIDList addObject:[NSNumber numberWithInt:shopCarG.cid]] ;
            }
        }
    }
    
    if (!selectedCartIDList.count)
    {
        _lb_sellerFreight.hidden = YES ;
        _lb_interFreight.hidden  = YES ;
        
        //清空购物车总价
        [self setupTotalViewWithSelected:selectedCartIDList.count] ;
        
        return ;
    }
    
    
    __block ResultPasel *result ;
    dispatch_queue_t queue = dispatch_queue_create("calculationQueue", NULL) ;
    dispatch_async(queue, ^{
        
        result = [ServerRequest calculateFreightWithCidLists:selectedCartIDList] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self checkOutButtonOnOff:YES] ;
            
            [self parselCalculationResult:result AndWithSelectCartIDListCount:selectedCartIDList.count] ;
            
        }) ;
    }) ;
    
}


- (void)parselCalculationResult:(ResultPasel *)result AndWithSelectCartIDListCount:(int)selectCount
{
    if (!result)
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK] ;
        return ;
    }
    
    if (result.code == 200)
    {
        NSDictionary *freightDic = [(NSDictionary *)(result.data) objectForKey:@"freight"] ;
        m_shopcarFreight = [[ShopCarFreight alloc] initWithDictionary:freightDic] ;
        
        NSDictionary *dicData = result.data ;
        m_shopcarTotal = [[ShopCarTotal alloc] initWithDiction:dicData] ;
        
        //更新购物车总价
        [self setupTotalViewWithSelected:selectCount] ;
        
        //更新美国运费和国际运费...
        [self setupFreightView] ;
        
        [self checkOutButtonOnOff:YES] ;
    }
    else
    {
        if (result.info && [result.info isEqualToString:@""]) {
            [DigitInformation showWordHudWithTitle:result.info] ;
        }
        
        if (result.code == 1003)
        {
            NSDictionary *freightDic = [(NSDictionary *)(result.data) objectForKey:@"freight"] ;
            m_shopcarFreight = [[ShopCarFreight alloc] initWithDictionary:freightDic] ;
            
            NSDictionary *dicData = result.data ;
            m_shopcarTotal = [[ShopCarTotal alloc] initWithDiction:dicData] ;
            
            //更新购物车总价
            [self setupTotalViewWithSelected:selectCount] ;
            
            //更新美国运费和国际运费...
            [self setupFreightView] ;
        }
        
        //不能购买
        [self checkOutButtonOnOff:NO] ;

    }
}



- (void)setupFreightView
{
    _lb_sellerFreight.hidden = (m_shopcarFreight.usa_freight) ? NO : YES ;
    _lb_interFreight.hidden  = (m_shopcarFreight.inter_freight) ? NO : YES ;
    
    _lb_sellerFreight.text = [NSString stringWithFormat:@"商家运费:￥%.2f",m_shopcarFreight.usa_freight] ;
    _lb_interFreight.text  = [NSString stringWithFormat:@"国际运费:￥%.2f",m_shopcarFreight.inter_freight] ;
}


- (void)setupTotalViewWithSelected:(BOOL)selected
{
    
    NSString *strButton = selected ? [NSString stringWithFormat:@"结算(%d)",m_shopcarTotal.total_number] : @"结算" ;
    [button_checkout setTitle:strButton forState:UIControlStateNormal]          ;
    
    lb_price_value.text = selected ? [NSString stringWithFormat:@"￥%.2f",m_shopcarTotal.total_price] : @"￥0.00" ;
    
    _lb_interFreight.hidden = !selected ;
    _lb_sellerFreight.hidden = !selected ;
    
}


#pragma mark --
#pragma mark - go To Check Out Action         去结算
- (IBAction)goToCheckOutAction:(id)sender
{
    __block NSDictionary *dictionary = [NSDictionary dictionary] ;
    __block BOOL bBuyAndCheckFinish  = NO ; //所勾选的商品 是否通过核价, 并且能购买
    
    
    //  get cidList and pidList
    //  全部商品的pid, 用来核价的,  pid list
    NSMutableArray *pidList = [NSMutableArray array] ;
    // 1  获取购物车已选择的商品 : cidList , 传到checkOut ctrl
    NSMutableArray *cidList = [NSMutableArray array] ;
    
    for (int sec = 0; sec < m_KeyArray.count; sec ++)
    {
        NSString        *key = ((WareHouse *)[m_KeyArray objectAtIndex:sec]).name      ;
        NSMutableArray  *arr = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
        
        for (int r = 0 ; r < arr.count; r ++)
        {
            ShopCarGood *shopCarG = ((ShopCarGood *)[arr objectAtIndex:r]) ;
            
            if (shopCarG.isSelectedInShopCar)
            {
                NSNumber *num = [NSNumber numberWithInt:shopCarG.cid] ;
                [cidList addObject:num] ;
                [pidList addObject:shopCarG.pid] ;
            }
        }
    }
    
    
    //  是否需要核价,选中的商品
    BOOL bNeedCheck = [self isNeedToCheckMoreWithAllOrSelected:NO AndWithCheckFinishOrCanBuy:YES] ;   // 检查选中的商品
    
    NSString *strHud = bNeedCheck ? WD_HUD_CHECKPRICE : WD_HUD_GOON ;
    
    
    [YXSpritesLoadingView showWithText:strHud andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{

        if (bNeedCheck)//需要核价
        {
            // 去核价 (多次)
            NSArray *checkList = [CheckPrice funcCheckPriceWithList:pidList] ;
            
            // 把核价更新到购物车
            [self putCheckListIntoShopCarListWith:checkList] ;
            
            // 检查 这次核价 是否通过 ,是否能购买
            BOOL bNeedCheckAgain = [self isNeedToCheckMoreWithAllOrSelected:NO AndWithCheckFinishOrCanBuy:YES] ; // 检查选中的商品是否核价过 . 是否需要核价
            
            if (!bNeedCheckAgain)
            {
                // 不需要再核价 , 这次的核价过了
                bBuyAndCheckFinish = [self isNeedToCheckMoreWithAllOrSelected:NO AndWithCheckFinishOrCanBuy:NO] ; //检查选中的商品是否能购买
            }
            else
            {
                // 还需要再核价 , 有商品核价永远通不过 . 把此商品的钩子去掉
                m_neverCheckFinishedProductCidList = [self getM_neverCheckedFinishCidListFromSelectedList] ;
                
                [self setTheLoseEfficientShopCartProductsWhenNeeded] ;
            }
        }
        else
        {
            //不需要核价了 ,  以前已经核过价了
            bBuyAndCheckFinish = [self isNeedToCheckMoreWithAllOrSelected:NO AndWithCheckFinishOrCanBuy:NO] ; //检查选中的商品是否能购买
        }
        
        NSLog(@"选中商品中 : %@" , (bNeedCheck           ? @"需要核价" : @"不需要核价") );
        NSLog(@"选中商品中 : %@" , (bBuyAndCheckFinish   ? @"能购买"   : @"不能购买") );
        
        //  order confirm check out to server
        if (bBuyAndCheckFinish)
        {
            dictionary = [ServerRequest getCheckOutListWithCidList:cidList] ;   //, 确认订单
        }
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        //  [self checkOutButtonOnOff:!bNeedCheck_Again] ;  // 不通过, 关闭购买bt
        
        // 不能购买 , 不让购买 , hud
        if (!bBuyAndCheckFinish)
        {
            [DigitInformation showWordHudWithTitle:WD_CHECKPRICE_NOT_PASS] ;
            
            // 把不能购买的商品标记出来
            // 通过m_neverCheckFinishedProductCidList ,在 cellforRow At index中 做到
            [self sendTheSelectedSection:0 AndWithAllSelect:NO] ;
            [self setupTotalViewWithSelected:NO] ;
        }
        else
        {
            //核价通过 , 可以购买 , 进入下单 checkout
            if ( [[dictionary objectForKey:@"code"] intValue] == 200 )
            {
                [self performSegueWithIdentifier:@"shopcar2checkout" sender:dictionary] ;
            }
            else
            {
                NSString *info = [dictionary objectForKey:@"info"] ;
                [DigitInformation showWordHudWithTitle:info] ;
            }
        }

        [table_shopCar reloadData] ;

    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
    
}

// 有商品核价永远通不过 . 把此商品的钩子去掉
- (void)setTheLoseEfficientShopCartProductsWhenNeeded
{
    if (!m_neverCheckFinishedProductCidList.count) return ;
    
    
    for (int sec = 0; sec < m_KeyArray.count; sec ++)
    {
        NSString *key       = ((WareHouse *)[m_KeyArray objectAtIndex:sec]).name ;
        NSMutableArray *arr = (NSMutableArray *)[m_dicDataSource objectForKey:key] ;
        
        for (int r = 0 ; r < arr.count; r ++)
        {
            ShopCarGood *shopCarG = ((ShopCarGood *)[arr objectAtIndex:r]) ;
            for (int i = 0; i < m_neverCheckFinishedProductCidList.count; i++)
            {
                int cidNever = [m_neverCheckFinishedProductCidList[i] intValue] ;
                if (shopCarG.cid == cidNever)
                {
                    ((ShopCarGood *)[arr objectAtIndex:r]).isLoseEfficient = YES  ;
                }
            }
        }
    }
}



//  1是否需要核价,购物车中选中的商品
//  2是否能购买
/*
 *  @param : bAllOrSelected         bool yes->all       , no->selected
 *  @param : bCheckFinishOrCanBy    bool yes->核价完成   ,  no->能否购买
 */
- (BOOL)isNeedToCheckMoreWithAllOrSelected:(BOOL)bAllOrSelected AndWithCheckFinishOrCanBuy:(BOOL)bCheckFinishOrCanBy
{
    BOOL bResult = NO ;    //    是否需要核价, 所有商品
    
    NSMutableArray *tempShopCarList = [ShopCarGood getShopCartListWithAllOrSelected:bAllOrSelected AndWithDataSouce:m_dicDataSource AndWithKeyArray:m_KeyArray] ;
    
    
    if (bCheckFinishOrCanBy) {
        bResult = [CheckPrice isNeedCheckPriceWithShopCarList:tempShopCarList] ; //是否需要再核价
    } else {
        bResult = [CheckPrice isCanBuyWithShopCarList:tempShopCarList] ;         //是否能购买
    }
    
    return bResult ;
}







- (NSMutableArray *)getM_neverCheckedFinishCidListFromSelectedList
{
    
    NSMutableArray *tempShopCarList = [ShopCarGood getShopCartListWithAllOrSelected:NO AndWithDataSouce:m_dicDataSource AndWithKeyArray:m_KeyArray] ;

    return [CheckPrice getNeverCheckeFinishedProductsCidList:tempShopCarList] ;

    
}



#pragma mark --
#pragma mark - check out button switch on / off
- (void)checkOutButtonOnOff:(BOOL)b
{
    if (b)
    {
        //  on
        button_checkout.backgroundColor = COLOR_PINK    ;
        [button_checkout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        button_checkout.userInteractionEnabled = YES    ;
    }
    else
    {
        //  off
        button_checkout.backgroundColor = COLOR_LIGHT_GRAY ;
        [button_checkout setTitleColor:COLOR_WHITE_GRAY forState:UIControlStateNormal] ;
        button_checkout.userInteractionEnabled = NO     ;
    }
}


#pragma mark --
#pragma mark - StepTfViewDelegate
- (void)refreshTableWithNum:(int)numbuy AndWithSection:(int)section AndWithRow:(int)row
{
    NSLog(@"numbuy %d",numbuy) ;
    
//1-- 数字刷新 --
    for (int i = 1; i <= m_NUM_orgShop; i++)
    {
        if (section == i)
        {
            ShopCarGood *shopCar = ((ShopCarGood *)[[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:i-1]).name] objectAtIndex:row]);
            
            BOOL success = [ServerRequest changeShopCarWithCid:shopCar.cid AndWithNums:numbuy] ;
            if (success)
            {
                ((ShopCarGood *)[[m_dicDataSource objectForKey:((WareHouse *)[m_KeyArray objectAtIndex:i-1]).name] objectAtIndex:row]).nums = numbuy ;
            }
        }
    }
    
//2-- 计算总价 --
    [self checkEverySelectGoodsTotalPrice] ;
    
    [table_shopCar reloadData] ;
}

#pragma mark --
#pragma mark - NSNotificationCenter
- (void)numKeyBoardShow:(NSNotification *)notification
{
    // move cell up to see
    float upOffset = 0.0f ;
    
    [UIView beginAnimations:@"upTableAnimation" context:nil] ;
    [UIView setAnimationDuration:0.3f] ;
    table_shopCar.frame = CGRectMake(0, table_shopCar.frame.origin.y - upOffset, table_shopCar.frame.size.width, table_shopCar.frame.size.height) ;
    [UIView commitAnimations] ;
    
    // show key board tool bar
    UITextField *tf = (UITextField *)notification.object ;
    [m_keyboardbar showBar:tf] ;
}

#pragma mark --
#pragma mark - KeyBoardTopBarDelegate
- (void)shutDownKeyBoard
{
    float upOffset = 0.0f ;

    [UIView beginAnimations:@"upTableAnimation" context:nil] ;
    [UIView setAnimationDuration:0.3f] ;
    table_shopCar.frame = CGRectMake(0, table_shopCar.frame.origin.y + upOffset, table_shopCar.frame.size.width, table_shopCar.frame.size.height) ;
    [UIView commitAnimations] ;
}



#pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"shopcar2checkout"])
     {
         CheckOutController *checkOutCtrller = (CheckOutController *)[segue destinationViewController] ;
         checkOutCtrller.resultDiction = (NSDictionary *)sender ;
     }
     else if ([segue.identifier isEqualToString:@"shopcar2gooddetail"])
     {
         GoodsDetailViewController *detailVC = (GoodsDetailViewController *)[segue destinationViewController] ;
         detailVC.codeGoods     = (NSString *)sender  ;
     }
     
     [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
     
 }



@end



