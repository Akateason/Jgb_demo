//
//  CataSubController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CataSubController.h"
#import "CategoryTB.h"
#import "SearchViewController.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "LSCommonFunc.h"
#import "CataLeftCell.h"
#import "HotSearch.h"

#define NOTIFICATION_GOTO_SEARCH    @"NOTIFICATION_GOTO_SEARCH"

@interface CataSubController ()
{
    NSMutableArray *m_leftDS   ;
    NSMutableArray *m_rightDS  ;
    
    int             m_leftSelected ;
}
@end

@implementation CataSubController

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
//    
//    self.title = _myCata.name ;
    self.myTitle = @"二级到三级分类" ;
    
    [self setup] ;
//
    [self setMyTables] ;

}

#pragma mark --
#pragma mark -
- (void)setup
{
    m_leftSelected = 0 ;
    
    m_leftDS    = [NSMutableArray array] ;
    m_rightDS   = [NSMutableArray array] ;
    
    m_leftDS    = [[CategoryTB shareInstance] getAllWithParentId:_myCata.parent_id] ;
    m_rightDS   = [[CategoryTB shareInstance] getAllWithParentId:_myCata.id_] ;
    
    int index = 0 ;
    for (SalesCatagory *cate in m_leftDS)
    {
        if (cate.id_ == _myCata.id_)
        {
            m_leftSelected = index ;
            break ;
        }
        
        index ++ ;
    }
    
    // get parent cata name
    SalesCatagory *parentCataOfLeftFirst = (SalesCatagory *)[m_leftDS firstObject] ;
    [m_rightDS insertObject:parentCataOfLeftFirst atIndex:0] ;
    
//    self.title = parentCata.name ;
}

- (void)setMyTables
{

    
    _tableRight.delegate    = self ;
    _tableRight.dataSource  = self ;
    _tableLeft.delegate     = self ;
    _tableLeft.dataSource   = self ;
    _tableLeft.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _tableLeft.backgroundColor = COLOR_BACKGROUND ;
    
    
    _tableLeft.showsVerticalScrollIndicator  = NO ;
    _tableRight.showsVerticalScrollIndicator = NO ;
    
    _tableRight.separatorStyle = UITableViewCellSeparatorStyleNone ;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark --
#pragma mark - notification
- (void)postSearch:(NSNotification *)notification
{
    UIStoryboard         *story         = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    SearchViewController *searchVC      = [story instantiateViewControllerWithIdentifier:@"SearchViewController"] ;
    
    HotSearch *hotsch = (HotSearch *)notification.object ;
    searchVC.hotSearch = hotsch ;
    [self.navigationController pushViewController:searchVC animated:YES] ;
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
    // Return the number of rows in the section.
    if (tableView == _tableLeft)
    {
        return [m_leftDS count]     ;
    }
    else if (tableView == _tableRight)
    {
        return [m_rightDS count]    ;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    if (tableView == _tableLeft)
    {
        static NSString *CellIdentfier = @"CataLeftCell";
        CataLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
        if (cell == nil) {
            cell = [[CataLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        SalesCatagory *cata = (SalesCatagory *)[m_leftDS objectAtIndex:indexPath.row] ;
        cell.name = cata.name ;
        cell.isSelected = (m_leftSelected == indexPath.row) ;
        
        return cell;
    }
    else if (tableView == _tableRight)
    {
        static NSString *CellIdentfier = @"subCataCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        for (UIView *sub in cell.contentView.subviews)
        {
            [sub removeFromSuperview] ;
        }
        
        SalesCatagory *cata = (SalesCatagory *)[m_rightDS objectAtIndex:indexPath.row] ;
        cell.textLabel.text = (!indexPath.row) ? @"全部" : cata.name ;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f] ;
        cell.textLabel.textAlignment = NSTextAlignmentCenter        ;
        cell.textLabel.textColor = [UIColor darkGrayColor] ;
        cell.contentView.backgroundColor = [UIColor whiteColor]   ;
        
        return cell;
    }
    
    return nil;
}


- (void)myAnimation
{
    float duration = 0.30f ;
    
// Animation
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft    forView:self.tableRight cache:NO];
    [UIView commitAnimations] ;
    
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableLeft)
    {
        SalesCatagory *cata = (SalesCatagory *)[m_leftDS objectAtIndex:indexPath.row]   ;
        [m_rightDS removeAllObjects]                                                    ;
        m_rightDS = [[CategoryTB shareInstance] getAllWithParentId:cata.id_]            ;
        m_leftSelected = indexPath.row                                                  ;
        
        SalesCatagory *parentCata = (SalesCatagory *)m_leftDS[m_leftSelected]           ; //[[CategoryTB shareInstance] getCataWithCataID:_myCata.parent_id] ;
        [m_rightDS insertObject:parentCata atIndex:0] ;

        [self myAnimation]                                                              ;
        
        [_tableLeft  reloadData]                                                        ;
        [_tableRight reloadData]                                                        ;
    }
    else if (tableView == _tableRight)
    {
        SalesCatagory *cata = (SalesCatagory *)[m_rightDS objectAtIndex:indexPath.row]  ;
        [self performSegueWithIdentifier:@"catasub2search" sender:cata]                 ;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableLeft) {
        return CELL_HEIGHT_LEFT ;
    }else if (tableView == _tableRight) {
        return 40 ;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getEmpty] ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self getEmpty] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _tableLeft)
    {
        return 10.0f;
    }
    
    return 1.0f ;
}

- (UIView *)getEmpty
{
    UIView *back            = [[UIView alloc] init];
    back.backgroundColor    = [UIColor clearColor] ;
    return back;
}

#pragma mark --
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SearchViewController *searchVC = (SearchViewController *)[segue destinationViewController] ;
    searchVC.myCata = (SalesCatagory *)sender ;
}

#pragma mark --
- (IBAction)searchBarButtonClickedAction:(id)sender
{
    [LSCommonFunc popModalSearchViewWithCurrentController:self] ;
}


@end
