//
//  GoodsDetailViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "DigitInformation.h"
#import "LSCommonFunc.h"
#import "ServerRequest.h"
#import "ChooseViewController.h"
#import "MyWebController.h"
#import "DealPhotoVideoViewController.h"
#import "YXSpritesLoadingView.h"
#import "SBJson.h"
#import "UIImage+AddFunction.h"
#import "UIBarButtonItem+Badge.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import <objc/runtime.h>
#import <ShareSDK/ShareSDK.h>
#import "SDImageCache.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "SellerTB.h"
#import "CheckOutController.h"
#import "GoodBasicCell.h"
#import "DetailSubController.h"
#import "PopInfoCell.h"
#import "ModalTablePopView.h"
#import "GoodConditionCell.h"
#import "HandPriceCell.h"
#import "UIButton+Badges.h"
#import "GoodsCommentsController.h"
#import "DetailCellObj.h"
#import "ExpressageDetail.h"
#import "NavRegisterController.h"
#import "HelpView.h"
#import "MyWebController.h"
#import "MoreCell.h"


#define IOS7_NAVI_SPACE   -10.0f


@interface GoodsDetailViewController ()<PopMenuViewDelegate,ChooseViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,ModalTablePopViewDelegate,GoodBasicCellDelegate,DetailSubControllerDelegate,ShopCarGoodDelegate,HelpViewDelegate,GoodConditionCellDelegate,ISSShareViewDelegate>  
{
    
    UIImageView         *m_imgView_shopCar ;
    Goods               *m_goods ;
    UIButton            *m_bt1 ;
    UIButton            *m_bt2 ;
    UIButton            *m_bt3 ;
    UIButton            *m_bt4 ;
    
    ModalTablePopView   *m_modalPopView ;
    
    BOOL                m_alreadyLiked ;        //是否已经喜欢
    
    //  价格详情
    NSMutableArray      *m_priceDetailList ;
    //  发货详情
    ExpressageDetail    *m_epDetail    ;
    
    // views
    DetailSubController *m_detailSubVC ;
    
    //help view
    HelpView            *m_helpview ;
    
    CAShapeLayer        *arcLayer;
    
    
    // bool shut down shopcar button in cell
    BOOL                m_bShopCarButtonInCell ;
}

@end

@implementation GoodsDetailViewController

@synthesize m_buyNums ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self ;
}

#define BARBUTTONS_HEIGHT       15.0f

- (void)setViewStyle
{
    //1
    [self setAnimationPicture] ;
    
    //2
    [self setBarButtons] ;
    
    //3 button set gesture
    //单击手势
    [self setShopCarButtonGestures] ;
    
    //4 help view
    [self addHelpView] ;
    
}

- (void)setShopCarButtonGestures
{
    
    _img_shopCar.userInteractionEnabled = YES ;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_img_shopCar addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [_img_shopCar addGestureRecognizer:doubleTap];
    
    //区别单击、双击手势
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1.0f;
    [_img_shopCar addGestureRecognizer:longPress];
    
    [self shopCarButtonAnimation] ;
    
}

- (void)shopCarButtonAnimation
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    float tempAngle = 0 * ( M_PI / 2 ) ;
    
    animation.duration = 2.25f;
    
    float flex = 0.2 * ( M_PI / 2 ) ;
    
    animation.values = @[ @(tempAngle), @(tempAngle - flex), @(tempAngle + flex), @(tempAngle) ];
    
    animation.keyTimes = @[ @(0), @(0.68),@(0.85), @(1) ];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    animation.repeatCount = FLT_MAX ;
    
    [_img_shopCar.layer addAnimation:animation forKey:@"btShopCarAnimation"];
    
}


#pragma mark --
#pragma mark - gesture
- (void)tap:(UITapGestureRecognizer *)tapGetrue
{
    NSLog(@"单击");//
    //NSLog(@"_currentRenderingImageIndex:%d",_currentRenderingImageIndex);
    
    [self animationTransformWithButton:_img_shopCar] ;
    
    [self addShopCartAction:nil];
}

