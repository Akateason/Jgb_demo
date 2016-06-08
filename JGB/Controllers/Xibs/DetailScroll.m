//
//  DetailScroll.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "DetailScroll.h"
#import "goodsProperty.h"
#import "DigitInformation.h"
#import "CommentCell.h"
#import "MayLikeCollectionCell.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "ServerRequest.h"
#import "YXSpritesLoadingView.h"
#import "MyTick.h"
#import "TeaCornerView.h"

#define TABLEHEADHEIGHT     40


@implementation DetailScroll
{
    BOOL            m_firstTime         ;
    NSArray         *_pushGoodsArray    ;
    BOOL            m_bKeepCheck        ;
    
    ImagePlayerView *m_ipView           ;
}

@synthesize lb_getPrice,lb_orgPrice,lb_saveMoney,lb_howLong_arrive,lb_exchangeRate,lb_daoshoujia,m_goods,m_buyNums;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //  Initialization code
        m_buyNums   = 1         ;         //至少买一件
        m_firstTime = YES       ;
        //  set my view Height
        float newTableH = [self getTableHeight]     ;           //?????????
        float myHeight = 1705.0 - 732.0 + newTableH + 5 - 44 ;  //732 old table height
        CGRect myframe = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, myHeight) ;
        self.frame = myframe                        ;
       
        
        //  notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeCheckPrice) name:NOTIFICATION_GOODDETAIL_DISMISS object:nil] ;
    }
    
    return self;
}

- (void)awakeFromNib
{
    _table_shopInfoAndComment.dataSource = self     ;
    _table_shopInfoAndComment.delegate   = self     ;

    if(![DigitInformation isConnectionAvailable])
    {
        [self.delegate nothingPicShow] ;
    }
        
}

- (void)layoutSubviews
{
//  tableview constraint
    
    _constraint_tableHeight.constant = [self getTableHeight] ;
    
    [super layoutSubviews];
    
    if (m_firstTime)
    {
        m_firstTime = NO ;

        
        __block BOOL hasGoods = NO ;
        
        [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO]               ;
        [DigitInformation showHudWhileExecutingBlock:^{
             hasGoods = [self getParseledGoodDetail]    ;
        } AndComplete:^{
            
            [YXSpritesLoadingView dismiss]  ;
            
            if (! hasGoods)
            {
                [self.delegate nothingPicShow] ;

                return ;
            }
            else
            {
                [self setMyViews]               ;
                
                [_table_shopInfoAndComment  reloadData]     ;
                [_collectionView_goods      reloadData]     ;
                if ( [m_goods.code isEqualToString:@""] || (m_goods.code == nil) )
                {
                    m_firstTime = YES ;
                }
                
                // 异步核价
                if (m_goods.seller_id != 1000)
                {
                    [self asyncCheckPrice] ;
                }
                else
                {
                    _activity_checkPrice.hidden = YES ;
                    [_activity_checkPrice removeFromSuperview] ;
                    _lb_checkingPrice.hidden = YES ;
                }
            }
            
        } AndWithMinSec:FLOAT_HUD_MINSHOW]  ;
        
    }
    
}


#pragma mark -- async check price
- (void)asyncCheckPrice
{
    
    dispatch_queue_t queue = dispatch_queue_create("checkpriceQueue", NULL) ;
    dispatch_async(queue, ^{
        
        NSArray *pidList = @[m_goods.code] ;
        m_bKeepCheck     = YES ;
        
        __block CheckPrice *checkPrice ;
        while (m_bKeepCheck)
        {
            m_bKeepCheck =  NO ;
            
            NSArray *checkList = [ServerRequest checkPriceWithList:pidList] ;
            checkPrice  = [[CheckPrice alloc] initWithDic:[checkList lastObject]] ;
            
            if (checkPrice.buyStatus == NO)
            {
                m_bKeepCheck  = YES ;
            }
            
            long long tickNow = [MyTick getTickWithDate:[NSDate date]] ;
            long long deta = tickNow - checkPrice.ts;
            if ( deta > G_AUTHORIZATION_TIME )
            {
                m_bKeepCheck  = YES ;
            }
            
            sleep(1.5) ;
        }
        
        m_goods.actual_price = checkPrice.actual_price ;
        m_goods.stock_count  = checkPrice.stock ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            lb_getPrice.text     = [NSString stringWithFormat:@"￥%.2f",m_goods.actual_price];
            _lb_bottomPrice.text = [NSString stringWithFormat:@"￥%.2f",m_goods.actual_price]     ;
            
            _activity_checkPrice.hidden = YES ;
            _lb_checkingPrice.hidden    = YES ;
            [_activity_checkPrice removeFromSuperview] ;
        }) ;
    }) ;
}


