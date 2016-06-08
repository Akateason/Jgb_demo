//
//  CommentListController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CommentListController.h"
#import "CommentListCell.h"
#import "HMSegmentedControl.h"
#import "ServerRequest.h"
#import "ListComment.h"
#import "GoodsDetailViewController.h"
#import "CommentViewController.h"
#import "DigitInformation.h"
#import "YXSpritesLoadingView.h"
#import "NSObject+MKBlockTimer.h"

#define MY_PAGE_SIZE    20

@interface CommentListController () <CommentListCellDelegate,HMSegmentedControlDelegate>
{
    NSMutableArray                  *m_datasourceArray ;
    
    int                             m_currentPage      ;
}

@end

@implementation CommentListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)setEGOfooter
{
    refreshView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero];
    refreshView.delegate = self;
    [self.table addSubview:refreshView];
    reloading = NO;
    [self setRefreshViewFrameWithForceHeight:APPFRAME.size.height - 64] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
// Do any additional setup after loading the view.


    
    //  EGORefreshTableFooterView
    [self setEGOfooter] ;
    
    
    _table.backgroundColor = COLOR_BACKGROUND ;
    _table.separatorStyle  = UITableViewCellSeparatorStyleNone ;
    
    m_currentPage = 1 ;
    
    m_datasourceArray = [NSMutableArray array] ;
    
    
    __block ResultPasel *result ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    
    [DigitInformation showHudWhileExecutingBlock:^{
        
        result = [ServerRequest getMyAllCommentListWithPage:m_currentPage AndWithSize:MY_PAGE_SIZE] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        if ( result.code == 200 )
        {
            NSArray *tempCmtList = result.data ;
            
            if ([tempCmtList isKindOfClass:[NSNull class]])
            {
                self.isNothing = YES ;
                return ;
            }
            
            for (NSDictionary *tempDic in tempCmtList)
            {
                ListComment *comment = [[ListComment alloc] initWithDic:tempDic] ;
                [m_datasourceArray addObject:comment] ;
            }
            
            [_table reloadData] ;
            
            [self setRefreshViewFrameWithForceHeight:0.0f] ;
        }
        
    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
   
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning] ;
    // Dispose of any resources that can be recreated.
}


/*
//1 .   setSegment
- (void)setSegment
{
    NSArray *seg_list = [NSMutableArray arrayWithArray:@[@"全 部", @"已评价"]];
    m_sg          = [[HMSegmentedControl alloc] initWithSectionTitles:seg_list];
    m_sg.delegate = self ;
    [m_sg setSelectionIndicatorHeight:4.0f];
    [m_sg setBackgroundColor:[UIColor whiteColor]];
    [m_sg setTextColor:COLOR_PINK];                     //COLOR_PINK
    [m_sg setSelectionIndicatorColor:COLOR_PINK];
    [m_sg setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    [m_sg setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    [m_sg setFont:[UIFont boldSystemFontOfSize:15]] ;
    [m_sg addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged] ;
    m_sg.frame = CGRectMake(0, 0, _segView.frame.size.width, _segView.frame.size.height) ;
    [_segView addSubview:m_sg] ;
}
*/


#pragma mark - Refresh Table -
#pragma mark --
#pragma mark - refreshTableReloadData
//请求数据
- (void)refreshTableReloadData
{
    reloading = YES ;
    //新建一个线程来加载数据
    [NSThread detachNewThreadSelector:@selector(requestData)
                             toTarget:self
                           withObject:nil] ;
}

- (void)requestData
{
    //  m_currentSort ;
    __block BOOL hasNew = YES ;
    
    __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
        
        m_currentPage ++ ;
        
        ResultPasel *result = [ServerRequest getMyAllCommentListWithPage:m_currentPage AndWithSize:MY_PAGE_SIZE] ;
        
        if ( (result.code != 200) || (result.data == nil) || [result.data isKindOfClass:[NSNull class]] )
        {
            hasNew = NO ;
        }
        else
        {
            NSArray *tempCmtList = result.data ;
            if (! [tempCmtList count])
            {
                hasNew = NO ;
            }
            else
            {
                if ([tempCmtList isKindOfClass:[NSNull class]])
                {
                    self.isNothing = YES ;
                    return ;
                }
                
                for (NSDictionary *tempDic in tempCmtList)
                {
                    ListComment *comment = [[ListComment alloc] initWithDic:tempDic] ;
                    [m_datasourceArray addObject:comment] ;
                }
            }
            
        }
        
    } withPrefix:@"result time"] ;
    float sec = seconds / 1000.0f ;
    NSLog(@"sec : %lf",sec) ;
    if (sec < 1.5f)
    {
        sleep(1.5f - sec) ;
    }
    
    //在主线程中刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadUI:hasNew] ;
    }) ;
}

