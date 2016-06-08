 //
//  ChooseViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ChooseViewController.h"
#import "ServerRequest.h"
#import "ColorChooseCell.h"
#import "WordChooseCell.h"
#import "BuyNumCell.h"
#import "StepTfView.h"
#import "MyMD5.h"
#import "SBJson.h"
#import "YXSpritesLoadingView.h"
#import "KeyBoardTopBar.h"
#import "AttrParsel.h"
#import "UIBarButtonItem+Badge.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "CheckOutController.h"
#import "UIButton+Badges.h"
#import "ShopCarViewController.h"
#import "NavRegisterController.h"
#import "MyWebController.h"

#define STR_ARROWS              @"-->"

#define TAG_ACTION_PICKER       212331

@interface ChooseViewController () <UIPickerViewDataSource,StepTfViewDelegate,ColorChooseCellDelegate,WordChooseCellDelegate,KeyBoardTopBarDelegate,ShopCarGoodDelegate>
{
    NSArray         *m_allKeys      ;   // attribute keys list : color , size , ...
    
    NSArray         *m_linksAllKeys ;   // all keys of links : which color and which size , show all kind of goods
    
    StepTfView      *m_stepView     ;   //
    
    NSDictionary    *m_canShowDic   ;   // attr can be show can be select
    
    KeyBoardTopBar  *m_keyboardbar  ;   //
    
    NSDictionary    *m_newResultDic ;   // can be select goods diction

    UIImageView     *m_imgView_shopCar ;
    
    UIView          *m_viewCantBuy ;
    
}

@property (nonatomic) BOOL isAmazonThirdBuy ;
@property (weak, nonatomic) IBOutlet UIButton *btSizeDescip;

@end

@implementation ChooseViewController

@synthesize m_numBuy ;

#pragma mark --
#pragma mark - 尺码说明
- (IBAction)sizeDesciptionPressedAction:(id)sender
{
    NSLog(@"点击了尺码说明") ;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyWebController *mywebCtrller = (MyWebController *)[storyboard instantiateViewControllerWithIdentifier:@"MyWebController"];
    mywebCtrller.urlStr = _goods.size_url ;
    [self.navigationController pushViewController:mywebCtrller animated:YES] ;
    [mywebCtrller setHidesBottomBarWhenPushed:YES];
}

#pragma mark --
#pragma mark - setter
- (void)setGoods:(Goods *)goods
{
    _goods = goods ;
    
    [self setup] ;
    
    // set 是否亚马逊第三方购买
//    BOOL b = !( (goods.seller_id != -1) && (goods.seller_id != 0) ) ;
    BOOL b = NO ; //
    
    self.isAmazonThirdBuy = b ;
    
    if (!b)
    {
        if (!goods.price || !goods.stock_count)     //  0售价或0库存
        {
            [self bottomTwoButtonsCanPressed:NO] ;
        }
    }
    
    
//是否有尺码
    _btSizeDescip.hidden = ( goods.size_url == nil ) ;
}


- (void)setIsAmazonThirdBuy:(BOOL)isAmazonThirdBuy
{
    _isAmazonThirdBuy = isAmazonThirdBuy ;
    
    NSString *strCantBuy = [NSString stringWithFormat:@"该规格商品来自: %@第三方商家,不支持购买",_goods.seller.name] ;

    if (!m_viewCantBuy)
    {
        m_viewCantBuy = [[UIView alloc] initWithFrame:CGRectMake(0, APPFRAME.size.height - 60, APPFRAME.size.width, 13)] ;
        m_viewCantBuy.backgroundColor = [UIColor whiteColor] ;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(13, 3, 300, 10)] ;
        lb.text = strCantBuy ;
        lb.font = [UIFont systemFontOfSize:10.0f] ;
        lb.textColor = [UIColor lightGrayColor] ;
        [m_viewCantBuy addSubview:lb] ;
        [self.view addSubview:m_viewCantBuy] ;
        [self.view bringSubviewToFront:m_viewCantBuy] ;
    }
    
    // set bottom height
    m_viewCantBuy.hidden = !isAmazonThirdBuy ;
    
    // set bottom two buttons style
    [self bottomTwoButtonsCanPressed:!isAmazonThirdBuy] ;
}