#pragma mark -- views
//1 get json info - good detail
- (BOOL)getParseledGoodDetail
{
    //1.1   good detail
    NSString *response = [ServerRequest getGoodsDetailWithGoodsCode:_code] ;
    //1.2get m_good
    BOOL b = [self parselWithResult:response] ;   //get m_good
    if (!b) return b ;
    
    //1.3   set push goods list
    [self setPushGoodList] ;
    
    return  b ;
}

- (void)setPushGoodList
{
    NSString *cate = [([m_goods.category componentsSeparatedByString:@","]) objectAtIndex:0] ;//1级分类
    
    CurrentSort *currentSort = [[CurrentSort alloc] initWithPage:1 AndWithSize:6 AndWithSellerID:nil AndWithTitle:nil AndWithBrand:nil AndWithCategory:cate AndWithLowPrice:-1 AndWithHighPrice:-1 AndWithOrderVal:-1 AndWithOrderWay:-1 AndWithCN:-1 AndWithCX:-1] ;
    NSString *pushResult = [ServerRequest getGoodsListWithCurrentSort:currentSort] ;
    _pushGoodsArray = [NSArray array] ;
    _pushGoodsArray = [self parserResponse:pushResult] ;
}

//
- (NSArray *)parserResponse:(NSString *)response
{
    NSMutableArray *pushGoodList = [NSMutableArray array] ;
    
    SBJsonParser *parser = [[SBJsonParser alloc] init] ;
    NSDictionary *diction = [parser objectWithString:response] ;
    int code = [[diction objectForKey:@"code"] intValue];
    if (code == 200) {
        NSDictionary *dataDic = [diction objectForKey:@"data"] ;
        NSString *total = [dataDic objectForKey:@"total"] ;
        if ( ( !total ) || [total isKindOfClass:[NSNull class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DigitInformation showHudWithTitle:WD_HUD_BADNETWORK];
            }) ;
            NSLog(@"没有这个类目");
            return pushGoodList;
        }
        else if ( ![total intValue] )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DigitInformation showHudWithTitle:WD_HUD_NOTING];
            }) ;
            NSLog(@"没有此商品");
            return pushGoodList;
        }
        else
        {
            //  success
            NSDictionary *list = (NSDictionary *)[dataDic objectForKey:@"list"] ;
            if ( (list == nil)||(list == NULL)||([list isKindOfClass:[NSNull class]]) ) {
                return pushGoodList;
            }
            //1 good lists
            for (NSString *keyStr in list)
            {
                NSDictionary *goodDic = [list objectForKey:keyStr] ;
                Goods *goodTemp = [[Goods alloc] initWithDic:goodDic] ;
                [pushGoodList addObject:goodTemp] ;
            }
            
            return pushGoodList ;
        }
    }else{
        return pushGoodList;
    }
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
        [self.delegate nothingPicHide] ;
        
        return YES ;
    }
    else
    {
        //fail
        [DigitInformation showHudWithTitle:WD_HUD_NOTING] ;
        [self.delegate nothingPicShow] ;
        
        return NO ;
    }
}