- (void)doubleTap:(UITapGestureRecognizer *)tapGetrue {
    NSLog(@"双击") ;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{

    if ([longPress state] == UIGestureRecognizerStateBegan) {
        //长按事件开始"
        [self initBezierPathForShopCarButton] ;
        [self drawLineAnimation:arcLayer] ;

        NSLog(@"长安开始") ;
        return ;
    }
    else if ([longPress state] == UIGestureRecognizerStateEnded) {
        //长按事件结束
        [self enterShopCarAction];
        
        [arcLayer removeAllAnimations] ;
        [arcLayer removeFromSuperlayer] ;
        arcLayer = nil ;
        NSLog(@"长安结束") ;
        return;
    }
}

- (void)initBezierPathForShopCarButton
{
    if (!arcLayer)
    {
        UIBezierPath *path=[UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(_img_shopCar.frame.size.width/2, _img_shopCar.frame.size.width/2) radius:_img_shopCar.frame.size.width/2 startAngle:0 endAngle:2*M_PI clockwise:NO];
        arcLayer = [CAShapeLayer layer];
        arcLayer.path = path.CGPath ;
        arcLayer.fillColor=[UIColor clearColor].CGColor;
        arcLayer.strokeColor=[UIColor colorWithRed:255.0/255.0 green:63.0/255.0 blue:117.0/255.0 alpha:0.95].CGColor; ;//[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1].CGColor ; //COLOR_PINK.CGColor;
        arcLayer.lineWidth = 4.0;
        arcLayer.frame = _img_shopCar.frame ;
        [self.view.layer addSublayer:arcLayer] ;
    }
}

- (void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 0.65f ;
    //bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    bas.repeatCount = 1 ;
    [layer addAnimation:bas forKey:@"key"];
}


#define CELL_BIG        377.0f
#define CELL_PRICEHAND  120.0f
#define CELL_SMALL      50.0f
#define CELL_CONDITION  215.0f
#define CELL_MORE       35.0f

- (void)setupViewFrame
{
    //Set table
    _tableMain.backgroundColor    = COLOR_BACKGROUND ;
    _tableMain.separatorStyle     = UITableViewCellSeparatorStyleNone ;
}

- (void)setAsyncCheckPrice
{
    dispatch_queue_t queue = dispatch_queue_create("onceCheckPriceInDetail", NULL) ;
    dispatch_async(queue, ^{
        
        NSArray *checkResultList = [CheckPrice onceCheckWithList:@[m_goods.code]] ;
        
        if ( (checkResultList) && (checkResultList.count) )
        {
            CheckPrice *checkP = [checkResultList firstObject] ;
            
            [m_goods checkingPrice:checkP] ;
        }
        
        //核价完成, 通知cell
        dispatch_async(dispatch_get_main_queue(), ^{
            [self whenCheckPriceFinished] ;
        }) ;
        
    }) ;
    
}

- (void)whenCheckPriceFinished
{
    [self setupPopUpDataSource] ;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1] ;
    HandPriceCell *cell = (HandPriceCell *)[_tableMain cellForRowAtIndexPath:indexPath] ;
    cell.checkPriceFinished = YES ;
    [_tableMain reloadData] ;
}


- (void)refreshMainTableAndSubTable
{
    [self setConnectTableViewController] ;

    [_tableMain reloadData] ;
    [self.subTableViewController.tableView reloadData] ;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - add help view
- (void)addHelpView
{
    if ([LSCommonFunc isNotFirstGoInProductDetail])
    {//若非首次进入,return
        return ;
    }
    
    m_helpview = [[HelpView alloc] initWithFrame:APPFRAME] ;
    m_helpview.delegate = self ;
    [self.view addSubview:m_helpview] ;
}

#pragma mark - HelpViewDelegate
- (void)helpViewPressedCallBack
{
    [m_helpview removeFromSuperview] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
// Do any additional setup after loading the view.
    m_buyNums       = 1     ;         //至少买一件
    m_alreadyLiked  = NO    ;
    
//1 view style
    [self setViewStyle]     ;
    [self setupViewFrame]   ;
    
//2 get from server
    __block BOOL bSuccess = NO ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        bSuccess = [self getParseledGoodDetail:_codeGoods] ;
        
        if (bSuccess)
        {
            [self reshowGoods] ;
        }
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss]  ;
        
        //已经喜欢过
        m_bt3.selected = m_alreadyLiked ;
        
        if (!bSuccess)
        {
            //failure
            [self.navigationController setNavigationBarHidden:NO animated:NO] ;
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:_tableMain.frame] ;
            imgV.backgroundColor = [UIColor whiteColor] ;
            imgV.image = [UIImage imageNamed:@"noProducts"] ;
            imgV.contentMode = UIViewContentModeScaleAspectFit ;
            [_tableMain setBackgroundView:imgV] ;
            
            //  hide All Buttons
            [self hideAllButtons] ;
        }
        else
        {
            //  success
            [self refreshMainTableAndSubTable] ;
            
            //  处理已下架
            [self setupNotOnProducts] ;
            
            //  check price
            [self setAsyncCheckPrice] ;
        }
        
    } AndWithMinSec:0] ;
    
}


- (void)setupNotOnProducts
{
    //  if good price == 0, cannot buy
    BOOL bNotShow = !m_goods.price || !m_goods.shelves || !m_goods.rmb_price ||!m_goods.buyStatus ;
    //  是否是第三方商家 , 不让购买
//    BOOL bIsThird = !( (m_goods.seller_id != -1) && (m_goods.seller_id != 0) ) ;
    BOOL bIsThird = NO ;
    
    
    // bAll
    BOOL bAll = bNotShow || bIsThird ;
    
    [self letBuyButtonsCanNotBeClick:!bAll] ;
}