#pragma mark --

// 设置按钮是否能选中
- (void)bottomTwoButtonsCanPressed:(BOOL)canPressd
{
    _bt_shopcar.userInteractionEnabled = canPressd ;
    _bt_buyNow.userInteractionEnabled = canPressd ;
    
    if (canPressd)
    {
        [self setBottomStyle] ;
    }
    else
    {
        [self setButtonBeGray:_bt_shopcar] ;
        [self setButtonBeGray:_bt_buyNow] ;
    }
}

- (void)setButtonBeGray:(UIButton *)bt
{
    UIColor *grayColor = [UIColor darkGrayColor] ;
    
    bt.backgroundColor = grayColor;
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [_bt_buyNow.layer setBorderColor:grayColor.CGColor] ;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder] ;
    if (self) {
        // Custom initialization
    }
    return self ;
}


- (void)setBottomStyle
{
    _bottomView.backgroundColor         = [UIColor whiteColor] ;
    _bt_shopcar.layer.cornerRadius      = CORNER_RADIUS_ALL ;
    _bt_shopcar.backgroundColor         = COLOR_PINK ;
    
    _bt_buyNow.layer.cornerRadius       = CORNER_RADIUS_ALL ;
    _bt_buyNow.backgroundColor          = [UIColor clearColor] ;
    [_bt_buyNow setTitleColor:COLOR_PINK forState:UIControlStateNormal] ;
    [_bt_buyNow.layer setBorderColor:COLOR_PINK.CGColor] ;
    [_bt_buyNow.layer setBorderWidth:1.0f] ;
}


- (void)shopCarImg
{
    m_imgView_shopCar = [[UIImageView alloc] initWithFrame:CGRectZero] ;
    m_imgView_shopCar.image = [UIImage imageNamed:@"APPlogo"] ;
    m_imgView_shopCar.contentMode = UIViewContentModeScaleAspectFit ;
    [self.view addSubview:m_imgView_shopCar] ;
}


- (void)keyBoardToolBar
{
    m_keyboardbar     = [[KeyBoardTopBar alloc] init] ;
    [m_keyboardbar    setAllowShowPreAndNext:NO]      ;
    [m_keyboardbar    setIsInNavigationController:NO] ;
    m_keyboardbar.delegate = self                     ;
    [self.view addSubview:m_keyboardbar.view]         ;
}


- (void)selectedOrNot
{
    if (_attr == nil)
    {
        NSString *str = [m_linksAllKeys firstObject] ;
        NSArray *arr = [str componentsSeparatedByString:STR_ARROWS] ;
        NSMutableDictionary *showDic = [NSMutableDictionary dictionary] ;
        for (NSString *tempStr in arr)
        {
            NSArray *dicArr = [tempStr componentsSeparatedByString:@"|"] ;
            [showDic setObject:[dicArr lastObject] forKey:dicArr[0]] ;
        }
        NSLog(@"showDic : %@",showDic) ;
        _attr = showDic ;
    }
    else
    {
        [self changeToAlreadySelectStylesWithDic:_attr] ;
        [self showPriceAndStockWithGood:_goods] ;
    }
    
}

- (void)setMyViews
{
    _headView.backgroundColor = [UIColor whiteColor] ;
    [self.view sendSubviewToBack:_headView] ;
    
    float wid = 8.0f ;
    UIColor *sepColor = [UIColor lightGrayColor] ;
    
    //
    [_imgGood setImageWithURL:[NSURL URLWithString:_defaultPic] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(_imgGood.frame.size.width*2, _imgGood.frame.size.height*2)] ;
    _imgGood.contentMode = UIViewContentModeScaleAspectFit ;
    
    //
    _lb_actualPrice.textColor = COLOR_PINK ;
    _lb_stockNum.textColor    = [UIColor darkGrayColor] ;
    _lb_selectGoodInfomation.textColor = [UIColor darkGrayColor] ;
    //
    NSString *str = @"" ;
    int index = 0 ;
    for (NSString *key in m_allKeys) {
        if (index == m_allKeys.count - 1) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",key]]    ;
        }else {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@ | ",key]]    ;
        }
        index ++ ;
    }
    
    //
    _lb_selectGoodInfomation.text = [NSString stringWithFormat:@"请选择：%@",str]        ;
    _lb_stockNum.text             = [NSString stringWithFormat:@"库存%d件",_goods.stock_count] ;
    _lb_actualPrice.text          = [NSString stringWithFormat:@"￥%.2f",_goods.rmb_price] ;
    
    //
    _table.backgroundColor  = [UIColor whiteColor] ;
    _table.separatorStyle   = UITableViewCellSeparatorStyleSingleLine ;
    //_table.separatorColor   = sepColor ;
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsMake(0, wid, 0, wid)];
    }
    
    
    //
    UIView *baseLine = [[UIView alloc] initWithFrame:CGRectMake(wid, _headView.frame.size.height + 64.0f, APPFRAME.size.width - 2*wid, 1)] ;
    baseLine.backgroundColor = sepColor ;
    [self.view addSubview:baseLine] ;
    
}