- (void)setMyViews
{
    
    //1     goods photo scroll
    [self showGoodsPhotoScroll] ;
    //2     goods photo bar
    [self showGoodsPhotoBar];
    //3     prepare view
    [self showPrepareView];
    
    //4
    _table_shopInfoAndComment.scrollEnabled = NO ;
    _collectionView_goods.dataSource    = self;
    _collectionView_goods.delegate      = self;
    _collectionView_goods.scrollEnabled = NO ;
    
    //5
    _bottomBarView.backgroundColor = [UIColor whiteColor];
    NSURL *urlTemp = [NSURL URLWithString:[m_goods.galleries objectAtIndex:0]];
    [_bottom_img setImageWithURL:urlTemp placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(40, 40)];
    
    _lb_bottomPrice.textColor   = COLOR_PINK          ;
    _lb_bottomPrice.text        = [NSString stringWithFormat:@"￥%.2f",m_goods.actual_price]     ;
    
    _lb_bottomSave.textColor    = COLOR_WD_GRAY       ;
    _lb_bottomSave.text         = [NSString stringWithFormat:@"立省%.2f",m_goods.discount_price ];

    
    //check price UI
    _activity_checkPrice.color = COLOR_PINK ;
}



- (float)getTableHeight
{
//  good info description

    float h1 = 0 ;
    
//  comment
    NSString *commentStr = @"这速度够快呀，一天就到了，还不错没有暗角，我的是尼康套头。但是图像边缘有点模糊不过对于我们玩玩的人就不说什么了，不到200性价比不错";
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(295,200);
    CGSize labelsize = [commentStr sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    float h2 =  112.0 - 15.0 + labelsize.height ;
    
    int i = 4 ;

    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) ) i = 3 ;
    
    float h = 40 * i + h1 + h2 * 3 ;
    
    return h ;
}


//1 goods photo scroll
- (void)showGoodsPhotoScroll
{
    if (! m_ipView)
    {
        m_ipView = [[ImagePlayerView alloc] initWithFrame:_goodsPhotoScroll.frame];
        m_ipView.scrollInterval = 5.0f;
        m_ipView.hidePageControl = YES;
        [_goodsPhotoScroll insertSubview:m_ipView atIndex:0];
        [_goodsPhotoScroll setBackgroundColor:[UIColor whiteColor]];
    }
    
    int num = m_goods.galleries.count ;
    [m_ipView initWithCount:num delegate:self];
}


//1.5 goods photo bar
- (void)showGoodsPhotoBar
{
    _goodsBar.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.65];
    NSString *features = @"" ;
    if ([m_goods.feature isKindOfClass:[NSString class]]) {
        NSLog(@"str");
        features = @"";
    } else {
        for (NSString *str1 in m_goods.feature) {
            features = [features stringByAppendingString:[NSString stringWithFormat:@",%@",str1]];
        }
    }

    NSString *str = [m_goods.title stringByAppendingString:features] ;
    _lb_goodsTitle.text = str;
    _lb_goodsTitle.textColor = [UIColor darkGrayColor]                  ;
}

