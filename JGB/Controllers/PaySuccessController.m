//
//  PaySuccessController.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-20.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "PaySuccessController.h"
#import "GoodsDetailViewController.h"
#import "OrderViewController.h"
#import "DigitInformation.h"
#import "YXSpritesLoadingView.h"
#import "ServerRequest.h"
#import "Order.h"
#import "ReceiveAddress.h"
#import "PaySuccessCell.h"
#import "OrderDetailController.h"

@interface PaySuccessController ()<PaySuccessCellDelegate>
{
    Order           *m_currentOrder ;
    ReceiveAddress  *m_address ;
}
@end

@implementation PaySuccessController

#pragma mark --
#pragma mark - OVERWRITE BACK BUTTON
- (void)overwriteBackButton
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = returnButtonItem;
}



#pragma mark --
#pragma mark - overwrite back button actions
- (void)backAction
{
    NSArray *ctrllerListInStack = self.navigationController.viewControllers ;
    for (UIViewController *ctrller in ctrllerListInStack)
    {
        // exists goods detail vcs, means pay in straight buy ,
        if ([ctrller isKindOfClass:[GoodsDetailViewController class]])
        {
            GoodsDetailViewController *goodsDeatilVC = (GoodsDetailViewController *)ctrller ;
            [self.navigationController popToViewController:goodsDeatilVC animated:YES] ;
            return ;
        }
    }
    
    for (UIViewController *ctrller in ctrllerListInStack)
    {
        // exists order list vcs, means pay in orderlist ,
        if ([ctrller isKindOfClass:[OrderViewController class]])
        {
            OrderViewController *orderVC = (OrderViewController *)ctrller ;
            [self.navigationController popToViewController:orderVC animated:YES] ;
            return ;
        }
    }
    
    //  otherwise, condition: pay in cart
    [self.navigationController popToRootViewControllerAnimated:YES] ;
}

#pragma mark --
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //overwrite back button
    [self overwriteBackButton] ;
    
    _table.delegate         = self ;
    _table.dataSource       = self ;
    _table.separatorStyle   = UITableViewCellSeparatorStyleNone ;
    _table.backgroundColor  = COLOR_BACKGROUND ;
    
    //
    NSLog(@"G_ORDERID_STR : %@",G_ORDERID_STR) ;
    
    if (!G_ORDERID_STR) return ;
    
    __block NSDictionary *resultDic ;

    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
         resultDic = [ServerRequest getOrderDetailWithOrderID:G_ORDERID_STR] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        int code                    = [[resultDic objectForKey:@"code"] intValue]   ;
        if (code == 200)
        {
            NSDictionary *dataDic   = [resultDic objectForKey:@"data"]              ;
            
            // order
            m_currentOrder          = [[Order alloc] initWithDictionary:dataDic]    ;
            m_address               = m_currentOrder.address                        ;
            
            [_table reloadData] ;
        }
        else
        {
            self.isNothing = YES    ;
            [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK] ;
        }

        
    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
    
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
    return 1 ;
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"PaySuccessCell";
    PaySuccessCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    cell.address  = m_address ;
    cell.order    = m_currentOrder ;
    cell.delegate = self ;
    cell.selectionStyle   = UITableViewCellSelectionStyleNone ;
    
    return cell ;
}



- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 335.0f ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark --
#pragma mark - PaySuccessCellDelegate
- (void)seeOrderDetail
{
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        NSLog(@"wait for 1 sec") ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        [self performSegueWithIdentifier:@"paySuccess2OrderDetail" sender:G_ORDERID_STR] ;

    } AndWithMinSec:1.0] ;
    
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"paySuccess2OrderDetail"])
    {
        OrderDetailController *orderDetailVC = (OrderDetailController *)[segue destinationViewController] ;
        orderDetailVC.orderIDStr             = (NSString *)sender ;
    }
    
}


@end