#pragma mark --
#pragma mark - reshowGoods
- (void)reshowGoods
{
    //setup弹出框datasourse
    [self setupPopUpDataSource] ;
    
    //是否已喜欢
    m_alreadyLiked = [ServerRequest likeCheckedAlreadyWithProductCode:_codeGoods] ;
}

- (void)hideAllButtons
{
    m_bt1.hidden = YES ;
    m_bt2.hidden = YES ;
    m_bt3.hidden = YES ;
    m_bt4.hidden = YES ;
    
    _img_shopCar.hidden = YES ;
}


#pragma mark -- 初始化弹出框datasourse
- (void)setupPopUpDataSource
{
    //价格详情
    DetailCellObj *tempObj = [[DetailCellObj alloc] init] ;
    m_priceDetailList = [tempObj getObjListWithGoodDetail:m_goods] ;
    
    //物流简介
    NSDictionary *tempSubDic = [ExpressageDetail getDicToPaselWithSellerID:m_goods.warehouse_id AndFatherDic:G_EXPRESSDETAIL_DIC] ;
    m_epDetail = [[ExpressageDetail alloc] initWithDic:tempSubDic] ;
}


- (void)setConnectTableViewController
{
    // main table
    _tableMain.delegate           = self  ;
    _tableMain.dataSource         = self  ;
    self.tableView                = _tableMain    ;
    
    // sub table
    m_detailSubVC                 = [[DetailSubController alloc] init];
    m_detailSubVC.delegate        = self ;
    m_detailSubVC.currentGood     = m_goods       ;
    self.subTableViewController   = m_detailSubVC ;
    m_detailSubVC.tableView.delegate = self.subTableViewController ;
    m_detailSubVC.tableView.dataSource = self.subTableViewController ;
    
    //Set sub controller
    BOOL bHasNotGuiGe    = ((! _attr) && (! m_goods.attribute) && (! m_goods.attribute.count)) || !m_goods.links ; // 是否没有规格
    
    float tableNewHeight = (bHasNotGuiGe) ? [self getHeightOfPriceHand] + [self getBigCellHeight] + CELL_CONDITION + CELL_MORE : [self getHeightOfPriceHand] + CELL_SMALL + [self getBigCellHeight] + CELL_CONDITION + CELL_MORE ;
    
    [self setTableContentSizeHeight:tableNewHeight + 5] ;
}


- (void)topBarHide:(BOOL)bHide
{
    
    float moveY = bHide ? (BARBUTTONS_HEIGHT + 24.0f) : (BARBUTTONS_HEIGHT) ;
    
    [self moveButtonAnimation:m_bt1 WithHeightY:moveY] ;
    [self moveButtonAnimation:m_bt2 WithHeightY:moveY] ;
    [self moveButtonAnimation:m_bt3 WithHeightY:moveY] ;
    [self moveButtonAnimation:m_bt4 WithHeightY:moveY] ;

}


- (void)moveButtonAnimation:(UIButton *)button WithHeightY:(float)heightY
{
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.65f];
    CGRect tempFrame = button.frame ;
    tempFrame.origin.y = heightY ;
    button.frame = tempFrame ;
    [UIView commitAnimations];
}


#pragma mark --
- (BOOL)getParseledGoodDetail:(NSString *)code
{
    //1.1   good detail
    NSString *response = [ServerRequest getGoodsDetailWithGoodsCode:code] ;
    //1.2   get m_good
    BOOL b = [self parselWithResult:response] ;
    
    return b ;
}

- (void)letBuyButtonsCanNotBeClick:(BOOL)bOpen
{
    _img_shopCar.userInteractionEnabled = bOpen ;
    _img_shopCar.hidden = !bOpen ;
    
    //
    m_bShopCarButtonInCell = bOpen ;
}

- (BOOL)parselWithResult:(NSString *)resultStr
{
    //pre parsel
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *dic = [parser objectWithString:resultStr] ;
    int code = [[dic objectForKey:@"code"] intValue] ;
    if (code == 200)
    {
        //success
        NSDictionary *data = [dic objectForKey:@"data"];
        if (data == nil)
        {
            return NO ;
        }
        m_goods = [[Goods alloc] initWithDic:data];
        
        return YES ;
    }
    else
    {
        //fail
        return NO ;
    }
}



- (void)setAnimationPicture
{
    m_imgView_shopCar       = [[UIImageView alloc] initWithFrame:CGRectZero]                    ;
    m_imgView_shopCar.image = [UIImage imageNamed:@"APPlogo"]                                   ;
    m_imgView_shopCar.contentMode = UIViewContentModeScaleAspectFit                             ;
    [self.view addSubview:m_imgView_shopCar]                                                    ;
}



