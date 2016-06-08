//
//  FilterView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "FilterView.h"
#import "DigitInformation.h"
#import "FilterCell.h"
#import "FilterCheckCell.h"
#import "ServerRequest.h"

#define WD_WAREHOUSE    @"仓库"


@interface FilterView() <FilterCheckCellDelegate>
{
    Select_val      *tempSelectVal ;    //  temp 用来判断是否做过动作过
}
@end

@implementation FilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)setMyViews
{
    [self.commitBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [self.resetBt  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [self.backBt  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    
    self.barView.backgroundColor        = COLOR_PINK ;
    self.barView.userInteractionEnabled = YES ;
    
    self.backgroundColor            = [UIColor colorWithWhite:0.1 alpha:0.65] ;
    self.mianView.backgroundColor   = [UIColor clearColor];
    self.touchView.backgroundColor  = [UIColor clearColor];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToSearchVC)] ;
    [self.touchView addGestureRecognizer:tap1] ;
    
    self.table.delegate     = self      ;
    self.table.dataSource   = self      ;
    self.table.backgroundColor = COLOR_BACKGROUND ;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone ;
}

- (void)setM_selectVal:(Select_val *)m_selectVal
{
    _m_selectVal = m_selectVal ;
    
    if (!tempSelectVal)
    {
        tempSelectVal = [[Select_val alloc] initWithSelectVal:m_selectVal] ;
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib] ;

    [self setMyViews] ;
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;

#pragma mark -- 暂时清空品牌
//暂时清空品牌
    _brandList = @[] ;
//暂时清空品牌
#pragma mark -- 暂时清空品牌

}

#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    /*
     return 2;
     */
//CHANGE BY TEA BEGIN   20150207
    return 1 ;
//CHANGE BY TEA END     20150207
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
/*
    if (!section)
    {
        return 2 ;
    }
    else if (!(section - 1))
    {
        if (!_brandList.count)  return 2 ;
        else                    return 3 ;
    }
 
    return 0 ;
*/
    
//CHANGE BY TEA BEGIN   20150207
    return 1 ;
//CHANGE BY TEA END     20150207

}



//  @param  :   mode
//              1   促销
//              2   中文说明
- (FilterCheckCell *)getFilterCheckCellWithMode:(int)mode
                               AndWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentfier = @"FilterCheckCell" ;
    FilterCheckCell *cell = (FilterCheckCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier] ;
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FilterCheckCell" owner:self options:nil] lastObject] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    switch (mode)
    {
        case 0:
        {
            cell.lb_key.text    = @"促销"                    ;
            cell.switchView.on  = _m_selectVal.isOnSales    ;
            cell.delegate       = self                      ;
            cell.cellIndex      = IsOnSaleSwitch ;
            
        }
            break;
        case 1:
        {
            cell.lb_key.text    = @"中文说明"                ;
            cell.switchView.on  = _m_selectVal.isChinese    ;
            cell.delegate       = self                      ;
            cell.cellIndex      = IsChineseSwitch ;
        }
            break;
        default:
            break;
    }
    
    return cell ;
}

//  @param  :   mode
//              1   品牌
//              2   价格
//              3   商城
- (FilterCell *)getFilterCellWithMode:(int)mode
                     AndWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentfier = @"FilterCell";
    FilterCell *cell = (FilterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil] lastObject] ;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    switch (mode) {
        case 1:
        {
            cell.lb_key.text    = @"品牌" ;
            cell.lb_value.text  = (_m_selectVal.currentBrandSTR == nil || [_m_selectVal.currentBrandSTR isEqualToString:@""]) ? @"全部" : _m_selectVal.currentBrandSTR  ;
        }
            break;
        case 2:
        {
            Price_area *area ;
            cell.lb_key.text    = @"价格" ;
            if (_m_selectVal.currentPriceArea != -1) {
                area = (Price_area *)[_m_selectVal.priceAreaArray objectAtIndex:_m_selectVal.currentPriceArea] ;
            }
            cell.lb_value.text  = (_m_selectVal.currentPriceArea == -1) ? @"全部" : area.name ;
        }
            break;
        case 3:
        {
            cell.lb_key.text = WD_WAREHOUSE ;

            WareHouse *ware ;
            if (_m_selectVal.currentSellers != -1)
            {
                if ([[DigitInformation shareInstance].g_wareHouseList count] > 0) {
                    ware = (WareHouse *)[[DigitInformation shareInstance].g_wareHouseList objectAtIndex:_m_selectVal.currentSellers] ;
                }
            }
            cell.lb_value.text  = (_m_selectVal.currentSellers == -1) ? @"全部" : ware.name ;
        }
            break;
            
        default:
            break;
    }
    
    return cell ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//CHANGE BY TEA BEGIN   20150207
    return [self getFilterCellWithMode:3 AndWithTableView:tableView] ;
