//
//  ModalTablePopView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ModalTablePopView.h"
#import "PopSubCell.h"

#import "DetailCellObj.h"
#import "ExpressageDetail.h"
//#import "PopTitleCell.h"
#import "NoteGoodsCell.h"
#import "ColorsHeader.h"
#import "PopShipCell.h"
#import "PopFooterView.h"



#define TAX_DESCRIP_SELFSALE    @"收件人根据《中华人民共和国关税条例》有义务对个人自用进境物品缴纳行邮税，行邮税低于50元以下予以免征。金箍棒海外购支持国家相关法律法规政策，提倡海淘用户主动报关并缴纳关税。清关过程中商品会接受抽检，被抽检到并且符合海关缴税规定的商品会收到相应的缴税通知单。未抽检到或者免税类商品不需要缴纳相应关税。"
#define TAX_ADD                 @"美国Amazon.com、6PM商品2000元以下订单，金箍棒海外购予以关税补贴。"



#define STR_SHIP_DESCRIP        @"以上时间为预估时间，仅供参考。如因自然灾害或其他不可抗力造成的延误或损坏，因海关清关规定或其它主管机关规定所致的延误或者退运，因发件人提供了错误、不完整、不正确的地址信息，无法联系收件人，因航班延误、取消或停飞造成的货物发送延误，金箍棒海外购仍会尽合理的努力，尽快运送至目的地并完成送件，但没有义务在出现此类情况时向您发出通知及承担事后赔偿责任。"

@implementation ModalTablePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _table.dataSource = self ;
    _table.delegate   = self ;
    
    _table.backgroundColor = [UIColor whiteColor] ;
    _table.layer.cornerRadius = 10.0f ;
    
    UIColor *bgColor = [UIColor colorWithWhite:0.05 alpha:0.5] ;
    _bgButton.backgroundColor = bgColor ;
    
    _table.center = CGPointMake(APPFRAME.size.width / 2, APPFRAME.size.height / 2) ;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    _table.showsVerticalScrollIndicator = NO ;

}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
//  NSLog(@"layout : %@",NSStringFromCGRect(_table.frame)) ;
    
    float height = 380.0f ;

    _table.frame = CGRectMake(_table.frame.origin.x, APPFRAME.size.height - height, _table.frame.size.width, height) ;
    
}


- (IBAction)tapAction:(id)sender
{
    NSLog(@"i tap") ;
    
    [self.delegate clickOutSide] ;
}





#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3 ; // title + 价格 + 物流
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    
    switch (section) {
        case 0: // title
        {
            if (_isAddAmazon) {
                return 2 ;
            } else {
                return 1 ;
            }
        }
            break;
        case 1: // 价格
        {
            return [_data_priceDetail count] ;
        }
            break;
        case 2: // 物流
        {
            return 1 ;
        }
            break;
        default:
            break;
    }
    
    return 0 ;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row ;

    switch (indexPath.section) {
        case 0: // title
        {
            static NSString *identifier = @"NoteGoodsCell" ;
            NoteGoodsCell *cell = (NoteGoodsCell *)[tableView dequeueReusableCellWithIdentifier:identifier] ;
            if (!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] objectAtIndex:0];
            }
            
            if (_isAddAmazon) {
                if (!row) {
                    cell.noteMode = modeAddons ;
                } else {
                    cell.noteMode = modeDaiGou ;
                }
            } else {
                if (_isSelfSales) {
                    cell.noteMode = modeZiYin ;
                } else {
                    cell.noteMode = modeDaiGou ;
                }
            }
            
            return cell ;
        }
            break;
        case 1: // 价格
        {
            static NSString *TableSampleIdentifier = @"PopSubCell";
            PopSubCell *cell = (PopSubCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0];
            }
            DetailCellObj *cellObj = (DetailCellObj *)_data_priceDetail[row] ;
            cell.cellObj = cellObj ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
            break;
        case 2: // 物流
        {
            static NSString *TableSampleIdentifier = @"PopShipCell";
            PopShipCell *cell = (PopShipCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0];
            }
            
            cell.expressDetail = _expressDetail ;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone ;
            
            return cell ;
        }
            break;
        default:
            break;
    }
    
    
    
    return nil ;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section ;
    
    if (section == 0)
    {
        return 23.0f ;
    }
    else if (section == 1)
    {
        //  价格
        return 30.0f ;
    }
    else if (section == 2)
    {
        //  物流
        return 100.0f ;
    }
    
    return 0.0f ;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;
    if (section == 0) return backView ;
    
//
    backView.backgroundColor = [UIColor whiteColor] ;
    backView.frame = CGRectMake(0, 0, 320, 30) ;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 200, 30)] ;
    lb.font = [UIFont systemFontOfSize:14] ;
    lb.text = (section == 1) ? @"价格说明:" : @"物流说明:" ;
    [backView addSubview:lb] ;
    
    return backView ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 10.0f ;
    
    return 30 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *backView = [[UIView alloc] init] ;
        backView.backgroundColor = nil ;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 320-30, 1)] ;
        line.backgroundColor = COLOR_BACKGROUND ;
        [backView addSubview:line] ;
        
        return backView ;
    }
    else if (section == 1)
    {
        PopFooterView *footerView = (PopFooterView *)[[[NSBundle mainBundle] loadNibNamed:@"PopFooterView" owner:self options:nil] firstObject] ;
        footerView.strContent = [self getTaxContent] ;
        
        return footerView ;
    }
    else if (section == 2)
    {
        PopFooterView *footerView = (PopFooterView *)[[[NSBundle mainBundle] loadNibNamed:@"PopFooterView" owner:self options:nil] firstObject] ;
        footerView.strContent = STR_SHIP_DESCRIP ;
        
        return footerView ;
    }

    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!section)
    {
        return 1.0f ;
    }
    
    NSString *str = (section == 1) ? [self getTaxContent] : STR_SHIP_DESCRIP ;
    
    return [PopFooterView getPopFooterViewHeightWithContent:str] ;
}


- (NSString *)getTaxContent
{
    return _isSelfSales ? TAX_DESCRIP_SELFSALE : [NSString stringWithFormat:@"%@\n%@%@",TAX_DESCRIP_SELFSALE,_seller.name,TAX_ADD] ;
}

@end