- (void)setup
{
    NSLog(@"_goods : %@",_goods) ;
    
    if ( (_goods.attribute == nil) || (_goods.attribute.count == 0) )
    {
        m_allKeys   = @[] ;
    }
    else
    {
        m_allKeys   = [_goods.attribute allKeys]    ;
    }
    
    if (_goods.links != nil)
    {
        if ([_goods.links count]) {
            m_linksAllKeys  = [_goods.links allKeys]        ;
        }
    }
    m_canShowDic    = [NSDictionary dictionary]     ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//  Initial
    [self setup] ;
    
    if (!m_numBuy) m_numBuy = 1 ;
    
//  Key board tool bar
    [self keyBoardToolBar]  ;
    
//  Set My Views
    [self setMyViews]       ;
    
//  Selected Or Not
    [self selectedOrNot]    ;
    
//  go 2 shop car img
    [self shopCarImg]       ;
    
//  set Bottom Style
    [self setBottomStyle]   ;

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    self.navigationController.navigationBar.translucent = YES ;
    [ShopCarGood shareInstance].delegate = self ;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numKeyBoardShow:) name:NOTIFICATION_SHOW_NUM_KEY_BOARD object:nil] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
//    self.navigationController.navigationBar.translucent = NO ;
    [ShopCarGood shareInstance].delegate = nil ;

    [self.delegate alreadyChooseStyle:_attr AndGood:_goods AndWithBuyNums:m_numBuy] ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_SHOW_NUM_KEY_BOARD object:nil] ;
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
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [m_allKeys count] + 1 ;
}