- (void)setBarButtons
{
    float sideLength = 50.0f ;
    m_bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_bt1 setBackgroundImage:[UIImage imageNamed:@"barbutton_back"] forState:UIControlStateNormal];
    [m_bt1 addTarget:self action:@selector(backToLastVC) forControlEvents:UIControlEventTouchUpInside];
    
    m_bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_bt2 setBackgroundImage:[UIImage imageNamed:@"barbutton_enterShopCar"] forState:UIControlStateNormal];
    [m_bt2 addTarget:self action:@selector(enterShopCar) forControlEvents:UIControlEventTouchUpInside];
    
    m_bt3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_bt3 setBackgroundImage:[UIImage imageNamed:@"barbutton_notlike"]     forState:UIControlStateNormal]    ;
    [m_bt3 setBackgroundImage:[UIImage imageNamed:@"barbutton_liked"]  forState:UIControlStateSelected]  ;   //  UIControlStateNormal
    [m_bt3 addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    
    m_bt4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_bt4 setBackgroundImage:[UIImage imageNamed:@"barbutton_share"]     forState:UIControlStateNormal]    ;
    [m_bt4 addTarget:self action:@selector(shareMyGood) forControlEvents:UIControlEventTouchUpInside];

    
    float flexH = BARBUTTONS_HEIGHT ;
    float flexW = 10.0f ;
    
    [m_bt1 setFrame:CGRectMake(- 15, flexH, 75, sideLength)] ;

    [m_bt2 setFrame:CGRectMake(APPFRAME.size.width - flexW - sideLength          , flexH, sideLength, sideLength)] ;
    [m_bt3 setFrame:CGRectMake(APPFRAME.size.width - (flexW  + sideLength) * 2 + flexW  , flexH, sideLength, sideLength)] ;
    [m_bt4 setFrame:CGRectMake(APPFRAME.size.width - (flexW  + sideLength) * 3 + flexW*2  , flexH, sideLength, sideLength)] ;
    
    [self.view addSubview:m_bt1] ;
    [self.view addSubview:m_bt2] ;
    [self.view addSubview:m_bt3] ;
    [self.view addSubview:m_bt4] ;
}

//返回action
- (void)backToLastVC
{
    [self.navigationController popViewControllerAnimated:YES]   ;
}

//分享
- (void)shareMyGood
{
    if (!m_goods) return ;
    
    //
    [self iWantShareThisGood:m_goods] ;
}

//进入购物车
- (void)enterShopCar
{
    [self enterShopCarAction] ;
}

//喜欢
- (void)like
{
    if (!m_goods) return ;
    
    //
    if ( ! G_TOKEN || [G_TOKEN isEqualToString:@""] )
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return  ;
    }
    
    [self animationTransformWithButton:m_bt3] ;
    
    dispatch_queue_t queue = dispatch_queue_create("likeQueue", NULL) ;
    dispatch_async(queue, ^{
        
        ResultPasel *result = (!m_bt3.selected) ? [ServerRequest likeCreateWithProductCode:m_goods.code] : [ServerRequest likeRemoveWithProductCode:m_goods.code] ;
        
        BOOL bSuccess = (result.code == 200)     ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bSuccess)
            {
                m_bt3.selected = !m_bt3.selected ;
            }
            else
            {
                [DigitInformation showWordHudWithTitle:result.info] ;
            }
        }) ;
        
    }) ;
}


#pragma mark --
- (void)animationTransformWithButton:(UIView *)theView
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values    = @[@(0.1),@(1.5),@(1.0)];
    k.keyTimes  = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [theView.layer addAnimation:k forKey:@"SHOW"];
}


#pragma mark --
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    
    [ShopCarGood shareInstance].delegate = self ;

}

- (void)viewWillDisappear:(BOOL) animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO  withAnimation:UIStatusBarAnimationNone];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    
    [ShopCarGood shareInstance].delegate = nil ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - ModalTablePopViewDelegate
- (void)clickOutSide
{

    [m_modalPopView removeFromSuperview] ;
    
//    m_modalPopView = nil ;
}



