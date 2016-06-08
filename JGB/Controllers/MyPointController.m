//
//  MyPointController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MyPointController.h"
#import "PointHeadView.h"
#import "PointCell.h"
#import "ServerRequest.h"
#import "YXSpritesLoadingView.h"
#import "Score.h"
#import "NSObject+MKBlockTimer.h"

#define MY_PAGE_SIZE    20

@interface MyPointController ()
{
    NSMutableArray     *m_arr_datasource   ;
    int                 m_currentPage       ;
    
    int                 m_allScore          ;//总积分
    
    PointHeadView       *m_headView ;
}
@end

@implementation MyPointController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (void)setBackground
{
    if (!m_arr_datasource.count)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:_table.frame] ;
        imgView.image = [UIImage imageNamed:@"noPoints.png"] ;
        imgView.contentMode = UIViewContentModeScaleAspectFit ;
        [_table setBackgroundView:imgView] ;
    }
    else
    {
        [_table setBackgroundView:nil] ;
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//  EGORefreshTableFooterView
    [self setEGOfooter] ;
    
//    
    m_arr_datasource        = [NSMutableArray array] ;
    
    _table.separatorStyle   = UITableViewCellSeparatorStyleNone ;
    _table.backgroundColor  = [UIColor whiteColor] ;
    
    m_currentPage   = 1 ;
    m_allScore      = 0 ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        ResultPasel *result = [ServerRequest getMyPointsWithPage:m_currentPage AndWithSize:MY_PAGE_SIZE] ;
        
        if (result.code == 200)
        {
            NSDictionary *tempDic = result.data ;
            
            m_allScore = [[tempDic objectForKey:@"credit"] intValue] ;
            
            if (![[tempDic objectForKey:@"list"] isKindOfClass:[NSNull class]])
            {
                NSArray *list = [tempDic objectForKey:@"list"] ;
                
                for (NSDictionary *dic in list)
                {
                    Score *aScore = [[Score alloc] initWithDic:dic] ;
                    [m_arr_datasource addObject:aScore] ;
                }
            }
        }

    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        [_table reloadData] ;
        
        [self setRefreshViewFrameWithForceHeight:0] ;
        
        [self setBackground] ;
        
    } AndWithMinSec:0] ;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
        
        ResultPasel *result = [ServerRequest getMyPointsWithPage:m_currentPage AndWithSize:MY_PAGE_SIZE] ;
        
        if ( (result.code != 200) || ([[result.data objectForKey:@"list"] isKindOfClass:[NSNull class]])  )
        {
            hasNew = NO ;
        }
        else
        {

            NSDictionary *tempDic = result.data ;
            
            m_allScore = [[tempDic objectForKey:@"credit"] intValue] ;
            
            if (![[tempDic objectForKey:@"list"] isKindOfClass:[NSNull class]])
            {
                NSArray *list = [tempDic objectForKey:@"list"] ;
                
                for (NSDictionary *dic in list)
                {
                    Score *aScore = [[Score alloc] initWithDic:dic] ;
                    [m_arr_datasource addObject:aScore] ;
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
        [self.table scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionNone animated:YES] ;
    }
    
    [self setBackground] ;
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
    
    return [m_arr_datasource count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row ;
    
    static NSString *TableSampleIdentifier = @"PointCell";
    PointCell *cell = (PointCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil)
    {
        cell = (PointCell *)[[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    cell.theScore = (Score *)[m_arr_datasource objectAtIndex:row] ;
    
    if (row == 0)
    {
        cell.pointMode = isUp ;
    }
    else if (row == m_arr_datasource.count - 1)
    {
        cell.pointMode = isBottom ;
    }
    else
    {
        cell.pointMode = isMiddle ;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ; //选中无背景色
    
    return cell ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50 ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!m_headView)
    {
        m_headView = (PointHeadView *)[[[NSBundle mainBundle] loadNibNamed:@"PointHeadView" owner:self options:nil] objectAtIndex:0] ;
    }
    m_headView.lb_points.text       = [NSString stringWithFormat:@"%d",m_allScore] ;
    m_headView.lb_points.textColor  = COLOR_PINK ;
    
    return m_headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;
    return backView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f ;
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