#define WORD_CELL_HEIGHT            40

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == m_allKeys.count)
    {
        //数量
        static NSString *CellIdentfier = @"BuyNumCell";
        BuyNumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier] ;
        if (cell == nil) {
            cell = [[BuyNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.viewRight.backgroundColor = [UIColor whiteColor] ;
        
        if (m_stepView == nil) {
            m_stepView = (StepTfView *)[[[NSBundle mainBundle] loadNibNamed:@"StepTfView" owner:self options:nil] lastObject] ;
        }
        
        if (!m_numBuy && _goods.stock_count) {
            m_numBuy = 1 ;
        }
        
        m_stepView.num      = m_numBuy ;
        m_stepView.maxNum   = _goods.stock_count ;  //库存 ;
        m_stepView.delegate = self ;
        if (!cell.viewRight.subviews.count)
        {
            [cell.viewRight addSubview:m_stepView]    ;
        }
        
        return cell ;
    }
    else
    {
        NSString *key       = (NSString *)m_allKeys[indexPath.row]  ;
        NSArray  *tempList  = [_goods.attribute objectForKey:key]   ;
        NSMutableArray *valueList = [NSMutableArray array] ;
        if (![tempList[0] isKindOfClass:[NSArray class]])
        {
            for (NSString *strT in tempList)
            {
                if ([strT isEqualToString:@""]) continue ;
                [valueList addObject:strT] ;
            }
        }
        else
        {
            valueList = tempList ;
        }
        
        
        if ([valueList[0] isKindOfClass:[NSArray class]])
        {
            //图片
            static NSString *CellIdentfier = @"ColorChooseCell";
            ColorChooseCell *cell = (ColorChooseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
            if (cell == nil) {
                cell = [[ColorChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
            }
            cell.lb_title.text  = key               ;
            cell.valueArr       = valueList         ;
            cell.selectionStyle = 0                 ;
            cell.canSelectDic   = m_newResultDic    ;
            cell.delegate       = self              ;
            
            if (_attr == nil)
            {
                return cell ;
            }
            else
            {
                if (valueList.count == 1)
                {
                    cell.currentIndex =  0 ;
                }
                else
                {
                    NSString *theVal = @"" ;
                    for (NSString *akey in _attr) {
                        if ([akey isEqualToString:key]) {
                            theVal = [_attr objectForKey:key];
                        }
                    }
                    int mycurrentIndex = 0 ;
                    int index = 0 ;
                    for (NSArray *valarr in valueList)
                    {
                        if ([valarr isKindOfClass:[NSArray class]]) {
                            if ([[valarr firstObject] isEqualToString:theVal]) {
                                mycurrentIndex = index ;
                            }
                            index ++ ;
                        }
                    }
                    
                    cell.currentIndex =  mycurrentIndex;
                }
                
                [cell.colorCollection reloadData] ;
               
                return cell ;
            }
        }
        else
        {
            //文字
            static NSString *CellIdentfier = @"WordChooseCell";
            WordChooseCell *cell = (WordChooseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
            if (cell == nil) {
                cell = [[WordChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
            }
            cell.lb_title.text = key  ;
            cell.valueArr = valueList ;
            cell.selectionStyle = 0 ;
            cell.canSelectDic = m_newResultDic ;
            cell.delegate = self ;
            
            if (_attr == nil)
            {
                return cell ;
            }
            else
            {
                if (valueList.count == 1)
                {
                    cell.currentIndex = 0 ;
                }
                else
                {
                    NSString *theVal = @"";
                    for (NSString *akey in _attr) {
                        if ([akey isEqualToString:key]) {
                            theVal = [_attr objectForKey:key];
                        }
                    }
                    int mycurrentIndex = 0 ;
                    int index = 0;
                    for (NSString *val in valueList) {
                        if ([val isEqualToString:theVal]) {
                            mycurrentIndex = index ;
                        }
                        index ++ ;
                    }
                    
                    cell.currentIndex = mycurrentIndex  ;
                }
                [cell.WordCollectionView reloadData]    ;
                
                return cell ;
            }            
        }
    }
    
    return nil ;
}


#define COLLECTION_HEIGHT       50
#define LINE_NUM                5
#define FLEX                    10
#define HEIGHT_BUY_NUM_CELL     93.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == m_allKeys.count)
    {
        return HEIGHT_BUY_NUM_CELL ; 
    }
    else
    {
        NSString *key = (NSString *)m_allKeys[indexPath.row] ;
        
        NSArray *diction = [_goods.attribute objectForKey:key] ;
        
        NSArray  *valueList = diction ;     //[diction allValues] ;
        if ([valueList[0] isKindOfClass:[NSArray class]])
        {
            //images
            int num  = [valueList count];   // not * 11
            int line = (!(num % LINE_NUM)) ? (num / LINE_NUM) : (num / LINE_NUM + 1);
            float h  = 101 - COLLECTION_HEIGHT + line * (COLLECTION_HEIGHT + FLEX) - FLEX ;
            
            return h;
        }
        else
        {
            //words
            int   lineNum   = 0         ;
            float tempLine  = 0.0       ;
            for (int i = 0; i < valueList.count; i++)
            {
                NSString *wordName = valueList[i]   ;
                UIFont *font = [UIFont systemFontOfSize:WORD_LABEL_FONT] ;
                CGSize size = CGSizeMake(294,21)    ;
                
                if (wordName)
                {
                    CGSize labelsize = [wordName sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap]        ;
                    
                    float widTemp = labelsize.width + 25 - 10 ;
                    tempLine += (widTemp + 10);
                    if (tempLine - 10 > 294)
                    {
                        lineNum ++ ;
                        tempLine = widTemp + 10;
                    }
                    if ((i == valueList.count - 1)&&(tempLine > 0))
                    {
                        lineNum ++ ;
                    }
                }
                
            }
            
            NSLog(@"%d line",lineNum) ;
            
            return  94 - 41 + lineNum * (41 + 10) - 10 ;//WORD_CELL_HEIGHT ;
        }
    }
    
    return 0 ;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getEmptyView] ;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self getEmptyView] ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f ;
}


- (UIView *)getEmptyView
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = nil ;
    return back ;
}

#pragma mark --
#pragma mark - Collection
#pragma mark - ColorChooseCellDelegate
#pragma mark - WordChooseCellDelegate
- (void)sendKey:(NSString *)key AndSendValue:(NSString *)value
{
    NSMutableDictionary *mySelDic = [NSMutableDictionary dictionaryWithDictionary:_attr];
    for (NSString *akey in mySelDic.allKeys)
    {
        if ([akey isEqualToString:key]) {
            [mySelDic setObject:value forKey:akey] ;
        }
    }
    
    [self selectStyleAutoMatch:mySelDic AndWithKey:key] ;
}

#pragma mark --
#pragma mark - select style and auto match
- (void)selectStyleAutoMatch:(NSDictionary *)newAttr AndWithKey:(NSString *)key
{
    NSString        *linkTest = [m_linksAllKeys firstObject]     ;
    //size_name|X-Large-->color_name|Heather Grey,B00EI53VMM
    if ([linkTest isEqualToString:@""] && m_linksAllKeys.count > 1) {
        linkTest = m_linksAllKeys[1] ;
    }
    NSArray         *tempArr  = [linkTest componentsSeparatedByString:STR_ARROWS] ;    //[size_name|X-Large,color_name|Heather Grey]
    NSMutableArray  *sequence = [NSMutableArray array];
    for (NSString *str in tempArr)
    {
        NSString *newStr = (NSString *)[[str componentsSeparatedByString:@"|"] firstObject] ;
        [sequence addObject:newStr]     ;
    }
    
//    NSLog(@"seq%@",sequence)          ;      //[sizename, colorname]
    
    NSString *myAttrStr = @""           ;
    NSString *arrows    = STR_ARROWS    ;
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary] ;

    for (NSString *akey in [newAttr allKeys])
    {
        for (int i = 0 ; i < sequence.count ; i++)
        {
            NSString *theKey = sequence[i] ;
            
            NSString *numKey = [NSString stringWithFormat:@"%d",i] ;
            
            if ([akey isEqualToString:theKey]) {
                if (i == 0) {   // a | 1.0
                    NSString *firstStr  = @""           ;
                    firstStr  = [NSString stringWithFormat:@"%@|%@",akey,[newAttr objectForKey:akey]] ;
                    [tempDic setObject:firstStr forKey:numKey] ;
                }else {         //-->a | 1.0-->b | 2.0
                    NSString *lastStr   = @""           ;
                    lastStr = [lastStr stringByAppendingString:[NSString stringWithFormat:@"%@%@|%@",arrows,akey,[newAttr objectForKey:akey]]];
                    [tempDic setObject:lastStr forKey:numKey] ;
                }
            }
        }
    }
    

    for (int i = 0; i < tempDic.count; i++)
    {
        for (NSString *numKey in [tempDic allKeys])
        {
            int numberTemp = [numKey intValue] ;
            
            if (numberTemp == i)
            {
                
                myAttrStr = [myAttrStr stringByAppendingString:[tempDic objectForKey:numKey]] ;
            }
        }
    }
    
//    myAttrStr = [NSString stringWithFormat:@"%@%@",firstStr,lastStr] ;
    
    NSLog(@"myAttrStr : %@",myAttrStr) ;
    
    BOOL hasOrNot = NO;
    for (NSString *alink in m_linksAllKeys) {
        if ([alink isEqualToString:myAttrStr])
        {
            hasOrNot = YES ;
            break ;
        }
    }
    
    if ( hasOrNot )
    {
        // show
        [self showSelectAttrWithLink:myAttrStr] ;
    }
    else
    {
        // reselect and show
        NSString *val = [newAttr objectForKey:key] ;
        for (NSString *alink in m_linksAllKeys)
        {
            //  判断是否有当前key对应value的links
            NSArray *arrayLinkOne = [alink componentsSeparatedByString:STR_ARROWS] ;
            for (NSString *str_1 in arrayLinkOne)
            {
                if ([str_1 hasPrefix:key])
                {
                    NSString *suffixStr = [[str_1 componentsSeparatedByString:@"|"] lastObject] ;
                    if ([suffixStr isEqualToString:val])
                    {
                        //show
                        [self showSelectAttrWithLink:alink] ;
                        break ;
                    }
                }
            }
        }
    }
}

//  show
- (void)showSelectAttrWithLink:(NSString *)linkStr
{
    if ([linkStr isEqualToString:@""]) {
        return ;
    }
    
// 1 . select box
    //  size_name|Small-->color_name|White
    NSArray *arr = [linkStr componentsSeparatedByString:STR_ARROWS] ;

    
    NSMutableDictionary *showDic = [NSMutableDictionary dictionary] ;
    for (NSString *tempStr in arr)
    {
        NSArray *dicArr = [tempStr componentsSeparatedByString:@"|"] ;
        [showDic setObject:[dicArr lastObject] forKey:dicArr[0]] ;
    }
    NSLog(@"showDic : %@",showDic)  ;
    _attr = showDic  ;

//1.5. *******  can select set alpha 0.5   ******* //
    m_newResultDic = [self showCanNotSelectGoods]    ;
    
    [self.table reloadData] ;

//2 . show new imgs
    [self showNewImgs] ;
    
//3 . server get new goods .. show new price ,
    __block NSDictionary *dic ;
    dispatch_queue_t queue = dispatch_queue_create("changeStyle", NULL) ;
    dispatch_async(queue, ^{
        
        NSString *newgoodCode = [_goods.links objectForKey:linkStr] ;
        NSString *response    = [ServerRequest getGoodsDetailWithGoodsCode:newgoodCode] ;
        // Parsel
        SBJsonParser *parser = [[SBJsonParser alloc] init] ;
        dic = [parser objectWithString:response] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            int code = [[dic objectForKey:@"code"] intValue] ;
            if (code == 200)
            {
                //  success
                NSDictionary *data = [dic objectForKey:@"data"]     ;
                Goods *goodNew = [[Goods alloc] initWithDic:data]   ;   //  可能出现links为空, attributes为空
                self.goods = goodNew                                ;
                
                [self showPriceAndStockWithGood:_goods]             ;
            }
            else
            {
                //  fail
                if (![[dic objectForKey:@"info"] isKindOfClass:[NSNull class]])
                {
                    NSLog(@"WD_HUD_BADNETWORK 找不到网络 : %@",[dic objectForKey:@"info"]) ;
                }
                
                [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK]   ;
            }
            
            [self.table reloadData] ;

        }) ;
        
    }) ;
    
    
//4 . change to already select styles .
    [self changeToAlreadySelectStylesWithDic:showDic]           ;
}