//2     prepare view
- (void)showPrepareView
{
//  stars
    int starNum = (m_goods.rating >= 5) ? 5 : m_goods.rating;
    _starView.level     = starNum ;
    _lb_starLevel.text  = [NSString stringWithFormat:@"%d分",starNum] ;
    _lb_commentNum.text = [NSString stringWithFormat:@"%d人评价",m_goods.rating_count] ;
    
//  views
    _prepareView.backgroundColor = [UIColor whiteColor];
    //到手价
    lb_getPrice.text = [NSString stringWithFormat:@"￥%.2f",m_goods.actual_price];
    lb_getPrice.textColor = COLOR_PINK ;
    lb_daoshoujia.textColor = COLOR_PINK ;

    //原价
    if (m_goods.list_actual_price == 0) {
        lb_orgPrice.hidden = YES ;
    }
    lb_orgPrice.text = [NSString stringWithFormat:@"原价: ￥%.2f",m_goods.list_actual_price];
    lb_orgPrice.textColor = COLOR_WD_GRAY;
    //立省
    if (m_goods.discount_price == 0) {
        lb_saveMoney.hidden = YES ;
    }
    lb_saveMoney.text = [NSString stringWithFormat:@"立省￥%.2f",m_goods.discount_price];
    lb_saveMoney.backgroundColor = COLOR_WD_GREEN ;
    lb_saveMoney.textColor = [UIColor whiteColor];
    //来自
    NSString *sellerImg = [NSString stringWithFormat:@"http://www.jgb.cn%@",m_goods.seller.logo] ;
    [_img_fromWhere setImageWithURL:[NSURL URLWithString:sellerImg] AndSaleSize:CGSizeMake(65, 27)];
    _img_fromWhere.contentMode = UIViewContentModeScaleAspectFit ;
    //发货第,到达时间
    lb_howLong_arrive.text = [NSString stringWithFormat:@"有货,预计15天到达"];
    //汇率
    lb_exchangeRate.text = [NSString stringWithFormat:@"实时汇率: %@",CURRENT_RATE];
    lb_exchangeRate.textColor = COLOR_WD_GRAY ;
    
    
    goodsProperty *v1;
    goodsProperty *v2;
    goodsProperty *v3;
    
    
    if (m_goods.seller_id == 1000){
        v2 = (goodsProperty *)[[[NSBundle mainBundle] loadNibNamed:@"goodsProperty" owner:self options:nil] objectAtIndex:0];
        v2.img.image = [UIImage imageNamed:@"icon_taxgo"];
        v2.lb.text = @"保税仓直发";
        v2.lb.textColor = COLOR_WD_GREEN ;
    }else {
        v2 = (goodsProperty *)[[[NSBundle mainBundle] loadNibNamed:@"goodsProperty" owner:self options:nil] objectAtIndex:0];
        v2.img.image = [UIImage imageNamed:@"icon_overSea"];
        v2.lb.text = @"海外直发";
        v2.lb.textColor = COLOR_WD_GREEN ;
    }
    
    //属性view(正品,海外直发,极速)
    v1 = (goodsProperty *)[[[NSBundle mainBundle] loadNibNamed:@"goodsProperty" owner:self options:nil] objectAtIndex:0];
    v1.img.image = [UIImage imageNamed:@"icon_real"];
    v1.lb.text = @"正品保障";
    v1.lb.textColor = COLOR_WD_GREEN ;
    
    v3 = (goodsProperty *)[[[NSBundle mainBundle] loadNibNamed:@"goodsProperty" owner:self options:nil] objectAtIndex:0];
    v3.img.image = [UIImage imageNamed:@"icon_speed"];
    v3.lb.text = @"极速送达";
    v3.lb.textColor = COLOR_WD_GREEN ;
    
    NSArray *arr = @[v1,v2,v3];
    int i = 0 ;
    for (goodsProperty *pView in arr)
    {
        [pView setFrame:CGRectMake(i * pView.frame.size.width + 10, 0, pView.frame.size.width, pView.frame.size.height)];
        
        [_view_goodsPropertys addSubview:pView];
        
        i++ ;
    }
    _view_goodsPropertys.backgroundColor = [UIColor whiteColor] ;
    
}



#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(int)index
{

    NSURL *url = [NSURL URLWithString:(NSString *)[m_goods.galleries objectAtIndex:index]] ;
    [imageView setImageWithURL:url placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(320, 320)] ;
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index AndLR:(bool)lr
{
    NSLog(@"%@",lr?@"R":@"L");
    NSLog(@"did tap index = %d", (int)index);
    NSLog(@"tag:%d",imagePlayerView.tag);

    
    [self.delegate seeBigImgsWithIndex:index AndWithPicsArray:m_goods.galleries] ;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




#pragma mark --
#pragma mark - goods view Bar Actions       喜欢
- (IBAction)ilikeOrNot:(id)sender
{
    if ( ! G_TOKEN || [G_TOKEN isEqualToString:@""] )
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_NOTLOGIN] ;
        
        return  ;
    }
    
    UIButton *bt = (UIButton *)sender ;
    
    [self animationTransformWithButton:bt] ;

    dispatch_queue_t queue = dispatch_queue_create("likeQueue", NULL) ;
    dispatch_async(queue, ^{
        
        BOOL bSuccess = (!bt.selected) ? [ServerRequest likeCreateWithProductCode:m_goods.code] : [ServerRequest likeRemoveWithProductCode:m_goods.code] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bSuccess)
            {
                bt.selected = !bt.selected ;

                [DigitInformation showWordHudWithTitle:WD_HUD_OPERATE_SUCCESS] ;
            }
        }) ;
        
    }) ;
    
}

#pragma mark --
- (void)animationTransformWithButton:(UIButton *)bt
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values    = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes  = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [bt.layer addAnimation:k forKey:@"SHOW"];
}



