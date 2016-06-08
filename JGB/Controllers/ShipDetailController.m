//
//  ShipDetailController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-14.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ShipDetailController.h"
#import "MessageCell.h"
#import "ShipHead.h"
#import "ServerRequest.h"
#import "Kuaidi.h"
#import "KuaidiHistory.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "NoShipCell.h"
#import "ChinaKuaidi.h"
#import "BagStatus.h"
#import "YXSpritesLoadingView.h"
#import "DigitInformation.h"
#import "BagConditionCell.h"

@interface ShipDetailController ()
{
    NSMutableArray      *m_dataSource   ;       //物流详情datasource
    NSMutableArray      *m_goodlist     ;       //包裹商品
    
    NSString            *m_strStatus    ;
    NSString            *m_strBagID     ;
    
    Bag                 *m_currentBag   ;
}
@end

@implementation ShipDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)setup
{
    m_strBagID   = @"" ;
    
    _table.separatorStyle  = UITableViewCellSeparatorStyleNone ;
    _table.backgroundColor = COLOR_BACKGROUND ;
    
    _viewBottom.backgroundColor = COLOR_BACKGROUND ;
    
    _bt_Multi.backgroundColor = COLOR_PINK ;
    _bt_Multi.layer.cornerRadius = 4.0f ;
    [_bt_Multi setTitle:@"确认收货" forState:UIControlStateNormal] ;
    
    _bottomViewHeightConstraint.constant = 0.0f ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1. set views
    [self setup] ;
    
    //2. good list
    m_goodlist             = [NSMutableArray array] ;
    m_dataSource           = [NSMutableArray array] ;

    //3.
    __block ResultPasel *result ;
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        result = [ServerRequest getBagDetailWithParcelID:_parcelID AndWithBagID:_bagID] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        if (result.code != 200)
        {
            self.isNothing = YES ;
            return ;
        }

        [self setupBagWithResult:result] ;

        [_table reloadData] ;
        
    } AndWithMinSec:0] ;
    
}


- (void)setupBagWithResult:(ResultPasel *)result
{
    m_currentBag = [[Bag alloc] initWithDic:result.data] ;

    //底部栏
    _bottomViewHeightConstraint.constant = (m_currentBag.status) ? 0.0f : 50.0f ;
    
    //包裹状态
    m_strStatus  = [Bag getBagStatusStrWithStatus:m_currentBag.status] ;
    //包裹id
    m_strBagID   = [NSString stringWithFormat:@"%d",m_currentBag.bagID] ;
    //商品list
    m_goodlist   = [NSMutableArray arrayWithArray:m_currentBag.productArray] ;
    //物流list
    m_dataSource = [NSMutableArray arrayWithArray:m_currentBag.transInfoArray] ;
    
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
    return 2 ;  // 包裹介绍 + 物流详情
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)           //包裹介绍
    {
        return 1 ;
    }
    else if (section == 1)      //物流详情
    {
        return m_dataSource.count ;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    int row     = indexPath.row     ;
    
    if (section == 0)               //包裹介绍
    {
        static NSString *TableSampleIdentifier = @"BagConditionCell" ;
        BagConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier] ;
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier] ;
        if (! cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier] ;
        }
        cell.parcelID = _oid ;
        cell.theBag = m_currentBag ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell ;
    }
    else if (section == 1)          //物流详情
    {
        static NSString *TableSampleIdentifier = @"MessageCell";
        MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        
        if (cell == nil)
        {
            cell = (MessageCell *)[[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TransInfo *trans = (TransInfo *)m_dataSource[row] ;
        
        cell.lb_content.text = trans.shipment ;
        cell.lb_time.text    = trans.create_time ;
        
        cell.isHavingBorder  = NO ;
        cell.isFirstPoint    = NO ;

        // set cell style
        cell.line_Is_FME     = 0 ;
        
        cell.lb_content.textColor = [UIColor darkGrayColor] ;
        
        if (! indexPath.row )
        {
            //  first line
            cell.line_Is_FME = -1 ;
            cell.isFirstPoint = YES ;
            cell.lb_content.textColor = COLOR_PINK ;
        }else if (indexPath.row == m_dataSource.count - 1)
        {
            //  last line
            cell.line_Is_FME =  1 ;
        }
        
        cell.lb_choujiang.hidden = YES ;
        
        return cell ;
    }
    
    return nil ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 72.0f ;
    }
    else if (indexPath.section == 1)
    {
        TransInfo *trans = (TransInfo *)m_dataSource[indexPath.row] ;
        NSString *str = trans.shipment ;

        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize size = CGSizeMake(245,100);
        CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        
        return 71 - 15 + labelsize.height;
    }
    
    return 1.0f ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getEmpty] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 1.0f ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self getEmpty] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f ;
}

- (UIView *)getEmpty
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = nil ;
    return back ;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark --
#pragma mark - confirm recieve
- (IBAction)buttonClickAction:(id)sender
{
    NSLog(@"确认收货") ;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认收货?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil] ;
    [alertView show]  ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //  是否确认收货?
    if (buttonIndex == 1)
    {
        NSLog(@"yes 确认收货") ;
        
        ResultPasel *result = [ServerRequest receiveBagWithBagID:m_currentBag.bagID] ;
        if (result.code == 200)
        {
            [DigitInformation showWordHudWithTitle:WD_HUD_BAGSIGN_SUC] ;
            m_currentBag.status = 1 ;
        }
        else
        {
            [DigitInformation showWordHudWithTitle:WD_HUD_BAGSIGN_FAI] ;
        }
    }
    
    _bottomViewHeightConstraint.constant = (m_currentBag.status) ? 0.0f : 50.0f ;
}



@end