#pragma mark --
#pragma mark - show New Imgs
- (void)showNewImgs
{
    for (NSString *key in m_allKeys)
    {
        NSArray *valueList = [_goods.attribute objectForKey:key] ;

        if (![valueList respondsToSelector:@selector(firstObject)] ) {
            continue ;
        }
        if ([[_goods.attribute objectForKey:key] isKindOfClass:[NSString class]])
        {
            continue ;
        }
        
        if ([[valueList firstObject] isKindOfClass:[NSArray class]])
        {    //.pic
            for (NSArray *valList in valueList)
            {
                if ([valList isKindOfClass:[NSString class]]) {
                    continue ;
                }
                
                if ( [[valList firstObject] isEqualToString:[_attr objectForKey:key]] )
                {
                    [_imgGood setImageWithURL:[NSURL URLWithString:[valList lastObject]] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(_imgGood.frame.size.width*2, _imgGood.frame.size.height*2)] ;
                    break ;
                }
            }
        }
    }
}

#pragma mark --
#pragma mark - Show Can Not SelectGoods - Transparent
- (NSDictionary *)showCanNotSelectGoods
{
    // 我已经选择的 attr 遍历拿到 每个 key
    // 所有key对应的属性list 在 attribute
    // 所有的attr key , 分别拿到 在 当前key下的区show list "一个key对应一个notShowList " !
//    size_name|10 B(M) US-->color_name|Black/Cuoio
    // 根据已选择的attr key val ,去links , get CAN SELECT link list, 得出可以选择的其他属性list, 这个其他属性可能是多个
    // e.g. color|black -> link find ; size|a, size|b, can select -> size : [a,b]
    
    //1 . parsel links to diction
    NSMutableArray *linksAllKeys = [NSMutableArray array]            ;
    for (NSString *strTemp in m_linksAllKeys)
    {
        AttrParsel   *parsel    = [[AttrParsel alloc] init]          ;
        NSDictionary *alink     = [parsel changeLinkToJson:strTemp]  ;
        
        [linksAllKeys addObject:alink]                               ;
    }
    
//    NSLog(@"linksAllKeys : %@",linksAllKeys) ;
    
    NSMutableDictionary *newResultDic = [NSMutableDictionary dictionary] ;    //get dic e.g size1:(a,a) ,style(b,b)

    for (NSString *myKey in m_allKeys)
    {
        NSLog(@" key : %@",myKey)                    ;      //我当前key
        NSString *myVal = [_attr objectForKey:myKey] ;      //我当前val
        if (!myVal) {
            continue ;
        }
        
        NSMutableArray *anotherKey = [NSMutableArray array] ;//其他key
        for (NSString *key in m_allKeys)
        {
            if (![key isEqualToString:myKey])
            {
                [anotherKey addObject:key] ;
            }
        }
        //  get from other key ,  which can be select
        for (NSString *otherKey in anotherKey)
        {
            NSMutableArray *array = [NSMutableArray array] ;

            for (NSDictionary *linkDic in linksAllKeys)
            {
               NSString *valTemp = [linkDic objectForKey:myKey] ;
               if ([valTemp isEqualToString:myVal])
               {
                   // CAN SELECT //
                   // get dic e.g size1:(a,a) ,style(b,b)
                   NSString *str_For_Other_Key = [linkDic objectForKey:otherKey];
                   if (!str_For_Other_Key) {
                       continue ;
                   }
                   [array addObject:str_For_Other_Key] ;
               }
            }

            [newResultDic setObject:array forKey:otherKey] ;
        }
    }
    
    return newResultDic ;
}

