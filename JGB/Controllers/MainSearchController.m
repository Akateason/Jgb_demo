//
//  MainSearchController.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-2-17.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "MainSearchController.h"
#import "SearchHistoryTB.h"
#import "HistoryHotCell.h"
#import "HeadView_history.h"
#import "SearchViewController.h"
#import "HotSearchCell.h"
#import "UIImage+AddFunction.h"
#import "CatagoryCell.h"
#import "CategoryTB.h"
#import "ServerRequest.h"
#import "HotSearch.h"
#import "YXSpritesLoadingView.h"

#define TABLE_CATAGORY_HEIGHT 60.0f

#define NOTIFICATION_GOTO_SEARCH    @"NOTIFICATION_GOTO_SEARCH"


@interface MainSearchController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,HistoryHotCellDelegate,HeadViewHistoryDelegate,UIAlertViewDelegate,HotSearchCellDelegate>
{
    NSMutableArray      *m_arr_history ;
    NSArray             *m_dataSource ;

    NSString            *m_name ;
    
    BOOL                m_bShowHistory ;
    
    NSArray             *m_hotSearchList ;
}
@end

@implementation MainSearchController


- (void)setViewStyle
{
    _searchBar.delegate = self ;
    _table.delegate     = self ;
    _table.dataSource   = self ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)] ;

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    m_name = @"" ;
    

    [self setViewStyle] ;
    
    m_bShowHistory = NO ;

    [_searchBar becomeFirstResponder] ;
    //
    m_hotSearchList = [NSArray array] ;
    //
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        // get cata
        [self setTableViewDatas] ;
        // get history
        [self getHistoryList] ;
        // get hot search list
        m_hotSearchList = [DigitInformation shareInstance].g_hotSearchList ;

    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        if (!m_bShowHistory)
        {
            HotSearchCell *cell = (HotSearchCell *)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
            [cell.collectionView reloadData] ;
        }
        [_table reloadData] ;

    } AndWithMinSec:0] ;
    
}

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
    
}


- (void)getHistoryList
{
    m_arr_history = [NSMutableArray array] ;

    
    NSArray *arr = [[SearchHistoryTB shareInstance] getAll] ;
    for (SchHistory *aHistory in arr)
    {
        [m_arr_history addObject:aHistory.searchString] ;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark - action
- (void)backAction
{
    [self dismissViewControllerAnimated:YES
                             completion:nil] ;
}

#pragma mark --
#pragma mark - Search Bar Delegate
// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES ;
    CGRect tempRect = _searchBackView.frame ;
    tempRect.size.width = 300 ;
    _searchBackView.frame = tempRect ;
    
    // reset data source
    [m_arr_history removeAllObjects] ;
    
    NSMutableArray *arr = [[SearchHistoryTB shareInstance] getAll] ;
    
    for (SchHistory *his in arr)
    {
        [m_arr_history addObject:his.searchString] ;
    }
    
    m_bShowHistory = YES ;
    
    [_table reloadData] ;

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar                       // called when text ends editing
{
    searchBar.showsCancelButton = NO ;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if ( (searchBar.text == nil) || ([searchBar.text isEqualToString:@""]) )
    {
        [_table reloadData] ;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    
    _searchBar.showsCancelButton = NO ;
    if ( ([searchBar.text isEqualToString:@""]) || (!searchBar.text) ) return ;
    
    HotSearch *hotSearch = [[HotSearch alloc] init] ;
    hotSearch.type = typeKeywords ;
    hotSearch.name = _searchBar.text ;
    hotSearch.value = _searchBar.text ;
    [self postNotificationForSearchWithHotSearch:hotSearch] ;
    
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [_searchBar resignFirstResponder]   ;

    m_bShowHistory = NO ;
    [_table reloadData] ;
    
    searchBar.showsCancelButton = NO    ;
    [self searchBar:self.searchBar textDidChange:nil];

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
    if (m_bShowHistory) {
        //搜索历史
        return m_arr_history.count ;
    }
    else
    {
        return [m_dataSource count] + 1     ;
    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_bShowHistory) {
        //搜索历史
        HistoryHotCell *cell = (HistoryHotCell *)[tableView dequeueReusableCellWithIdentifier:@"HistoryHotCell"];
        if (cell == nil)
        {
            cell = (HistoryHotCell *)[[[NSBundle mainBundle] loadNibNamed:@"HistoryHotCell" owner:self options:nil] objectAtIndex:0];
        }
        NSString *schStr = [m_arr_history objectAtIndex:indexPath.row] ;
        cell.lb.text = schStr;
        cell.lb.textColor    = [UIColor darkGrayColor] ;
        cell.delegate = self ;
        
        cell.selectionStyle = 0 ;
        
        return cell;
    }
    else
    {
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
            
            cell.selectionStyle = 0 ;
            
            cell.hotSearchList = m_hotSearchList ;
            
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
    }
    
    return nil ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (m_bShowHistory)
    {
        //  搜索历史
        if ([_searchBar isFirstResponder])
        {
            [_searchBar resignFirstResponder];
        }
        //  go to search result , goods list
        NSString *title = [m_arr_history objectAtIndex:indexPath.row] ;
        _searchBar.text = title ;
        
        HotSearch *hotsear = [[HotSearch alloc] init] ;
        hotsear.type = typeKeywords ;
        hotsear.name = title ;
        hotsear.value = title ;
        
        [self postNotificationForSearchWithHotSearch:hotsear] ;
    }
    else
    {
        // 类目
        if (!indexPath.row) return ; // 热门
        
        NSLog(@"indexPath.row : %d",indexPath.row) ;
        SalesCatagory *cata = (SalesCatagory *)[m_dataSource objectAtIndex:(indexPath.row - 1)]   ;
        
        [self postNotificationForCata:cata] ;
    }

}

//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_bShowHistory)
    {
        return 35.0f ;
    }
    else
    {
        if (indexPath.row == 0)
        {
            int   lineNum   = 0         ;
            float tempLine  = 0.0       ;
            for (int i = 0; i < m_hotSearchList.count; i++)
            {
                HotSearch *hotsearch = (HotSearch *)m_hotSearchList[i]   ;
                NSString *wordName = hotsearch.name ;
                UIFont *font = [UIFont systemFontOfSize:WORD_LABEL_FONT] ;
                CGSize size = CGSizeMake(291,21)    ;
                CGSize labelsize = [wordName sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap]        ;
                
                float widTemp = labelsize.width + 16.0f ;
                tempLine += (widTemp + 10);
                if (tempLine - 10 > 291 - 10)
                {
                    lineNum ++ ;
                    tempLine = widTemp + 10 ;
                }
                if ((i == m_hotSearchList.count - 1)&&(tempLine > 0))
                {
                    lineNum ++ ;
                }
            }
            
            NSLog(@"%d line",lineNum) ;
            
            return  95 - 20 + lineNum * (20 + 10) ;//WORD_CELL_HEIGHT ;
        }
        else if (indexPath.row >= 1)
        {
            return TABLE_CATAGORY_HEIGHT ;
        }
    }
    
    return 0 ;
}

#define TABLEHEADHEIGHT     40.0f

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (m_bShowHistory) {
        NSArray *nibs1 = [[NSBundle mainBundle] loadNibNamed:@"HeadView_history" owner:self options:nil];
        HeadView_history *historyV = (HeadView_history *)[nibs1 objectAtIndex:0];
        historyV.lb1.text = @"搜索历史";  //"搜索历史记录
        historyV.delegate = self ;
        
        return historyV ;
    }
    else {
        UIView *back            = [[UIView alloc] init];
        back.backgroundColor    = [UIColor clearColor] ;
        return back;
    }

    return nil ;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (m_bShowHistory)
    {
        return TABLEHEADHEIGHT ;
    }

    return 1 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *back            = [[UIView alloc] init];
    back.backgroundColor    = [UIColor clearColor] ;
    return back;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

#define TAG_ALERT_ALL_HISTORY       32101
#define TAG_ALERT_SINGE_HISTORY     32102

#pragma mark - HeadViewHistoryDelegate
- (void)deleteAllHistoryCallBack
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清空我的搜索历史?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil] ;
    alert.tag = TAG_ALERT_ALL_HISTORY ;
    [alert show] ;
}



