//
//  ShipViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-14.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ShipViewController.h"
#import "ShipDetailController.h"
#import "OrderProduct.h"
#import "ShipHead.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "ServerRequest.h"
#import "BagStatus.h"
#import "CheckOutGoodCell.h"
#import "YXSpritesLoadingView.h"
#import "BagConditionHeader.h"
#import "ProductsInBagCell.h"


@interface ShipViewController () <BagConditionHeaderDelegate>
{
    NSMutableArray            *m_list ;
    int                       m_bagStatusRow ;  // 包裹状态(是否确认收货)  row
    
}
@end

@implementation ShipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"包裹" ;
    
    _table.backgroundColor = COLOR_BACKGROUND ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    if (!m_list)  m_list = [NSMutableArray array] ;
    
    [m_list removeAllObjects];
    
    __block ResultPasel *result ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        result = [ServerRequest getBagListWithParcelID:_parcelID] ;

    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        if (result.code != 200)
        {
            self.isNothing = YES ;
            return ;
        }
        
        NSDictionary *resultDic = (NSDictionary *)result.data ;
        NSString *key = [NSString stringWithFormat:@"%d",_parcelID] ;
        NSDictionary *bagDic = [resultDic objectForKey:key] ;
        if ( bagDic == nil || [bagDic isKindOfClass:[NSNull class]] )
        {
            self.isNothing = YES ;
            return ;
        }
        
        NSArray *bagKeyList = [bagDic allKeys] ;
        for (NSString *bagKey in bagKeyList)
        {
            Bag *abag = [[Bag alloc] initWithDic:[bagDic objectForKey:bagKey]] ;
            [m_list addObject:abag] ;
        }
        
        [_table reloadData] ;
        
    } AndWithMinSec:0] ;
    
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
//    return 1 ;
//CHANGE BY TEA @20150325 BEGIN
    return [m_list count] ;
//CHANGE BY TEA @20150325 END
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//CHANGE BY TEA @20150325 BEGIN
    return 1 ;
//CHANGE BY TEA @20150325 END
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    int row     = indexPath.row     ;
    
    static NSString *TableSampleIdentifier = @"ProductsInBagCell";
    ProductsInBagCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier] ;
    
    if ( !cell )
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    Bag *abag = m_list[section] ;
    cell.proArray = abag.productArray ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BagConditionHeader *header = (BagConditionHeader *)[[[NSBundle mainBundle] loadNibNamed:@"BagConditionHeader" owner:self options:nil] firstObject] ;
    header.abag = m_list[section] ;
    header.delegate = self ;
    header.section = section ;
    return header ;
}

- (UIView *)getEmpty
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = nil ;
    return back ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 75.0f ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = nil ;
    return back ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f ;
}


#pragma mark --
#pragma mark - BagConditionHeaderDelegate
//看包裹详情
- (void)seeShipDetailCallBack:(int)section
{
    Bag *abag                               = m_list[section] ;
    
    UIStoryboard         *story             = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    ShipDetailController *shipDetailCtrller = [story instantiateViewControllerWithIdentifier:@"ShipDetailController"] ;
    
    shipDetailCtrller.bagID                 = abag.bagID    ;
    shipDetailCtrller.parcelID              = _parcelID     ;
    shipDetailCtrller.oid                   = _orderIdStr   ;
    
    [self.navigationController pushViewController:shipDetailCtrller animated:YES] ;
}

//签收包裹
- (void)signInOrComment:(int)section
{
    m_bagStatusRow = section ;
    // 去server, 此处还需调用确认收货接口
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认收货?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil] ;
    [alertView show] ;
}



#pragma mark --
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //  是否确认收货?
    if (buttonIndex == 1)
    {
        NSLog(@"yes 确认收货") ;
        
        for (int i = 0; i <= m_list.count; i++)
        {
            if (i == m_bagStatusRow)
            {
                // get the bag , correct from server
                Bag *abag = m_list[m_bagStatusRow] ;
                
                __block ResultPasel *result ;
                
                [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
                [DigitInformation showHudWhileExecutingBlock:^{
                    
                    result = [ServerRequest receiveBagWithBagID:abag.bagID] ;

                } AndComplete:^{
                    
                    [YXSpritesLoadingView dismiss] ;
                    
                    if (result.code == 200)
                    {
                        [DigitInformation showWordHudWithTitle:WD_HUD_BAGSIGN_SUC] ;
                        // reset the table views
                        ((Bag *)[m_list objectAtIndex:i]).status = 1 ;
                    }
                    else
                    {
                        [DigitInformation showWordHudWithTitle:WD_HUD_BAGSIGN_FAI] ;
                    }
                    
                    [_table reloadData] ;

                } AndWithMinSec:0] ;
                
                
                break ;
            }
        }
        
    }
    
    
}



/*
 #pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