#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        //产品信息
        return 1 ;
    }
    else if (section == 1)
    {
        BOOL bCanNotSelectGuige = (! _attr && !m_goods.attribute && !m_goods.attribute.count ) || !m_goods.links ;
        
        if (bCanNotSelectGuige) return 1 ;
        
        //1运费关税,到达时间 , 2请选择尺码,颜色
        return 2 ;
    }
    else if (section == 2)
    {
        //情况: 全程保险 官方正品 海关检验 快速清关
        return 1 ;
    }
    else if (section == 3)
    {
        //拖动加载更多
        return 1 ;
    }
    
    return 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int section = indexPath.section ;
    int row     = indexPath.row     ;
    
    if (section == 0)        //产品信息
    {
        static NSString *TableSampleIdentifier = @"GoodBasicCell";
        GoodBasicCell *cell = (GoodBasicCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.goods = m_goods ;
        cell.delegate = self ;
        
        return cell ;
    }
    else if (section == 1)  //1运费关税 , 2预计到达时间 ,3颜色尺码
    {
        if (row == 0)
        {
            //运费关税到手价
            static NSString *TableSampleIdentifier = @"HandPriceCell";
            HandPriceCell *cell = (HandPriceCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0];
            }
            
            cell.good = m_goods ;
            
            cell.selectedProducts = ( _attr != nil ) ; // 是否已选择过尺码
            
            NSString *showStr = (! m_epDetail.title) ? @"商品信息不全" : m_epDetail.title ;
            cell.predictTime = [NSString stringWithFormat:@"%@",showStr] ;
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
        
        //尺码
        static NSString *TableSampleIdentifier = @"PopInfoCell";
        PopInfoCell *cell = (PopInfoCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        //  尺码 颜色
        if (_attr == nil)
        {
            cell.labelLeft.text = @"请选择商品规格"  ;
        }
        else
        {
            NSString *str = @"";
            for (NSString *string in [_attr allValues])
            {
                NSString *tem = [NSString stringWithFormat:@"\"%@\" ",string] ;
                str = [str stringByAppendingString:tem] ;
            }
            NSString *strNums = [NSString stringWithFormat:@"数量：x%d",m_buyNums] ;
            cell.labelLeft.text = [NSString stringWithFormat:@"已选：%@ %@",str,strNums];
        }
        
        return cell ;
    }
    else if (section == 2)
    {
        //情况: 全程保险 官方正品 海关检验 快速清关
        static NSString *TableSampleIdentifier = @"GoodConditionCell";
        GoodConditionCell *cell = (GoodConditionCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0];
        }
        cell.delegate = self ;
        cell.isSelfSupport = ([m_goods.seller.seller_id intValue] == 1000) ? YES : NO ;
        cell.isOpenShutdownShopCarButton = m_bShopCarButtonInCell ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        return cell ;
    }
    else if (section == 3)
    {
        //  拖动加载更多
        static NSString *TableSampleIdentifier = @"MoreCell";
        MoreCell *cell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;

        return cell ;
    }
    return nil ;
}

- (float)getBigCellHeight
{
    NSString *str = @"";
    BOOL bCnAndEn = m_goods.title_en && m_goods.title_cn ;
    if (bCnAndEn) {
        //有中文英文标题
        str = [NSString stringWithFormat:@"%@ %@",m_goods.title,m_goods.title_en] ;
    } else {
        //只有一个标题
        str = m_goods.title ;
    }
    
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    CGSize size = CGSizeMake(300,200);
    CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    float h = CELL_BIG - 17 + labelsize.height ;
    
    return h ;
}