#pragma mark --
#pragma mark - HistoryHotCellDelegate
- (void)deleteHistoryStringName:(NSString *)name
{
    m_name = name ;
    
    NSString *deleteNameStr = [NSString stringWithFormat:@"确认要删除'%@'?",name] ;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除历史" message:deleteNameStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil] ;
    alert.tag = TAG_ALERT_SINGE_HISTORY ;
    [alert show] ;
}

#pragma mark --
#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) return ;
    
    if (alertView.tag == TAG_ALERT_ALL_HISTORY)
    {
        [self delAllHistory] ;
    }
    else if (alertView.tag == TAG_ALERT_SINGE_HISTORY)
    {
        [self deleteSingleHistory] ;
    }
    
}

- (void)deleteSingleHistory
{
    dispatch_queue_t queue = dispatch_queue_create("delSingleHistory", NULL) ;
    dispatch_async(queue, ^{
        
        BOOL success = [[SearchHistoryTB shareInstance] deleteName:m_name] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success)
            {
                [m_arr_history removeAllObjects] ;
                
                [self getHistoryList] ;
                
                [_table reloadData] ;
            }
        }) ;
        
    }) ;
}

- (void)delAllHistory
{
    [[SearchHistoryTB shareInstance] deleteAllFromSearchHistoryTB] ;
    [m_arr_history removeAllObjects] ;
    [_table reloadData] ;
}


#pragma mark --
#pragma mark - post notificaiton
- (void)postNotificationForSearchWithHotSearch:(HotSearch *)hotsearch
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOTO_SEARCH object:hotsearch] ;

    }] ;
}

- (void)postNotificationForCata:(SalesCatagory *)cata
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        HotSearch *hotsearch = [[HotSearch alloc] init] ;
        hotsearch.type = typeCatagory ;
        hotsearch.name = cata.name ;
        hotsearch.value = [NSString stringWithFormat:@"%d",cata.id_] ;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOTO_SEARCH object:hotsearch] ;
        
    }] ;
}


#pragma mark --
#pragma mark - HotSearchCellDelegate
- (void)sendHotsearchObj:(HotSearch *)hotsearch
{
    
    [self postNotificationForSearchWithHotSearch:hotsearch] ;
    
}


@end