#pragma mark --
#pragma mark -- showPriceAndStockWithGood
- (void)showPriceAndStockWithGood:(Goods *)good
{
    
    if (good.category == nil)
    {
        //only see
        _lb_actualPrice.text    = @"价格暂无"  ;
    }
    else
    {
        // can buy
        _lb_actualPrice.text    = [NSString stringWithFormat:@"￥%.2f",good.rmb_price]    ;
    }
    
    _lb_stockNum.text       = [NSString stringWithFormat:@"库存%d件",good.stock_count]     ;
    
    
    BuyNumCell *cell = (BuyNumCell *)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:m_allKeys.count inSection:0]] ;
    
    if (!m_allKeys.count) return ;
    
    for (UIView *sub in cell.viewRight.subviews) {
        if ([sub isKindOfClass:[StepTfView class]]) {
            StepTfView *stepV = (StepTfView *)sub   ;
            stepV.maxNum = good.stock_count         ;
            if (stepV.num > good.stock_count) [self refreshTableWithNum:good.stock_count AndWithSection:0 AndWithRow:0] ;
        }
    }
    
}

#pragma mark --
#pragma mark -- changeToAlreadySelectStylesWithDic
- (void)changeToAlreadySelectStylesWithDic:(NSDictionary *)attri
{
    NSString *showStr = @"" ;
    int index = 0 ;
    for (NSString *string in [attri allValues])
    {
        NSString *tem = @"" ;
        if (index == attri.count - 1)
        {
            tem = [NSString stringWithFormat:@" \"%@\"",string] ;
        }
        else
        {
            tem = [NSString stringWithFormat:@" \"%@\" |",string] ;
        }
        showStr = [showStr stringByAppendingString:tem] ;
        
        index ++ ;
    }
    
    _lb_selectGoodInfomation.text = [NSString stringWithFormat:@"您选择: %@",showStr] ;
}