- (IBAction)share:(id)sender
{
    NSLog(@"share") ;
    [self.delegate iWantShareThisGood:m_goods] ;
    
}



//加入购物车
#pragma mark --
#pragma mark - add shop car
- (void)shopCarPressedAction
{
//    NSLog(@"shopCarPressedAction") ;
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) )
    {
        //如果没有属性, 直接加入购物车
        [_delegate addToShopCarWithGoods:m_goods] ;
    }
    else
    {
        if (_attr == nil)
        {
            //如果有, 如果第一次进入页面,  进入选择尺码,
            [self.delegate chooseGoodsCatagoryWithAttr:m_goods.attr AndWithAttribute:m_goods.attribute AndWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
        }
        else
        {
            //如果选择过尺码, 加入购物车
            [_delegate addToShopCarWithGoods:m_goods] ;
        }
    }
}

//立即购买
#pragma mark - buy now
- (void)buyNowPressedAction
{
    if ( (! G_TOKEN) || [G_TOKEN isEqualToString:@""] )
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_NOTLOGIN] ;
        
        return ;
    }
    
    
    if (! _attr || ! m_goods.attribute )
    {
        //如果有, 如果第一次进入页面,  进入选择尺码,
        [self.delegate chooseGoodsCatagoryWithAttr:m_goods.attr AndWithAttribute:m_goods.attribute AndWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
    }
    else
    {
        //立即购买
        [self.delegate buyNowWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
    }
    
}

#pragma mark --
#pragma mark - Notification closeCheckPrice
- (void)closeCheckPrice
{
    m_bKeepCheck = NO ;
    
    [_activity_checkPrice removeFromSuperview] ;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GOODDETAIL_DISMISS object:nil] ;
}


