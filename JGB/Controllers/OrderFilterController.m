//
//  OrderFilterController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "OrderFilterController.h"
#import "OrderStatus.h"
#import "DigitInformation.h"
#import "YXSpritesLoadingView.h"

@interface OrderFilterController ()
{
    NSMutableArray      *m_orderStatus_DataSourse ;
}
@end

@implementation OrderFilterController

#pragma mark --

- (void)setDataSource
{
    m_orderStatus_DataSourse = [NSMutableArray array] ;
    
    
    OrderStatus *statusAll = [[OrderStatus alloc] init] ;
    statusAll.idStatus     = 0 ;
    statusAll.name         = @"全部" ;
    
    [m_orderStatus_DataSourse addObject:statusAll] ;
    
    for (OrderStatus *status in G_ORDERSTATUS_DIC)
    {
        [m_orderStatus_DataSourse addObject:status] ;
    }
}

- (void)viewStyle
{
    _table.separatorStyle   = UITableViewCellSeparatorStyleSingleLine ;
    _table.separatorInset   = UIEdgeInsetsMake(0, 10, 0, 10) ;
    _table.separatorColor   = COLOR_BACKGROUND ;
    _table.backgroundColor  = COLOR_BACKGROUND ;
    _table.delegate     = self ;
    _table.dataSource   = self ;
}

#pragma mark --

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setDataSource]    ;
    [self viewStyle]        ;
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_orderStatus_DataSourse count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"FilterCell2" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier] ;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
    }
    
    cell.textLabel.font         = [UIFont systemFontOfSize:12.0f]   ;
    cell.textLabel.textColor    = [UIColor darkGrayColor]           ;
    cell.tintColor              = COLOR_WD_GREEN                    ;
    
    cell.selectionStyle         = UITableViewCellSelectionStyleNone ;
    
    OrderStatus *orderStat = (OrderStatus *)m_orderStatus_DataSourse[indexPath.row] ;
    
    cell.textLabel.text = orderStat.name ;
    
    cell.accessoryType = ( orderStat.idStatus == _orderStatus ) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone ;
    
    return cell ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderStatus *orderStat = (OrderStatus *)m_orderStatus_DataSourse[indexPath.row] ;
    _orderStatus = orderStat.idStatus ;
    [_table reloadData] ;
    
    
    [self performSelector:@selector(popAndPostNotification) withObject:nil afterDelay:0.5] ;

}

- (void)popAndPostNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ORDER_FILTER_POST object:@(_orderStatus)] ;
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark --

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getEmptyView] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self getEmptyView] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1 ;
}

- (UIView *)getEmptyView
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


@end
