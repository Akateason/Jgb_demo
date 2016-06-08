
//
//  CouponsController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CouponsController.h"
#import "CouponCell.h"
#import "WeiXinView.h"
#import "ServerRequest.h"
#import "CoupsonWriteView.h"
#import "YXSpritesLoadingView.h"

#define MY_PAGE_SIZE        200

@interface CouponsController () <CoupsonWriteViewDelegate>
{
    int   m_currentPage ;
}
@end

@implementation CouponsController

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
    
//---1--- datasource ---1---
    
    m_currentPage = 1 ;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    if (_LookOrSelect)
    {
        //coupon can be select
        NSLog(@"coupon can be select : %@",_coupsonList) ;
        
        [self setTableBackground] ;
    }
    else
    {
        //coupon read only
        
        [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
        [DigitInformation showHudWhileExecutingBlock:^{
            
            _coupsonList = [NSMutableArray array] ;
            
            ResultPasel *result = [ServerRequest getMyCoupsonListWithPage:m_currentPage AndWithSize:MY_PAGE_SIZE] ;
            
            if (result.code == 200)
            {
                if (![result.data isKindOfClass:[NSNull class]])
                {
                    for ( NSDictionary *tempDic in (NSArray *)result.data )
                    {
                        Coupon *tempCoupson = [[Coupon alloc] initFromCoupsonListWithDic:tempDic] ;
                        [_coupsonList addObject:tempCoupson] ;
                    }
  
                }
            }

        } AndComplete:^{
            
            [_table reloadData] ;
            
            [YXSpritesLoadingView dismiss] ;
            
            NSLog(@"coupon read only : %@",_coupsonList) ;
            
            [self setTableBackground] ;
            
        } AndWithMinSec:0] ;
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
}


- (void)setTableBackground
{
    
    if (!_coupsonList.count)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_table.frame] ;
        UIImage *img = [UIImage imageNamed:@"noCoupson"] ;
        imageView.image = img ;
        imageView.contentMode = UIViewContentModeScaleAspectFit ;
        [_table setBackgroundView:imageView] ;
    }
    else
    {
        [_table setBackgroundView:nil] ;
    }
    
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
    return 1 ; //
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_coupsonList count] ;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"CouponCell" ;
    CouponCell *cell = (CouponCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier] ;
    if (cell == nil)
    {
        cell = (CouponCell *)[[[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.coupson = _coupsonList[indexPath.row]  ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;   //  选中无背景色
    
    return cell ;
}


#define ROWHEIGHT  105.0f
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROWHEIGHT  ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // can be select
    if (_LookOrSelect)
    {
        for (Coupon *aCoup in _coupsonList)
        {
            aCoup.isChoosen = NO ;
        }
        
        Coupon *coup = (Coupon *)_coupsonList[indexPath.row]        ;
        coup.isChoosen = YES ;
        
        [self.delegate sendSelectedCousonList:_coupsonList]         ;
        
        [self.navigationController popViewControllerAnimated:YES ]  ;
    }
    
}

// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_LookOrSelect)
    {
        CoupsonWriteView *coupsonWriteV = (CoupsonWriteView *)[[[NSBundle mainBundle] loadNibNamed:@"CoupsonWriteView" owner:self options:nil] lastObject] ;
        coupsonWriteV.delegate = self ;
        return coupsonWriteV ;
    }
    else
    {
        UIView *view         = [[UIView alloc] init] ;
        view.backgroundColor = nil ;
        
        return view;
    }
    
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_LookOrSelect) {
        return 70.0f ;
    }
    
    return 5.0f ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view         = [[UIView alloc] init] ;
    view.backgroundColor = nil ;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f ;
}


#pragma mark --
#pragma mark - CoupsonWriteViewDelegate
- (void)sendCoupsonCode:(NSString *)coupsonCode
{
    NSLog(@"我的优惠码 : %@",coupsonCode) ;
    
    ResultPasel *result = [ServerRequest useCoupsonCodeInOrderConfrimWithCoupsonCode:coupsonCode AndWithCidsList:_cidLists] ;
    
    if (result.code == 200)
    {
        //  优惠券兑换成的钱
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COUPSON_CODE object:coupsonCode userInfo:(NSDictionary *)result.data] ;
        
        //
        [self.navigationController popViewControllerAnimated:YES] ;
    }
    else
    {
        NSString *showStr = (result.info) ? result.info : WD_HUD_BADNETWORK ;
        [DigitInformation showWordHudWithTitle:showStr] ;
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
