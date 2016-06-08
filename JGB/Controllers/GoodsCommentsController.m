//
//  GoodsCommentsController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-18.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "GoodsCommentsController.h"
#import "GoodCommentCell.h"
#import "HMSegmentedControl.h"
#import "ServerRequest.h"
#import "ResultPasel.h"
#import "Comment.h"
#import "Reply.h"
#import "CommentToolBar.h"
#import "YXSpritesLoadingView.h"
#import "EGORefreshTableFooterView.h"
#import "NSObject+MKBlockTimer.h"
#import "NavRegisterController.h"

#define ONE_PAGE_SIZE    20


@interface GoodsCommentsController () <HMSegmentedControlDelegate,GoodCommentCellDelegate,UITextViewDelegate,CommentToolBarDelegate,EGORefreshTableFooterDelegate>
{
    NSMutableArray                  *m_seg_list                 ;
    
    HMSegmentedControl              *m_sg                       ;
    
    NSMutableArray                  *m_commentDataSource        ;
    
    UITextView                      *m_txtView                  ;
    
    CommentToolBar                  *m_toolBar                  ;
    
    
    /*
     *  answer comment and reply
     */
    int                             m_lastSelectedCommentRow    ;  //前一个选中的评论row, default-1
    
    int                             m_currentCommentID          ;
    
    int                             m_currentReplyID            ;
    
    int                             m_lastSelectedReplyID       ;

    
    /*
     *  refresh view
     */
    EGORefreshTableFooterView       *refreshView                ;
    BOOL                            reloading                   ;

    /*
     *  sort
     */
    int                             m_currentSortPage           ;
    NSArray                         *m_currenScoreArray         ;   //  评级 1分=讨厌, 2,3分一般, 45分喜欢
}
@end

@implementation GoodsCommentsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//1 .   setSegment
/*
- (void)setSegment
{
    m_seg_list = [NSMutableArray arrayWithArray:@[@"全部", @"喜欢",@"一般",@"不喜欢"]];
    m_sg       = [[HMSegmentedControl alloc] initWithSectionTitles:m_seg_list];
    m_sg.delegate = self ;
    [m_sg setSelectionIndicatorHeight:4.0f];
    [m_sg setBackgroundColor:[UIColor whiteColor]];
    [m_sg setTextColor:COLOR_PINK];                     //COLOR_PINK
    [m_sg setSelectionIndicatorColor:COLOR_PINK];
    [m_sg setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    [m_sg setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    [m_sg setFont:[UIFont boldSystemFontOfSize:12.0f]] ;
    [m_sg addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged] ;
    m_sg.frame = CGRectMake(0, 0, _segView.frame.size.width, _segView.frame.size.height) ;
    [_segView addSubview:m_sg] ;
}
*/

- (void)setViewStyle
{
    // base view in window

    //1 .   setSegment
//  [self setSegment] ;
//    _headView.backgroundColor = COLOR_BACKGROUND ;
    
    //2 .
//    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    _table.separatorStyle   = UITableViewCellSeparatorStyleSingleLine ;
//    _table.separatorColor   = sepColor ;
    float wid = 0.0f ;
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:UIEdgeInsetsMake(0, wid, 0, wid)];
    }
    
    //3 .
    self.view.backgroundColor = COLOR_BACKGROUND ;
    _table.backgroundColor    = COLOR_BACKGROUND ;
    
    //4  EGORefreshTableFooterView
    refreshView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero];
    refreshView.delegate = self;
    [_table addSubview:refreshView];
    reloading = NO;
    
    [self setRefreshViewFrameWithForceHeight:APPFRAME.size.height] ;
}


- (void)setHiddenTextView
{
    m_txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] ;
    [self.view addSubview:m_txtView] ;
    m_txtView.delegate = self ;
    m_txtView.hidden = YES ;
    
    m_toolBar = (CommentToolBar *)[[[NSBundle mainBundle] loadNibNamed:@"CommentToolBar" owner:self options:nil] lastObject] ;
    m_toolBar.delegateComment = self ;
    
    m_txtView.inputAccessoryView = m_toolBar ;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
// 1 . style
    [self setViewStyle] ;

    // 2 . bar button add comment
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addComment"] style:UIBarButtonItemStylePlain target:self action:@selector(addComment)] ;
//    self.navigationItem.rightBarButtonItem = rightItem ;

// 3 . show hidden text view
    [self setHiddenTextView]        ;
    m_lastSelectedCommentRow = - 1  ;
    m_currentCommentID       = 0    ;
    m_currentReplyID         = 0    ;
    m_currentSortPage        = 1    ;