- (void)reloadUI:(BOOL)hasNew
{
    reloading = NO;
    
    [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    
    [self.table reloadData]             ;
    
    //先刷新table 再设frame
    [self setRefreshViewFrameWithForceHeight:0] ;
    
    if (hasNew)
    {
        int row = (m_currentPage - 1) * MY_PAGE_SIZE ;
        NSIndexPath *ipath = [NSIndexPath indexPathForRow:row inSection:0] ;
        [self.table scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:YES] ;
    }
}

#pragma mark --
#pragma mark - reSet refresh View frame
- (void)setRefreshViewFrameWithForceHeight:(float)forceHeight
{
    float height = 0 ;
    height = (!forceHeight) ? MAX(self.table.bounds.size.height, self.table.contentSize.height) : forceHeight ;
    
    //  如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    //    NSLog(@"self.tableCategory.bounds.size.height,%lf \tself.tableCategory.contentSize.height,%lf",self.tableCategory.bounds.size.height, self.tableCategory.contentSize.height) ;
    //    NSLog(@"height : %lf",height) ;
    refreshView.frame = CGRectMake(0.0f, height, self.view.frame.size.width, self.table.bounds.size.height);
}

#pragma mark - EGORefreshTableFooterDelegate
//出发下拉刷新动作，开始拉取数据
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)view
{
    [self refreshTableReloadData];
}

//返回当前刷新状态：是否在刷新
- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView*)view
{
    return reloading;
}

//返回刷新时间
- (NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view
{
    return [NSDate date];
}

#pragma mark --
#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
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
    
    return [m_datasourceArray count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"CommentListCell";

    CommentListCell *cell = (CommentListCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil)
    {
        cell = (CommentListCell *)[[[NSBundle mainBundle] loadNibNamed:@"CommentListCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.cmt    = m_datasourceArray[indexPath.row] ;
    
    cell.row = indexPath.row ;

    cell.delegate = self ;
    
    return cell ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103.0f ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //进入商品详情
    NSLog(@"进入商品详情") ;
    
    ListComment *cmt = (ListComment *)m_datasourceArray[indexPath.row]          ;

    [self performSegueWithIdentifier:@"commentlist2gooddetail" sender:cmt.code] ;
}


// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil  ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0    ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil  ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0    ;
}

/*
#pragma mark -- theSelectedSegment
- (void)theSelectedSegment:(int)seg
{
    m_currentPage = 1 ;
 
    //click self return
    __block ResultPasel *result ;
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        result = [ServerRequest getProductCommentListWithProCode:_productCode AndWithPage:m_currentSortPage AndWithSize:ONE_PAGE_SIZE AndWithScore:m_currenScoreArray] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        if (result.code == 200)
        {
            [m_commentDataSource removeAllObjects] ;
            
            NSArray *commentDicTempArray = (NSArray *)result.data ;
            
            if ([result.data isKindOfClass:[NSNull class]])
            {
                [_table reloadData] ;
                
                return ;
            }
            
            for (NSDictionary *dic in commentDicTempArray)
            {
                Comment *aComment = [[Comment alloc] initWithDictionary:dic] ;
                [m_commentDataSource addObject:aComment] ;
            }
            
            [_table reloadData] ;
            
        }
        
    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
 
}


#pragma mark --
#pragma - HMSegmentedControlDelegate sendCurrentIndex ↑↓
#pragma mark - seg value changed
- (void)valueChanged
{
    NSLog(@"m_sg.selectedIndex  :  %d",m_sg.selectedIndex ) ;

    [self theSelectedSegment:m_sg.selectedIndex]    ;
    

    switch (m_sg.selectedIndex)
    {
        case 0:
        {
            //全部
            m_currenScoreArray = @[@"0"] ;
        }
            break;
        case 1:
        {
            //喜欢
            m_currenScoreArray = @[@"4",@"5"] ;
        }
            break;
        case 2:
        {
            //一般
            m_currenScoreArray = @[@"2",@"3"] ;
        }
            break;
        case 3:
        {
            //不喜欢
            m_currenScoreArray = @[@"1"] ;
        }
            break;
        default:
            break;
    }

    
}


- (void)sendCurrentIndexEveryPressed:(int)seg
{
    // dont need implementation
}

*/

#pragma mark -- CommentListCellDelegate

- (void)pressedCommentButtonSendCellIndex:(int)index
{
    NSLog(@"点到哪个去评论的 index : %d" , index)  ;
    
    ListComment *cmt = (ListComment *)m_datasourceArray[index] ;
    
    [self performSegueWithIdentifier:@"commentlist2commentdetail" sender:cmt] ;
}




#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"commentlist2gooddetail"])
    {
        
        GoodsDetailViewController *detailVC = (GoodsDetailViewController *)[segue destinationViewController] ;
        detailVC.codeGoods = (NSString *)sender ;
        
    }
    else if ([segue.identifier isEqualToString:@"commentlist2commentdetail"])
    {
        CommentViewController *commentVC = (CommentViewController *)[segue destinationViewController] ;
        commentVC.cmt = (ListComment *)sender ;
    }
    
}



@end