#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) )
    {
        return 2 ;
    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) )
    {
        if (section == 0) {         //商品信息
            return 1;
        }else if (section == 1) {   //累计评价
            return 3;
        }
    }
    
    if (!section) {                 //选择尺码
        return 1;
    }else if (section == 1) {       //商品信息
        return 1;
    }else if (section == 2) {       //累计评价
        return 3;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) )
    {
        if (indexPath.section == 0)
        {   //商品信息
            static NSString *TableSampleIdentifier = @"cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     TableSampleIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:TableSampleIdentifier];
            }
            cell.selectionStyle = 0 ;
            cell.textLabel.numberOfLines = 0 ;
            cell.textLabel.textAlignment = NSTextAlignmentLeft ;
            cell.textLabel.text = @"查看 商品详情" ;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
            
            return cell;
        }else if (indexPath.section == 1)
        {   //累计评价
            static NSString *TableSampleIdentifier = @"CommentCell";
            
            CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
            if (cell == nil) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil];
                cell = [nibs objectAtIndex:0];
            }
            cell.selectionStyle = 0 ;
            cell.headPic.image = IMG_NOPIC ;
            [TeaCornerView setRoundHeadPicWithView:cell.headPic];
            
            cell.lbName.text = @"张三XX";
            NSString *commentStr = @"这速度够快呀，一天就到了，还不错没有暗角，我的是尼康套头。但是图像边缘有点模糊不过对于我们玩玩的人就不说什么了，不到200性价比不错";
            cell.lbText.text = commentStr ;
            cell.lbTime.text = @"2014年1月1日";                                   //日期
            cell.lbColor.text = @"中蓝薄料";
            cell.lbSize.text = @"XXXL";
            
            return cell ;
        }
    }
    
    
    if (!indexPath.section) {
        static NSString *TableSampleIdentifier = @"cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 TableSampleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:TableSampleIdentifier];
        }
        cell.textLabel.textAlignment = NSTextAlignmentLeft ;
        if (_attr == nil) {
            cell.textLabel.text = @"选择 尺码 颜色分类" ;
        }else {
            NSString *str = @"";
            for (NSString *string in [_attr allValues])
            {
                NSString *tem = [NSString stringWithFormat:@"\"%@\" ",string] ;
                str = [str stringByAppendingString:tem] ;
            }
            NSString *strNums = [NSString stringWithFormat:@"数量:x%d",m_buyNums] ;
            cell.textLabel.text = [NSString stringWithFormat:@"已选: %@ %@",str,strNums];
            

        }
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        cell.selectionStyle = 0 ;
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *TableSampleIdentifier = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 TableSampleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:TableSampleIdentifier];
        }
        cell.selectionStyle = 0 ;
        cell.textLabel.numberOfLines = 0 ;
        cell.textLabel.textAlignment = NSTextAlignmentLeft ;
        cell.textLabel.text = @"查看 商品详情" ;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        
        return cell;
    }else if (indexPath.section == 2) {
        static NSString *TableSampleIdentifier = @"CommentCell";

        CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil];
            cell = [nibs objectAtIndex:0];
        }
                cell.selectionStyle = 0 ;
        cell.headPic.image = IMG_NOPIC ;
        [TeaCornerView setRoundHeadPicWithView:cell.headPic];
        
        cell.lbName.text = @"张三XX";
        NSString *commentStr = @"这速度够快呀，一天就到了，还不错没有暗角，我的是尼康套头。但是图像边缘有点模糊不过对于我们玩玩的人就不说什么了，不到200性价比不错";
        cell.lbText.text = commentStr ;
        cell.lbTime.text = @"2014年1月1日";                                   //日期
        cell.lbColor.text = @"中蓝薄料";
        cell.lbSize.text = @"XXXL";
        
        return cell ;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) )
    {
        if (indexPath.section == 0)
        {
            return TABLEHEADHEIGHT ;
        }
        else if (indexPath.section == 1)
        {
            NSString *commentStr = @"这速度够快呀，一天就到了，还不错没有暗角，我的是尼康套头。但是图像边缘有点模糊不过对于我们玩玩的人就不说什么了，不到200性价比不错";
            UIFont *font = [UIFont systemFontOfSize:13];
            CGSize size = CGSizeMake(295,200);
            CGSize labelsize = [commentStr sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            float h =  112.0 - 15.0 + labelsize.height ;
            
            return h ;
        }
    }
    
    
    if (! indexPath.section)
    {
        return TABLEHEADHEIGHT ;
    }
    else if (indexPath.section == 1)
    {
        return TABLEHEADHEIGHT ;
    }
    else if (indexPath.section == 2)
    {
        NSString *commentStr = @"这速度够快呀，一天就到了，还不错没有暗角，我的是尼康套头。但是图像边缘有点模糊不过对于我们玩玩的人就不说什么了，不到200性价比不错";
        UIFont *font = [UIFont systemFontOfSize:13];
        CGSize size = CGSizeMake(295,200);
        CGSize labelsize = [commentStr sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        float h =  112.0 - 15.0 + labelsize.height ;
        
        return h ;
    }
    
    return 0 ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) )
    {
        if (indexPath.row == 0)
        {
            //查看商品信息
            NSString *descripCN = (m_goods.description_cn == nil) ? @"":m_goods.description_cn              ;
            NSString *descripEN = (m_goods.description_ == nil) ? @"": ((NSString *)m_goods.description_)     ;
            NSString *str       = [NSString stringWithFormat:@"%@\n%@",descripCN,descripEN];
            
            [self.delegate seeGoodsDescriptionWithHTMLstr:str] ;
            
            return ;
        }
    }
    
    if (!indexPath.section)
    {
        //选择尺码 颜色分类
        if (!indexPath.row)
        {
            [self.delegate chooseGoodsCatagoryWithAttr:m_goods.attr AndWithAttribute:m_goods.attribute AndWithGoods:m_goods AndWithBuyNums:m_buyNums] ;
        }
    }
    else if (indexPath.section == 1)
    {
        //查看商品信息
        NSString *descripCN = (m_goods.description_cn == nil) ? @"":m_goods.description_cn              ;
        NSString *descripEN = (m_goods.description_ == nil) ? @"": ((NSString *)m_goods.description_)     ;
        NSString *str       = [NSString stringWithFormat:@"%@\n%@",descripCN,descripEN];
        
        [self.delegate seeGoodsDescriptionWithHTMLstr:str] ;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) )
    {
        if (section == 0)
        {
            return nil ;
        }
        else if (section == 1)
        {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, TABLEHEADHEIGHT)];
            lab.text = @"累计评价" ;
            lab.textAlignment = NSTextAlignmentLeft ;
            lab.font = [UIFont systemFontOfSize:15] ;
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TABLEHEADHEIGHT)];
            view1.backgroundColor = [UIColor whiteColor];
            [view1 addSubview:lab] ;
            
            UIView *baseLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
            baseLine.backgroundColor = COLOR_BACKGROUND ;
            [view1 addSubview:baseLine] ;
            
            UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
            upLine.backgroundColor = COLOR_BACKGROUND ;
            [view1 addSubview:upLine] ;
            
            return view1;
        }
    }
    
    
    
    if (section == 0)
    {
        return nil ;
    }
    else if (section == 1)
    {
        return nil ;
    }
    else if (section == 2)
    {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, TABLEHEADHEIGHT)];
        lab.text = @"累计评价" ;
        lab.textAlignment = NSTextAlignmentLeft ;
        lab.font = [UIFont systemFontOfSize:15] ;
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TABLEHEADHEIGHT)];
        view1.backgroundColor = [UIColor whiteColor];
        [view1 addSubview:lab] ;
        
        UIView *baseLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
        baseLine.backgroundColor = COLOR_BACKGROUND ;
        [view1 addSubview:baseLine] ;
        
        UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
        upLine.backgroundColor = COLOR_BACKGROUND ;
        [view1 addSubview:upLine] ;
        
        return view1;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    int theRow = 1  ;
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) ) theRow = 0 ;
    
    if (section <= theRow)
    {
        return 0    ;
    }
    else
    {
        return TABLEHEADHEIGHT  ;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    int theSec = 2 ;
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) ) theSec = 1 ;
    
    if (section == theSec)
    {
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TABLEHEADHEIGHT)];
        back.backgroundColor = [UIColor whiteColor];

        UIButton *watchMoreBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [watchMoreBT setFrame:CGRectMake(160 - 50, 0, 100, TABLEHEADHEIGHT)] ;
        [watchMoreBT setTitle:@"查看更多评论" forState:UIControlStateNormal] ;
        [watchMoreBT setFont:[UIFont systemFontOfSize:14]];
        [watchMoreBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [watchMoreBT addTarget:self action:@selector(seeMoreComment) forControlEvents:UIControlEventTouchUpInside];
        [back addSubview:watchMoreBT];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        topLine.backgroundColor = COLOR_BACKGROUND ;
        [back addSubview:topLine] ;
        
        return back;
    }
    else
        return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    int theSec = 2      ;
    if ( (m_goods.attr == nil) || (m_goods.attribute == nil) ) theSec = 1 ;
    
    if (section == theSec)  return TABLEHEADHEIGHT      ;
    else                    return 0                    ;
    
}


