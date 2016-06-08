//
//  CataSecondController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-29.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CataSecondController.h"
#import "CategoryTB.h"
#import "SalesCatagory.h"
#import "SecCataCollectionCell.h"
#import "ColorsHeader.h"
#import "CataSubController.h"
#import "NavSearchController.h"
#import "SearchViewController.h"
#import "CataLeftCell.h"
#import "LSCommonFunc.h"
#import "HotSearch.h"
#import "YXSpritesLoadingView.h"
#import "DigitInformation.h"
#import "CataSecTrdCell.h"

#define NOTIFICATION_GOTO_SEARCH    @"NOTIFICATION_GOTO_SEARCH"



@interface CataSecondController () <CataSecTrdCellDelegate>
{
    NSMutableArray *m_cataFirstList     ;
    NSMutableArray *m_cataSecondList    ;
    NSMutableArray *m_cataThirdList     ;
    
    int             m_leftSelected      ;    // select present left cell from left table view
    
}
@end

@implementation CataSecondController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {

    }
    return self;
}

- (void)dealloc
{
    
}

- (void)setup
{
    m_cataFirstList = [NSMutableArray array] ;
    m_cataFirstList = [[CategoryTB shareInstance] getAllWithParentId:0];
    
    m_leftSelected = 0 ;
    
    int index = 0 ;
    for (SalesCatagory *cataFirst in m_cataFirstList)
    {
        if ([cataFirst.name isEqualToString:_currentCata.name])
        {
            m_leftSelected = index ;
            break ;
        }
        index ++ ;
    }
    
    
    m_cataSecondList = [NSMutableArray array] ;
    SalesCatagory *firstTwoLvlSubCata = (SalesCatagory *)[m_cataFirstList objectAtIndex:m_leftSelected] ;
    m_cataSecondList = [[CategoryTB shareInstance] getAllWithParentId:firstTwoLvlSubCata.id_] ;
    
    
    
}

- (void)initialTables
{
    _leftTable.delegate = self ;
    _leftTable.dataSource = self ;
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _leftTable.backgroundColor = COLOR_BACKGROUND ;
    
    _rightTable.showsVerticalScrollIndicator = NO ;
    _rightTable.dataSource = self ;
    _rightTable.delegate =self ;
}

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    // Do any additional setup after loading the view.
    
    [self initialTables] ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        [SalesCatagory setupCataIfNeeded] ;
        [self setup] ;

    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss]  ;
        
        [_leftTable         reloadData] ;
        [_rightTable        reloadData] ;
        
    } AndWithMinSec:0] ;
    
    self.title = @"分类" ;
    

    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSearch:) name:NOTIFICATION_GOTO_SEARCH object:nil] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GOTO_SEARCH object:nil] ;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --


#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == _leftTable) {
        return 1 ;
    } else {
        return [m_cataSecondList count] ;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == _leftTable) {
        return [m_cataFirstList count] ;
    } else {
        return 1 ;
    }
}


#define TAG_LEFTSELECTVIEW  879114
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable) {
        static NSString *CellIdentfier = @"CataLeftCell";
        CataLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
        if (cell == nil)
        {
            cell = [[CataLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        cell.isSelected = (indexPath.row == m_leftSelected) ;
        cell.name = ((SalesCatagory *)(m_cataFirstList[indexPath.row])).name ;
        
        return cell;
    } else {
        static NSString *CellIdentfier = @"CataSecTrdCell";
        CataSecTrdCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentfier owner:self options:nil] firstObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        SalesCatagory *currentSecCata = (SalesCatagory *)[m_cataSecondList objectAtIndex:indexPath.section] ;
        cell.lb_title.text = currentSecCata.name ;
        cell.cataList = [[self class] getAllThirdCataListWithCata:currentSecCata] ;
        cell.delegate = self ;
        cell.sec = indexPath.section ;
        
        int backIndex = indexPath.section % 2 ;
        cell.backgroundColor = backIndex ? [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:0.5] : [UIColor whiteColor] ;

        return cell;
    }
    
    return nil ;
}

+ (NSArray *)getAllThirdCataListWithCata:(SalesCatagory *)cata
{
    NSMutableArray *list = [[CategoryTB shareInstance] getAllWithParentId:cata.id_] ;
    SalesCatagory *tempCata = [[SalesCatagory alloc] initWithCata:cata] ;
    tempCata.name = @"全部" ;
    [list insertObject:tempCata atIndex:0] ;
    
    return list ;
}

- (void)myAnimation
{
    float duration = 0.30f ;
    
    // Animation
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_rightTable cache:NO];
    [UIView commitAnimations];
    
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable)
    {
        [self myAnimation] ;
        
        SalesCatagory *cata = (SalesCatagory *)[m_cataFirstList objectAtIndex:indexPath.row]   ;
        
        [m_cataSecondList removeAllObjects]                                                    ;
        m_cataSecondList = [[CategoryTB shareInstance] getAllWithParentId:cata.id_]            ;
        m_leftSelected = indexPath.row      ;
        [_leftTable reloadData]             ;
        [_rightTable reloadData]        ;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable)
    {
        return CELL_HEIGHT_LEFT ;
    }
    else
    {
        SalesCatagory *currentSecCata = (SalesCatagory *)[m_cataSecondList objectAtIndex:indexPath.section] ;
        NSArray *tempCataList = [[self class] getAllThirdCataListWithCata:currentSecCata] ; ;
        int lines = (tempCataList.count % 3 == 0) ? tempCataList.count / 3 : (tempCataList.count / 3 + 1) ;
        return 115.0f + lines * 70.0f - 70.0f ;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *back            = [[UIView alloc] init];
    back.backgroundColor    = nil ;
    
    return back;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *back            = [[UIView alloc] init];
    back.backgroundColor    = nil ;
    
    return back;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _leftTable)
    {
        return 10.0f ;
    }
    
    return 1.0f;
}



#pragma mark --
#pragma mark - actions
- (IBAction)searchBarButtonClickedAction:(id)sender
{
    [LSCommonFunc popModalSearchViewWithCurrentController:self] ;
}


#pragma mark --
#pragma mark - notification
- (void)postSearch:(NSNotification *)notification
{
    UIStoryboard         *story         = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    SearchViewController *searchVC      = [story instantiateViewControllerWithIdentifier:@"SearchViewController"] ;
    searchVC.hotSearch = (HotSearch *)notification.object ;

    [searchVC setHidesBottomBarWhenPushed:YES] ;
    [self.navigationController pushViewController:searchVC animated:YES] ;
}

#pragma mark --
#pragma mark - CataSecTrdCellDelegate
- (void)pressedCataCallBack:(SalesCatagory *)cata
{
    UIStoryboard         *story         = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    SearchViewController *searchVC      = [story instantiateViewControllerWithIdentifier:@"SearchViewController"] ;
    searchVC.myCata = cata ;
    [searchVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchVC animated:YES] ;
}


#pragma mark --
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];

//    if ([segue.identifier isEqualToString:@"cataSec2cataSub"])
//    {
//        CataSubController *cataSubCtrl = (CataSubController *)[segue destinationViewController] ;
//        cataSubCtrl.myCata = (SalesCatagory *)sender ;
//    }
    
}

@end