- (float)getHeightOfPriceHand
{
    BOOL bHasZhekou = !m_goods.price || !m_goods.list_price || (m_goods.price / m_goods.list_price == 1.0f) ;
    // 有折扣
    if (!bHasZhekou)
    {
        return CELL_PRICEHAND ;
    }
    // 无折扣
    else
    {
        return CELL_PRICEHAND - 22 ;
    }
    
    return 0 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    int row     = indexPath.row ;
    if (section == 0)
    {
        return [self getBigCellHeight] ;
    }
    else if (section == 1)
    {
        if (row == 0) // 到手价详情物流详情
        {
            return [self getHeightOfPriceHand] ;
        }
        
        return CELL_SMALL   ;
    }
    else if (section == 2)
    {
        //情况: 全程保险 官方正品 海关检验 快速清关
        return CELL_CONDITION ;
    }
    else if (section == 3)
    {
        //  拖动加载更多
        return CELL_MORE ;
    }
    return 1 ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    int row     = indexPath.row     ;
    
    if (section == 1)
    {
        //1运费关税 , 2预计到达时间 ,
        if ( row != 1 )
        {
            BOOL bHasSectionAndNotSelect = (m_goods.price_max - m_goods.price_min > 0) && (!_attr) ; //有区间并且未选择商品
            if (bHasSectionAndNotSelect) return ; //
            
            if ( ! m_modalPopView)
            {
                m_modalPopView = (ModalTablePopView *)[[[NSBundle mainBundle] loadNibNamed:@"ModalTablePopView" owner:self options:nil] lastObject] ;
                m_modalPopView.delegate = self ;
            }
            
            [self resetModalPopView] ;

        }
        
        //3请选择尺码 , 颜色
        if (row == 1)
        {
            [self chooseGoodsCatagoryWithAttr:m_goods.attr AndWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
        }
        
    }
}


- (void)resetModalPopView
{
    //1运费关税
    m_modalPopView.data_priceDetail = m_priceDetailList;
    //2预计到达时间
    m_modalPopView.expressDetail = m_epDetail ;
    //3是否自营
    m_modalPopView.isSelfSales = ([m_goods.seller.seller_id intValue] == 1000) ? YES : NO ;
    //4是否加购Amazon   //加购
    BOOL isAddon = NO ;
    if (m_goods.seller_id == 1)
    {
        for (int i = 0; i < m_goods.type.count ; i++)
        {
            NSString *str = m_goods.type[i] ;
            if ([str isEqualToString:@"addon"])
            {
                isAddon = YES ;
            }
        }
    }
    m_modalPopView.isAddAmazon = isAddon ;
    //5商家
    m_modalPopView.seller = m_goods.seller ;
    
    [m_modalPopView.table reloadData] ;
    
    [self.view addSubview:m_modalPopView] ;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgview = [[UIView alloc] init] ;
    bgview.backgroundColor = nil;

    return  bgview ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgview = [[UIView alloc] init] ;
    bgview.backgroundColor = nil ;
    
    return  bgview ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f ;
}


#pragma mark --
#pragma mark - DetailScrollDelegate
// 加入购物车
- (void)addToShopCarWithGoods:(Goods *)good
{
    if (G_TOKEN == nil || [G_TOKEN isEqualToString:@""])
    {
        // 未登录, 不能看购物车
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return ;
    }

    [[ShopCarGood shareInstance] addToShopCarWithGoods:good AndWithNumber:m_buyNums] ;
}

#pragma mark --
#pragma mark - ShopCarGoodDelegate
- (void)addToShopCarSuccessCallBack
{
    // 加入购物车动画
//    [self addShopCarAnimation] ;

//_bottomShopCar.badgeValue   = [NSString stringWithFormat:@"%d",G_SHOP_CAR_NUM] ;
    
    [self performSelector:@selector(showHudWithStr:) withObject:WD_HUD_ADDCARSUCCESS afterDelay:TIME_ADD_CART] ;
}

- (void)showHudWithStr:(NSString *)hudString
{
    [DigitInformation showWordHudWithTitle:hudString] ;
}

- (void)addShopCarAnimation
{
    /*
    CGRect appfm = [UIScreen mainScreen].bounds ;
    float monkeyHeight = 40.0f ;
    m_imgView_shopCar.frame = CGRectMake(appfm.origin.x - monkeyHeight, appfm.size.height - monkeyHeight * 2, monkeyHeight, monkeyHeight) ;

    CAAnimationGroup *groupAnimate = [TeaAnimation addShopCarAnimation] ;
    groupAnimate.delegate = self ;
    [m_imgView_shopCar.layer addAnimation:groupAnimate forKey:nil] ;
    */
}

//animationDidStop
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    m_imgView_shopCar.frame = CGRectZero ;
    [m_imgView_shopCar.layer removeAllAnimations] ;
    
//    NSLog(@"m_imgView_shopCar.frame : %@",NSStringFromCGRect(m_imgView_shopCar.frame)) ;
}

//
- (void)seeGoodsDescriptionWithHTMLstr:(NSString *)str
{
    [self performSegueWithIdentifier:@"good2webdescrip" sender:str] ;
}

#pragma mark --
#pragma mark - 选择商品分类 颜色
//选择商品分类 颜色
- (void)chooseGoodsCatagoryWithAttr:(NSDictionary *)attr
                       AndWithGoods:(Goods *)good
                     AndWithBuyNums:(int)buyNums
{
//    NSLog(@"chooseGoodsCatagory") ;
    
    UIStoryboard *story             = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChooseViewController *chooseVC  = (ChooseViewController *)[story instantiateViewControllerWithIdentifier:@"ChooseViewController"] ;
    
    if ( (good.attribute.count == 0) || (good.attribute == nil) )
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_BADINFO] ;
        return ;
    }
    
    chooseVC.attr       = ( !_attrDic ) ? good.attr : _attrDic ;
    chooseVC.defaultPic = [good.galleries firstObject] ;
    chooseVC.goods      = good ;
    chooseVC.delegate   = self ;
    chooseVC.m_numBuy   = buyNums ;
    
    [self.navigationController pushViewController:chooseVC animated:YES] ;
}

//立即购买
- (void)buyNowWithGoods:(Goods *)good AndWithBuyNums:(int)buyNums
{
    if ( ! G_TOKEN || [G_TOKEN isEqualToString:@""] )
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return ;
    }

    [[ShopCarGood shareInstance] imidiatelyBuyNowWithGood:good AndWithNums:buyNums] ;
    
}

