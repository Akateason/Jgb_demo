//
//  COOrderMoneyCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "COOrderMoneyCell.h"
#import "MonListCell.h"
#import "DetailCellObj.h"
#import "ColorsHeader.h"

#define MoneyCellHeight     37.0f

#define DEFAULT_CELL_LINE   1

@interface  COOrderMoneyCell ()
{
    NSArray *m_strikeChineseKeys ;
}
@end

@implementation COOrderMoneyCell


- (void)setup
{
    
    self.backgroundColor = COLOR_BACKGROUND ;
    
    _tableOrderMoney.delegate   = self      ;
    _tableOrderMoney.dataSource = self      ;
    _tableOrderMoney.layer.cornerRadius = 2.0f ;
    _tableOrderMoney.scrollEnabled = NO ;
    _tableOrderMoney.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
    _tableOrderMoney.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10) ;
    _tableOrderMoney.separatorColor = COLOR_BACKGROUND ;
    
    float tableHeight ;
    if (_dataSource)
    {
        tableHeight = (_dataSource.count) ? ((_dataSource.count + 1) * MoneyCellHeight) : (DEFAULT_CELL_LINE * MoneyCellHeight) ;
    }
    
    _height.constant = tableHeight ;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    [self setup] ;
    
    m_strikeChineseKeys = @[KEYS_TAX,KEYS_HELP_BUY] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark --
#pragma mark - setter
- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource ;
    
    float tableHeight ;

    tableHeight = (_dataSource.count) ? ((_dataSource.count + 1) * MoneyCellHeight) : (DEFAULT_CELL_LINE * MoneyCellHeight) ;
    
    _height.constant = tableHeight ;
    
    [_tableOrderMoney reloadData] ;
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
    return ( _dataSource.count ) ? ( _dataSource.count + 1 ) : ( DEFAULT_CELL_LINE ) ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row     = indexPath.row ;
//  int section = indexPath.section ;
    
    static NSString *monCell = @"MonListCell" ;
    MonListCell * cell = [tableView dequeueReusableCellWithIdentifier:monCell];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:monCell bundle:nil] forCellReuseIdentifier:monCell];
        cell = [tableView dequeueReusableCellWithIdentifier:monCell];
    }
    
    cell.lb_val.hidden = NO ;
    cell.lb_key.hidden = NO ;
    cell.lb_key.textColor = [UIColor darkGrayColor] ;
    
    if ( row == 0 )
    {
        //  first line
        cell.lb_val.hidden = YES ;
        cell.lb_key.font = [UIFont systemFontOfSize:12.0f] ;
        cell.lb_key.textColor = [UIColor blackColor] ;
        cell.lb_key.text = @"订单金额" ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
       
        return cell ;
    }
    
    DetailCellObj *obj = (DetailCellObj *)[_dataSource objectAtIndex:(row - 1)] ;
    
    cell.lb_key.text = obj.keyChinese ;
    
    cell.lb_val.text = obj.valDescrip ;
    
    int lastLineRow = ( _dataSource.count ) ? ( _dataSource.count ) : ( DEFAULT_CELL_LINE - 1 ) ;
    
    if ( row == lastLineRow && _sumAllPrice)
    {
        cell.lb_val.text = [NSString stringWithFormat:@"￥%.2f", _sumAllPrice] ;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) return ;
    
    DetailCellObj *obj = (DetailCellObj *)[_dataSource objectAtIndex:indexPath.row - 1] ;

    MonListCell *mCell = (MonListCell *)cell ;
    
    mCell.lb_val.strikeThroughEnabled = [self getStrikeThroughEnabledWithObj:obj];   //  划线
    
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MoneyCellHeight ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getEmptyView] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1 ;
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


#pragma mark --
#pragma mark - is strike throught or not
/*
 * @params:     obj in cells data source
 * @return:     bool
 */
- (BOOL)getStrikeThroughEnabledWithObj:(DetailCellObj *)obj
{
    // key in the list m_strikeChineseKeys which in member values
    
    for (NSString *tempKeysWillStrike in m_strikeChineseKeys)
    {
        if ([tempKeysWillStrike isEqualToString:obj.keyChinese])
        {
            return YES ;
        }
    }
    
    // price is 0 .
    
    if (!obj.price) return YES ;
    
    return NO ;
}



@end



