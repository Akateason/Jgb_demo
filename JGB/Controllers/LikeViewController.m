//
//  LikeViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "LikeViewController.h"
#import "LikeCell.h"
#import "ServerRequest.h"
#import "LikeProduct.h"
#import "GoodsDetailViewController.h"
#import "NSObject+MKBlockTimer.h"
#import "YXSpritesLoadingView.h"


@interface LikeViewController ()
{
    NSMutableArray *m_arr_datasource ;
    
    int             m_currentPage ;
}
@end

@implementation LikeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define LIKE_PAGE_SIZE          20


- (void)setViewStyle
{
    self.view.backgroundColor   = [UIColor whiteColor] ;
    _table.backgroundColor      = [UIColor whiteColor] ;
    
    _table.separatorStyle       = UITableViewCellSeparatorStyleSingleLine       ;
    

}


- (void)setBackgroundPic
{
    if (!m_arr_datasource.count) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:_table.frame] ;
        imgView.image = [UIImage imageNamed:@"nolike"] ;
        imgView.contentMode = UIViewContentModeScaleAspectFit ;
        _table.backgroundView = imgView ;
    } else {
        _table.backgroundView = nil ;
    }
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
    [super viewDidLoad] ;
    // Do any additional setup after loading the view.

//
    [self setViewStyle] ;
    
//  EGORefreshTableFooterView
    [self setEGOfooter] ;

//
    m_currentPage = 1 ;
    m_arr_datasource = [NSMutableArray array] ;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    
    [m_arr_datasource removeAllObjects] ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        ResultPasel *result = [ServerRequest getLikeListWithPage:m_currentPage AndWithSize:LIKE_PAGE_SIZE] ;
        
        if ( !( (result.code != 200) || ([result.data isKindOfClass:[NSNull class]]) ) )
        {
            NSArray *likeDicList = (NSArray *)result.data ;
            NSMutableArray *likeProlist = [NSMutableArray array] ;
            for (NSDictionary *diction in likeDicList)
            {
                LikeProduct *like = [[LikeProduct alloc] initWithDictionary:diction] ;
                [likeProlist addObject:like] ;
            }
            m_arr_datasource = likeProlist ;
        }
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        [_table reloadData] ;
        
        [self setRefreshViewFrameWithForceHeight:0] ;
        
        [self setBackgroundPic] ;
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
        
        ResultPasel *result = [ServerRequest getLikeListWithPage:m_currentPage AndWithSize:LIKE_PAGE_SIZE] ;

        if ( (result.code != 200) || ([result.data isKindOfClass:[NSNull class]]) )
        {
            hasNew = NO ;
        }
        else
        {
            NSArray *templist = (NSArray *)result.data ;
            for (NSDictionary *diction in templist)
            {
                LikeProduct *like = [[LikeProduct alloc] initWithDictionary:diction] ;
                [m_arr_datasource addObject:like] ;
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
        int row = (m_currentPage - 1) * LIKE_PAGE_SIZE ;
        NSIndexPath *ipath = [NSIndexPath indexPathForRow:row inSection:0] ;
        [self.table scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:YES] ;
    }
    
    [self setBackgroundPic] ;
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
    return m_arr_datasource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"LikeCell";
    LikeCell *cell = (LikeCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil)
    {
        cell = (LikeCell *)[[[NSBundle mainBundle] loadNibNamed:@"LikeCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.likePro = (LikeProduct *)m_arr_datasource[indexPath.row] ;
    
    return cell ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LikeProduct *like = (LikeProduct *)m_arr_datasource[indexPath.row] ;

    UIStoryboard                *story              = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    GoodsDetailViewController   *detailCtrller      = [story instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"] ;
    detailCtrller.codeGoods = like.product.code ;

    [self.navigationController pushViewController:detailCtrller animated:YES ] ;
}

// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *back            = [[UIView alloc] init] ;
    back.backgroundColor    = nil ;
    return back ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *back            = [[UIView alloc] init] ;
    back.backgroundColor    = nil ;
    return back ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f ;
}


#pragma mark -- Delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        int row      = indexPath.row ;
        
        LikeProduct *like = (LikeProduct *)m_arr_datasource[row] ;

        //  DEL DATA SOURCE FROM CLIENT AND SERVER
        [m_arr_datasource removeObjectAtIndex:row] ;

        //  DEL FROM VIEW
        //  DEL  TABLE VIEW CELL
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //  DEL DATA SOURCE FROM SERVER
        __block ResultPasel *result ;
        
        dispatch_queue_t queue = dispatch_queue_create("deleteLikeQueue", NULL) ;
        dispatch_async(queue, ^{
            
            result = [ServerRequest likeRemoveWithProductCode:like.product.code] ;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *strResult = result.info ? result.info : WD_HUD_BADNETWORK ;
                
                [DigitInformation showWordHudWithTitle:strResult] ;
                
                [self setBackgroundPic] ;

            }) ;
            
        }) ;
        

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