// 4 . get comment list from server
    __block ResultPasel *result ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
       
        m_commentDataSource = [NSMutableArray array] ;
        
        result = [ServerRequest getProductCommentListWithProCode:_productCode AndWithPage:m_currentSortPage AndWithSize:ONE_PAGE_SIZE AndWithScore:nil] ;
        
    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        if (result.code == 200)
        {
            NSArray *commentDicTempArray = (NSArray *)result.data ;
            if ([result.data isKindOfClass:[NSNull class]]) {
                return ;
            }
            
            for (NSDictionary *dic in commentDicTempArray)
            {
                Comment *aComment = [[Comment alloc] initWithDictionary:dic] ;
                [m_commentDataSource addObject:aComment] ;
            }
            
            [_table reloadData] ;
            [self setRefreshViewFrameWithForceHeight:0] ;
        }
        
    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
    


    
    
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- theSelectedSegment
- (void)theSelectedSegment:(int)seg
{
    m_currentSortPage = 1 ;
    
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
            [self setRefreshViewFrameWithForceHeight:0] ;
            
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
    
//  评级 1分=讨厌, 2,3分一般, 45分喜欢
    switch (m_sg.selectedIndex) {
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
    __block BOOL hasNew = NO ;
    
    __block unsigned int seconds = [self logTimeTakenToRunBlock:^{
        
        m_currentSortPage ++ ;

        ResultPasel *result = [ServerRequest getProductCommentListWithProCode:_productCode AndWithPage:m_currentSortPage AndWithSize:ONE_PAGE_SIZE AndWithScore:m_currenScoreArray] ;
        
        if (result.code != 200) return ;
        
        NSArray *commentDicTempArray = (NSArray *)result.data ;
        
        if ([result.data isKindOfClass:[NSNull class]]) return ;
        
        if (! commentDicTempArray.count) return ;
        
        for (NSDictionary *dic in commentDicTempArray)
        {
            Comment *aComment = [[Comment alloc] initWithDictionary:dic] ;
            [m_commentDataSource addObject:aComment] ;
        }
        
        hasNew = YES ;
        
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
    reloading = NO                              ;
    
    [refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_table]   ;
    
    [_table reloadData]                         ;
    
    [self setRefreshViewFrameWithForceHeight:0] ;
    
    if (hasNew)
    {
        int row = (m_currentSortPage - 1) * ONE_PAGE_SIZE                                                   ;

        if (m_commentDataSource.count - 1 < row) row = m_commentDataSource.count - 1                        ;
        
        NSIndexPath *ipath = [NSIndexPath indexPathForRow:row inSection:0]                                  ;
        
        [_table scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:YES]    ;
    }
}

#pragma mark --
#pragma mark - reSet refresh View frame
- (void)setRefreshViewFrameWithForceHeight:(float)forceHeight
{
    float height = 0 ;
    height = (!forceHeight) ? MAX(_table.bounds.size.height, _table.contentSize.height) : forceHeight ;
    //  如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    //    NSLog(@"self.tableCategory.bounds.size.height,%lf \tself.tableCategory.contentSize.height,%lf",self.tableCategory.bounds.size.height, self.tableCategory.contentSize.height) ;
    //    NSLog(@"height : %lf",height) ;
    refreshView.frame = CGRectMake(0.0f, height, self.view.frame.size.width, _table.bounds.size.height);
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
//此代理在scrollview滚动时就会调用
//在下拉一段距离到提示松开和松开后提示都应该有变化，变化可以在这里实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
}

//松开后判断表格是否在刷新，若在刷新则表格位置偏移，且状态说明文字变化为loading...
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
    
    return [m_commentDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"GoodCommentCell";
 
    GoodCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:TableSampleIdentifier bundle:nil] forCellReuseIdentifier:TableSampleIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate       = self ;

// content
    Comment *aComment   = (Comment *)[m_commentDataSource objectAtIndex:indexPath.row] ;
    cell.theComment     = aComment              ;
    cell.row            = indexPath.row         ;
        
    return cell ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *aComment        = (Comment *)[m_commentDataSource objectAtIndex:indexPath.row] ;
    float commentLabelHeight = [aComment getCommentLabelHeight] ;
    
    //无回复
    if (! aComment.replyCount)
    {
        return commentLabelHeight ;
    }
    
    //有回复
    float replyTableHeight = [aComment getReplyTableHeight] ;
    float height           = commentLabelHeight + replyTableHeight + 20; // + 4
    
    return height ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([m_txtView isFirstResponder])
    {
        [m_txtView resignFirstResponder] ;
        [self keyboardMoveUpDownWithPoint:CGPointZero] ;
    }
    
    
}


// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init] ;
    backView.backgroundColor = nil ;
    return backView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0 ;
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
    return 1.0 ;
}


#pragma mark --
#pragma mark - addComment
- (void)addComment
{
    NSLog(@"addComment") ;
}

#pragma mark --
#pragma mark - GoodCommentCellDelegate
// comment answer 晒单回复
- (void)commentAnswerButtonClickedWithCommentID:(int)commentID AndWithRow:(int)row
{
#pragma mark -- 暂时注销
    /*
    //当前选中的晒单id
    m_currentCommentID = commentID ;
    m_currentReplyID   = 0         ;
    
    NSLog(@"commentID %d",commentID) ;
    NSLog(@"row %d",row)             ;
    
    float moveUpHeight = - (64.0f + 50.0f) ;
    for (int i = row - 1 ; i >= 0 ; i--)
    {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0] ;
        moveUpHeight += [self tableView:_table heightForRowAtIndexPath:indexpath] ;
    }
    
    if (moveUpHeight <= 0) moveUpHeight = 0 ;
    
    if (commentID == m_lastSelectedCommentRow)
    {
        // show textView hidden , become first responder , show key board, and tool bar
        if ([m_txtView isFirstResponder])
        {
            [m_txtView resignFirstResponder] ;
            [self keyboardMoveUpDownWithPoint:CGPointZero] ;
        }
        else
        {
            [m_txtView becomeFirstResponder] ;
            [self keyboardMoveUpDownWithPoint:CGPointMake(0, - moveUpHeight)] ;
        }
    }
    else
    {
        [m_txtView becomeFirstResponder] ;
        [self keyboardMoveUpDownWithPoint:CGPointMake(0, - moveUpHeight)] ;
        
        m_txtView.text = @"" ;
        m_toolBar.tf_input.text = @"" ;
    }
    
    m_lastSelectedCommentRow = commentID ;
    
    m_toolBar.tf_input.placeholder = @"" ;
     */
#pragma mark -- 暂时注销
}


// reply answer 对回复的回复
- (void)replyAnswerCellSelectedWithCommentID:(int)commentID AndWithRow:(int)commentRow AndWithReplyID:(int)replyID AndWithReplyHeight:(float)height AndWithPlaceHolderStr:(NSString *)placeHolderStr
{
    #pragma mark -- 暂时注销
/*
    //当前选中的晒单id
    m_currentCommentID = commentID  ;
    m_currentReplyID   = replyID    ;
    
    NSLog(@"commentID %d",commentID)    ;
    NSLog(@"commentRow %d",commentRow)  ;
    NSLog(@"replyID %d",replyID)    ;
//    NSLog(@"replyRow %d",replyRow)  ;
    
    // comment move height
    float moveUpHeight = - (64.0f + 50.0f) ;
    for (int i = commentRow - 1 ; i >= 0 ; i--)
    {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0] ;
        moveUpHeight += [self tableView:_table heightForRowAtIndexPath:indexpath] ;
    }
    
    // reply table move height
    moveUpHeight += height ;
    
    //
    if (moveUpHeight <= 0) moveUpHeight = 0 ;
    //
    if (replyID == m_lastSelectedReplyID)
    {
        // show textView hidden , become first responder , show key board, and tool bar
        if ([m_txtView isFirstResponder])
        {
            [m_txtView resignFirstResponder] ;
            [self keyboardMoveUpDownWithPoint:CGPointZero] ;
        }
        else
        {
            [m_txtView becomeFirstResponder] ;
            [self keyboardMoveUpDownWithPoint:CGPointMake(0, - moveUpHeight)] ;
            
        }
    }
    else
    {
        [m_txtView becomeFirstResponder] ;
        [self keyboardMoveUpDownWithPoint:CGPointMake(0, - moveUpHeight)] ;
        m_txtView.text = @"" ;
        m_toolBar.tf_input.text = @"" ;
    }
    
    m_toolBar.tf_input.placeholder = [NSString stringWithFormat:@"回复 %@ :",placeHolderStr] ;
    
    m_lastSelectedReplyID = replyID ;
    */
    #pragma mark -- 暂时注销
}


// 用户未登录
- (void)userNotLoginCallBack
{
    [NavRegisterController goToLoginFirstWithCurrentController:self] ;
}



#pragma mark --
#pragma mark - keyboardMoveUpDownWithPoint
- (void)keyboardMoveUpDownWithPoint:(CGPoint)point
{
    if (!point.x && !point.y )
    {
        point = CGPointMake(0, 64.0f) ;
    }
    
    
    [UIView beginAnimations:@"ReturnKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f]  ;
    self.view.frame = CGRectMake(point.x, point.y, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations]           ;
}



#pragma mark --
#pragma mark - text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    m_toolBar.tf_input.text = textView.text ;
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![m_txtView isExclusiveTouch]) [m_txtView resignFirstResponder] ;
}

#pragma mark --
#pragma mark - CommentToolBarDelegate
- (void)sendMsg
{
    __block NSString *showInfo = WD_ALERT_SENDFAILURE ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        //1 send comment to server in asynic
        ResultPasel *result = [ServerRequest answerCommentWithContent:m_toolBar.tf_input.text AndWithCommentID:m_currentCommentID AndWithReplyID:m_currentReplyID] ;
        if (result.code == 200)
        {
            showInfo = result.info ;
        }
        
        
    } AndComplete:^{
        [YXSpritesLoadingView dismiss] ;
        
        
        //1
        if ([m_txtView isFirstResponder])
        {
            [m_txtView resignFirstResponder] ;
            [self keyboardMoveUpDownWithPoint:CGPointZero] ;
        }
        
        
        //2 show in alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:showInfo message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
        [alert show] ;
        
    } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
    
  
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
