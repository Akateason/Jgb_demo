//
//  CataOneController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-22.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CataOneController.h"
#import "CategoryTB.h"
#import "CataSubController.h"
#import "SalesCatagory.h"
#import "UIImage+AddFunction.h"
#import "SearchViewController.h"
#import "HotSearchCell.h"
#import "SearchHistoryTB.h" 
#import "HeadView_history.h"
#import "HistoryHotCell.h"
#import "CataSecondController.h"
#import "LSCommonFunc.h"

#define TABLE_CATAGORY_HEIGHT 60.0f

#define NOTIFICATION_GOTO_SEARCH    @"NOTIFICATION_GOTO_SEARCH"


@interface CataOneController ()<HeadViewHistoryDelegate,HistoryHotCellDelegate,HotSearchCellDelegate>
{
    NSArray             *m_dataSource ;
    
//    NSMutableArray      *m_arr_history   ;      //搜索历史
//    BOOL                m_willShowHistoryTable ;            //default is NO,
//    HeadView_history    *m_historyV         ;

}
@end

@implementation CataOneController

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
    [super viewDidLoad]             ;
    // Do any additional setup after loading the view.
   
    //
    [self setTableViewDatas]        ;
    //
    self.table.delegate   = self    ;
    self.table.dataSource = self    ;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    //
    //del back button
    self.isDelBarButton = YES       ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSearchText:) name:NOTIFICATION_GOTO_SEARCH object:nil] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GOTO_SEARCH object:nil] ;
}

#pragma mark --
#pragma mark - notification
- (void)postSearchText:(NSNotification *)notification
{
    NSString *searchText = (NSString *)notification.object ;
    
    [self performSegueWithIdentifier:@"cataone2searchvc" sender:searchText] ;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --
/*
 ** ReShow The Data ** 点击没有网络提醒的图片时, 重新刷数据 ,
 **/
- (void)reShowTheData
{
    [super reShowTheData] ;

    [self setTableViewDatas] ;
    
    [_table reloadData] ;
}

#pragma mark --
- (void)setTableViewDatas
{
    m_dataSource = [NSArray array] ;
    
    NSMutableArray *tempArr = [NSMutableArray array] ;
    NSArray *arr1 = [[CategoryTB shareInstance] getAllWithParentId:0];
    for (SalesCatagory *cata1 in arr1)
    {
        NSArray *arr2 = [[CategoryTB shareInstance] getAllWithParentId:cata1.id_] ;
        
        NSString *detail = @"" ;
        
        BOOL first = YES ;
        for (SalesCatagory *cata2 in arr2)
        {
            if (first) {
                detail = cata2.name ;
                first = NO ;
            }else {
                detail = [detail stringByAppendingString:[NSString stringWithFormat:@" %@",cata2.name]] ;
            }
        }
        
        cata1.remark = detail ;
        [tempArr addObject:cata1];
    }
    
    m_dataSource = tempArr ;
    
    self.isNothing = (! m_dataSource.count) ? YES : NO ;
}




#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1                            ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [m_dataSource count] + 1     ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    nomal
    if (indexPath.row == 0)
    {
        static NSString *CellIdentfier = @"HotSearchCell";
        HotSearchCell *cell = (HotSearchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentfier owner:self options:nil] objectAtIndex:0] ;
        }
        
        cell.delegate = self ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        cell.selectionStyle = 0             ;
        
        cell.contentList = @[@"尿裤",@"奶粉",@"女鞋",@"手表",@"包"] ; // 暂时?!?!?!!?!?!!?!?!?1
        
        return cell                         ;
    }
    else if (indexPath.row >= 1)
    {
        static NSString *CellIdentfier = @"CatagoryCell";
        CatagoryCell *cell = (CatagoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
        if (cell == nil)
        {
            cell = [[CatagoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
        }
        
        SalesCatagory *cata = (SalesCatagory *)[m_dataSource objectAtIndex:indexPath.row - 1]           ;
        cell.selectionStyle = 0             ;
        cell.img_catagory.image = [UIImage imageNamed:[NSString stringWithFormat:@"c%d",cata.id_]]  ;
        cell.lb_title.text  = cata.name     ;
        cell.lb_detail.text = cata.remark   ;
        
        return cell                         ;
    }
    
    return nil ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (!indexPath.row) return ; //   热门
    
    NSLog(@"indexPath.row : %d",indexPath.row) ;
    SalesCatagory *cata = (SalesCatagory *)[m_dataSource objectAtIndex:(indexPath.row - 1)]   ;
    
    [self performSegueWithIdentifier:@"cataOne2Sec" sender:cata]                    ;
    
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        return 95 ;
    }
    else if (indexPath.row >= 1)
    {
        return TABLE_CATAGORY_HEIGHT ;
    }
    
    return 0 ;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *back            = [[UIView alloc] init];
    back.backgroundColor    = [UIColor clearColor] ;
    return back;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *back            = [[UIView alloc] init];
    back.backgroundColor    = [UIColor clearColor] ;
    return back;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}



#pragma mark --
#pragma mark - HotSearchCellDelegate 
- (void)sendHotWord:(NSString *)hotWord
{
    
    UIStoryboard         *story         = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    SearchViewController *searchVC      = [story instantiateViewControllerWithIdentifier:@"SearchViewController"] ;
    searchVC.strBeSearch                = hotWord ;
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
    
    if ([segue.identifier isEqualToString:@"cataOne2Sec"])
    {
        CataSecondController *cataSecVC = (CataSecondController *)[segue destinationViewController] ;
        cataSecVC.currentCata = (SalesCatagory *)sender;
    }
    else if ([segue.identifier isEqualToString:@"cataone2searchvc"])
    {
        SearchViewController *searchVC      = (SearchViewController *)[segue destinationViewController] ;
        searchVC.strBeSearch                = (NSString *)sender ;
    }

}


- (IBAction)searchBarButtonClickedAction:(id)sender
{
    [LSCommonFunc popModalSearchViewWithCurrentController:self] ;
}

@end