#pragma mark --
#pragma mark - ShopCarGoodDelegate
- (void)goToCheckOutViewCallBackWithDic:(NSDictionary *)dictionary
{
    [self performSelector:@selector(send2CheckOut:) withObject:dictionary afterDelay:0.6] ;
}


- (void)send2CheckOut:(NSDictionary *)diction
{
    [self performSegueWithIdentifier:@"goodDetail2CheckOut" sender:diction] ;
}


- (void)popToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES] ;
}

//查看更多评论 (商品)
- (void)seeMoreCommentOfGood
{
    NSLog(@"查看更多评论 (商品)")  ;
    
    [self performSegueWithIdentifier:@"gooddetail2goodcomment" sender:m_goods.code] ;
}

//看商品大图
- (void)seeBigImgsWithIndex:(int)index AndWithPicsArray:(NSArray *)picArray
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DealPhotoVideoViewController *detailVC = (DealPhotoVideoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DealPhotoVideoViewController"];
    detailVC.m_imgKeyArray = picArray ;
    detailVC.m_currentImgVideoIndex = index ;
    [self.navigationController pushViewController:detailVC animated:YES] ;
}

//查看商品链接
- (void)seeLinksWithHtmlStr
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyWebController *mywebCtrller = (MyWebController *)[storyboard instantiateViewControllerWithIdentifier:@"MyWebController"];
    mywebCtrller.urlStr = m_goods.official ;
    [self.navigationController pushViewController:mywebCtrller animated:YES] ;
}


//go2你可能喜欢的商品
- (void)goInPushGoodDetail:(Goods *)good
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    GoodsDetailViewController *detailVC = (GoodsDetailViewController *)[story instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"] ;
    detailVC.codeGoods = good.code        ;
    NSString *cate = [[good.category componentsSeparatedByString:@","] firstObject];
    detailVC.category  = cate ;
    
    [self.navigationController pushViewController:detailVC animated:YES] ;
}

//分享商品
- (void)iWantShareThisGood:(Goods *)good    //分享哪一个商品
{
    NSString *imgStr     = [good.galleries firstObject] ;
    NSString *imgPath    = [[SDImageCache sharedImageCache] cachePathForKey:imgStr] ;
    
    NSString *myWords    = [NSString stringWithFormat:@"我看上了%@ 【金箍棒海外购，把世界带回家】",good.title] ;
    
    NSString *myGoodsUrl = [NSString stringWithFormat:@"http://www.jgb.cn/p/%@.html",good.jcode] ;  //http://www.jgb.cn/p/3zzqgpmiym.html
    
    NSString *content    = [NSString stringWithFormat:@"%@%@",myWords,myGoodsUrl] ;
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithPath:imgPath]
                                                title:@"金箍棒海外购"
                                                  url:myGoodsUrl
                                          description:@""
                                            mediaType:SSPublishContentMediaTypeNews];

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];

    
    //自定义新浪微博分享菜单项
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK
                                            shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                            icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                            clickHandler:^{
                                                [ShareSDK shareContent:publishContent
                                                                  type:ShareTypeSinaWeibo
                                                           authOptions:nil
                                                         statusBarTips:YES
                                                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                    
                                                                    if (state == SSPublishContentStateSuccess)
                                                                    {
                                                                        NSLog(@"分享成功");
                                                                    }
                                                                    else if (state == SSPublishContentStateFail)
                                                                    {
                                                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                    }
                                                                }];
                                            }];
    
    //自定义腾讯微博分享菜单项
    id<ISSShareActionSheetItem> tencentItem = [ShareSDK
                                               shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo]
                                               icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                               clickHandler:^{
                                                   [ShareSDK shareContent:publishContent
                                                                     type:ShareTypeTencentWeibo
                                                              authOptions:nil
                                                            statusBarTips:YES
                                                                   result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                       
                                                                       if (state == SSPublishContentStateSuccess)
                                                                       {
                                                                           NSLog(@"分享成功");
                                                                       }
                                                                       else if (state == SSPublishContentStateFail)
                                                                       {
                                                                           NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                       }
                                                                   }];
                                               }];
    
    
    //创建自定义分享列表
    NSArray *shareList = [ShareSDK customShareListWithType:
                          [NSNumber numberWithInteger:ShareTypeWeixiSession],
                          [NSNumber numberWithInteger:ShareTypeWeixiTimeline],
                          sinaItem,
                          tencentItem,
                          [NSNumber numberWithInteger:ShareTypeQQ],
                          [NSNumber numberWithInteger:ShareTypeQQSpace],
                          nil];
    
    //分享接口
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"发表成功");
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog (@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                }
                            }];


}

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    //修改分享编辑框的标题栏颜色
    viewController.navigationController.navigationBar.barTintColor = COLOR_PINK ;
    
    //将分享编辑框的标题栏替换为图片
    //    UIImage *image = [UIImage imageNamed:@"iPhoneNavigationBarBG.png"];
    //    [viewController.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark --
#pragma mark - DetailSubControllerDelegate
 //查看更多评论
- (void)seeMoreCommment
{
    [self seeMoreCommentOfGood] ;
}

#pragma mark -
#pragma mark - ChooseViewControllerDelegate
- (void)alreadyChooseStyle:(NSDictionary *)attrDic AndGood:(Goods *)good AndWithBuyNums:(int)num
{
    _attrDic        = attrDic   ;
    _attr           = _attrDic  ;
    m_goods         = good      ;
    m_buyNums       = num       ;
    _codeGoods      = m_goods.code ;
    
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    dispatch_queue_t queue = dispatch_queue_create("selectNewGoods", NULL) ;
    dispatch_async(queue, ^{
        
        [self reshowGoods] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [YXSpritesLoadingView dismiss] ;
            
            m_bt3.selected = m_alreadyLiked ;   //已经喜欢过
            self.m_firstPrivateTime = YES   ;
            
            [self refreshMainTableAndSubTable] ;
            
            [self reSetPullFrame] ;
            
            NSLog(@"self.subTableViewController : %@",self.subTableViewController) ;
            NSLog(@"self.subTableViewController : %@",NSStringFromCGRect(self.subTableViewController.view.frame)) ;
            NSLog(@"self.view : %@",NSStringFromCGRect(self.view.frame)) ;
            
            //  处理已下架
            [self setupNotOnProducts] ;
            
            //异步核价
            [self setAsyncCheckPrice] ;
        }) ;
        
    }) ;
    
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"detail2Car"])
    {
        ShopCarViewController *shopcarVC = (ShopCarViewController *)[segue destinationViewController] ;
        shopcarVC.isPop = YES  ;
    }
    else if ([segue.identifier isEqualToString:@"goodDetail2CheckOut"])
    {
        CheckOutController *checkOutCtrl = (CheckOutController *)[segue destinationViewController] ;
        checkOutCtrl.resultDiction = (NSDictionary *)sender ;
    }
    else if ([segue.identifier isEqualToString:@"gooddetail2goodcomment"])
    {
        GoodsCommentsController *commentCtrller = (GoodsCommentsController *)[segue destinationViewController] ;
        commentCtrller.productCode = (NSString *)sender ;
    }
    
}


#pragma mark --
#pragma mark - Actions
//加入购物车
- (IBAction)addShopCartAction:(id)sender
{
//    [m_detailSV shopCarPressedAction] ;
    
    NSLog(@"G_TOKEN : %@",G_TOKEN) ;
    
    if ( (! G_TOKEN) || [G_TOKEN isEqualToString:@""] )
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return ;
    }
    
    if (! _attr )
    //  (1)没有选择尺码  //1无尺码 2有尺码
    {
        if (m_goods.attribute)
        {
            BOOL b = [m_goods.attribute isKindOfClass:[NSDictionary class]] && (m_goods.attribute.count) ;
            //  2有尺码 , 进入选择尺码
            if (b)
            {
                [self chooseGoodsCatagoryWithAttr:m_goods.attr AndWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
            }
            // 本商品 正好 没有尺码 ; 直接加入购物车
            else
            {
                [self addToShopCarWithGoods:m_goods] ;
            }
        }
        else
        {
            // 本商品 正好 没有尺码 ; 直接加入购物车
            [self addToShopCarWithGoods:m_goods] ;
        }
        
    }
    else
    //  (2)有选择过尺码, 加入购物车
    {
        [self addToShopCarWithGoods:m_goods] ;
    }
    
}




- (IBAction)buyNowAction:(id)sender
{
//    [m_detailSV buyNowPressedAction] ;
    if ( (! G_TOKEN) || [G_TOKEN isEqualToString:@""] )
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return ;
    }
    
    if (! _attr )
    {
        if (m_goods.attribute)
        {
            BOOL b = [m_goods.attribute isKindOfClass:[NSDictionary class]] && (m_goods.attribute.count) ;
            if (b) {
                //如果有, 如果第一次进入页面,  进入选择尺码,
                [self chooseGoodsCatagoryWithAttr:m_goods.attr AndWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
            }
            else {
                //立即购买
                [self buyNowWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
            }
        }
        else
        {
            //立即购买
            [self buyNowWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
        }
    }
    else
    {
        //立即购买
        [self buyNowWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
    }
}

- (void)enterShopCarAction
{
    [self performSegueWithIdentifier:@"detail2Car" sender:nil]  ;
}

#pragma mark --
#pragma mark - GoodConditionCellDelegate
- (void)addShopCarCallBack
{
    [self addShopCartAction:nil];
}


@end