#pragma mark - seeMoreComment - in Footer Comment
- (void)seeMoreComment
{
    NSLog(@"seeMoreComment");
    [self.delegate seeMoreCommentOfGood] ;
}


#pragma mark --
#pragma mark - collection dataSourse
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_pushGoodsArray == nil) return 0 ;
    
    return _pushGoodsArray.count ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"MayLikeCollectionCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"MayLikeCollectionCell"];
    
    // Set up the reuse identifier
    MayLikeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"MayLikeCollectionCell" forIndexPath:indexPath];
    
    if (_pushGoodsArray.count == 0) return cell ;

    // load the image for this cell
    Goods *goodTemp = (Goods *)[_pushGoodsArray objectAtIndex:indexPath.row] ;
    
    cell.img_goods.contentMode = UIViewContentModeScaleAspectFit;
    [cell.img_goods setImageWithURL:[NSURL URLWithString:[goodTemp.galleries objectAtIndex:0]] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(90, 90)];
    cell.lb_title.text      = goodTemp.title;
    cell.lb_price.text      = [NSString stringWithFormat:@"￥%.2f",goodTemp.actual_price];
    cell.lb_price.textColor = COLOR_PINK ;
    
    return cell;
}


//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Goods *goodTemp = (Goods *)[_pushGoodsArray objectAtIndex:indexPath.row] ;
    [self.delegate goInPushGoodDetail:goodTemp] ;
//    NSLog(@"index.row = %d",indexPath.row)    ;
}




@end