//CHANGE BY TEA END     20150207
    
/*
    if (!indexPath.section)
    {
        //2 switch
        switch (indexPath.row)
        {
            case 0:
            {
                return [self getFilterCheckCellWithMode:0 AndWithTableView:tableView] ;
            }
                break;
            case 1:
            {
                return [self getFilterCheckCellWithMode:1 AndWithTableView:tableView] ;
            }
                break;
            default:
                break;
        }
    }
    else if (! (indexPath.section - 1) )
    {
        
        if (_brandList.count)
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    return [self getFilterCellWithMode:1 AndWithTableView:tableView] ;
                }
                    break;
                case 1:
                {
                    return [self getFilterCellWithMode:2 AndWithTableView:tableView] ;
                }
                    break;
                case 2:
                {
                    return [self getFilterCellWithMode:3 AndWithTableView:tableView] ;
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
                {
                    return [self getFilterCellWithMode:2 AndWithTableView:tableView] ;
                }
                    break;
                case 1:
                {
                    return [self getFilterCellWithMode:3 AndWithTableView:tableView] ;
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    
    return nil ;
*/
    
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
    if ( !(indexPath.section - 1) ) //非多选section
    {
        FilterCell *cell = (FilterCell *)[tableView cellForRowAtIndexPath:indexPath] ;
        NSString *key = cell.lb_key.text ;
        
        [self.delegate go2FliterControllerWithFlag:key AndWithValue:_m_selectVal AndWithBrandList:_brandList] ;
    }
*/
    
    //CHANGE BY TEA BEGIN   20150207
    FilterCell *cell = (FilterCell *)[tableView cellForRowAtIndexPath:indexPath] ;
    NSString *key = cell.lb_key.text ;
    
    [self.delegate go2FliterControllerWithFlag:key AndWithValue:_m_selectVal AndWithBrandList:_brandList] ;
    //CHANGE BY TEA END     20150207

}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f   ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = COLOR_BACKGROUND ;
    
    return back  ;
}


- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *back = [[UIView alloc] init] ;
    back.backgroundColor = COLOR_BACKGROUND ;
    
    return back  ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0   ;
}

/*
//
 nly override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark --
#pragma mark - commitAciton
- (IBAction)commitAciton:(id)sender
{
    BOOL isDoNothing = (_m_selectVal.currentSellers == tempSelectVal.currentSellers) && (_m_selectVal.currentPriceArea == tempSelectVal.currentPriceArea) && ([_m_selectVal.currentBrandSTR isEqualToString:tempSelectVal.currentBrandSTR]) && (_m_selectVal.isChinese == tempSelectVal.isChinese) && (_m_selectVal.isOnSales == tempSelectVal.isOnSales) ;
    
    [_delegate commitOrCancelWithFlag:!isDoNothing] ;
}

- (IBAction)resetAction:(id)sender
{
    [self clearAllCurrentSelectIndex]   ;
    [self.table reloadData]             ;
}

- (IBAction)backAction:(id)sender
{
    [self backToSearchVC] ;
}

#pragma mark --
//  clearAllCurrentSelectIndex
- (void)clearAllCurrentSelectIndex
{
    _m_selectVal.currentSellers      = -1    ;
    _m_selectVal.currentPriceArea    = -1    ;
    _m_selectVal.currentBrandSTR     = @""   ;
    
    _m_selectVal.isChinese = false           ;
    _m_selectVal.isOnSales = false           ;
}


//  click gray back ground and back to show searchVC
- (void)backToSearchVC
{
//    [self clearAllCurrentSelectIndex]       ;
    [_delegate commitOrCancelWithFlag:NO]   ;
}

#pragma --
#pragma - FilterCheckCellDelegate
- (void)switchTheCondition:(BOOL)onOff AndWithMode:(FilterCheckCellType)FilterCheckCellType
{
    switch (FilterCheckCellType)
    {
        case IsOnSaleSwitch:
        {
            _m_selectVal.isOnSales = onOff ;
        }
            break;
        case IsChineseSwitch:
        {
            _m_selectVal.isChinese = onOff ;
        }
            break;
        default:
            break;
    }
}



@end