#pragma mark --
#pragma mark -  StepTfViewDelegate
- (void)refreshTableWithNum:(int)numbuy AndWithSection:(int)section AndWithRow:(int)row
{
    m_numBuy = numbuy ;
    [self.table reloadData] ;
}

#pragma mark --
#pragma mark - NSNotificationCenter
- (void)numKeyBoardShow:(NSNotification *)notification
{
// move cell up to see
    float upOffset = 0.0f ;

    for (int i = 0; i < [m_allKeys count] ; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0] ;
        float tempH = [self tableView:_table heightForRowAtIndexPath:indexPath] ;
        upOffset += tempH ;
    }
    
//    CGPoint tempP = _table.contentOffset ;
//    tempP.y = upOffset ;
//    _table.contentOffset = tempP ;

// show key board tool bar
    UITextField *tf = (UITextField *)notification.object ;
    [m_keyboardbar showBar:tf] ;
    
//    if (!DEVICE_IS_IPHONE5)
//    {
//        [UIView beginAnimations:@"upTableAnimation" context:nil];
//        [UIView setAnimationDuration:0.3f];
//        self.table.frame = CGRectMake(0, self.table.frame.origin.y - _headView.frame.size.height , self.table.frame.size.width, self.table.frame.size.height);
//        [UIView commitAnimations];
//    }
    
}

#pragma mark --
#pragma mark - KeyBoardTopBarDelegate <NSObject>
- (void)shutDownKeyBoard
{

    CGPoint tempP = _table.contentOffset ;
    tempP.y = 0 ;
    _table.contentOffset = tempP ;
    
//    if (!DEVICE_IS_IPHONE5)
//    {
//        [UIView beginAnimations:@"upTableAnimation" context:nil];
//        [UIView setAnimationDuration:0.3f];
//        self.table.frame = CGRectMake(0, _headView.frame.size.height, self.table.frame.size.width, self.table.frame.size.height);
//        [UIView commitAnimations];
//    }
    
}



#pragma mark --
#pragma mark - 立即购买 加入购物车
//立即购买
- (IBAction)buyNowAction:(id)sender
{
    if ( (! G_TOKEN) || [G_TOKEN isEqualToString:@""] )
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return ;
    }
    
    [[ShopCarGood shareInstance] imidiatelyBuyNowWithGood:_goods AndWithNums:m_numBuy] ;
}

#pragma mark --
#pragma mark - ShopCarGoodDelegate
- (void)goToCheckOutViewCallBackWithDic:(NSDictionary *)dictionary
{
    [self performSelector:@selector(send2CheckOut:) withObject:dictionary afterDelay:0.6] ;
}


- (void)send2CheckOut:(NSDictionary *)diction
{
    [self performSegueWithIdentifier:@"choose2CheckOut" sender:diction] ;
}

//- (void)popToRoot
//{
//    [self.navigationController popToRootViewControllerAnimated:YES] ;
//}


//加入购物车
- (IBAction)go2shopCar:(id)sender
{
    if ( (! G_TOKEN) || [G_TOKEN isEqualToString:@""] )
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return ;
    }
    
    [[ShopCarGood shareInstance] addToShopCarWithGoods:_goods AndWithNumber:m_numBuy] ;
    
}
#pragma mark --
#pragma mark - ShopCarGoodDelegate
- (void)addToShopCarSuccessCallBack
{
    // 加入购物车动画
//    [self addShopCarAnimation] ;
    
    //_bt_openShopCar.badgeValue = [NSString stringWithFormat:@"%d",G_SHOP_CAR_COUNT] ;
    
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

#pragma mark --
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [m_imgView_shopCar.layer removeAllAnimations] ;
    m_imgView_shopCar.frame = CGRectZero ;
//    NSLog(@"m_imgView_shopCar.frame : %@",NSStringFromCGRect(m_imgView_shopCar.frame)) ;
}

- (IBAction)openShopCarAction:(id)sender
{
    [self openShopCar] ;
}


#pragma mark --
- (void)backToLastVC
{
    [self.navigationController popViewControllerAnimated:YES]       ;
}

- (void)openShopCar
{
    [self performSegueWithIdentifier:@"style2shopcar" sender:nil]   ;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"choose2CheckOut"])
    {
        CheckOutController *checkOutCtrl = (CheckOutController *)[segue destinationViewController] ;
        checkOutCtrl.resultDiction = (NSDictionary *)sender ;
    }
    else if ([segue.identifier isEqualToString:@"style2shopcar"])
    {
        ShopCarViewController *shopcarVC = (ShopCarViewController *)[segue destinationViewController] ;
        shopcarVC.isPop = YES ;
    }
    
}


@end
