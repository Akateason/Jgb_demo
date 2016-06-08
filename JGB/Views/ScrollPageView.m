//
//  ScrollPageView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ScrollPageView.h"
#import "ColorsHeader.h"
#import "HomePageView.h"
#import "LSCommonFunc.h"
#import "ActivityTableView.h"

@interface ScrollPageView () <HomePageViewDelegate>
{
    HomePageView                *m_homePage     ;
    NSMutableArray              *m_activeList   ;
}

@end

@implementation ScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        mNeedUseDelegate = YES;
        [self commInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        // Initialization code

        mNeedUseDelegate = YES ;
        
        [self commInit] ;
    }
    
    return self;
}

- (void)initData
{
    [self freshContentTableAtIndex:0 WithCurrentTag:0];
}


- (void)commInit
{
    m_activeList = [NSMutableArray array] ;
    
    if (_contentItems == nil)
    {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

        _scrollView.pagingEnabled = YES ;
        _scrollView.delegate = self     ;
        _scrollView.backgroundColor = [UIColor whiteColor] ;
    }
    
    [self addSubview:_scrollView];
}

- (void)dealloc
{
    [_contentItems removeAllObjects],_contentItems= nil;
}

#pragma mark --
- (void)setResult:(ResultPasel *)result
{
    [m_homePage setMyResult:result] ;
}

#pragma mark - 其他辅助功能
#pragma mark 添加ScrollowViewd的ContentView
- (void)setContentOfTables:(NSInteger)aNumerOfTables
{
    for (int i = 0; i < aNumerOfTables; i++)
    {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, self.frame.size.height)] ;

        if (!i) {
            // 首页 -- 全部
            m_homePage = [[HomePageView alloc] initWithMyFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] ;
            m_homePage.shutDowndelegate = self ;
            [scroll addSubview:m_homePage] ;
        } else  {
            // 首页 -- 活动
            ActivityTableView *activeTable = [[ActivityTableView alloc] initWithMyFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] ;
            [m_activeList addObject:activeTable] ;
            [scroll addSubview:activeTable] ;
        }
        
        [_scrollView    addSubview:scroll]      ;
        [_contentItems  addObject:scroll]       ;
        
    }
    
    [_scrollView setContentSize:CGSizeMake(320 * aNumerOfTables, self.frame.size.height)] ;
}





#pragma mark 移动ScrollView到某个页面
- (void)moveScrollowViewAthIndex:(NSInteger)aIndex
{
    mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    mCurrentPage= aIndex;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)])
    {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

#pragma mark 刷新某个页面
- (UIScrollView *)freshContentTableAtIndex:(NSInteger)aIndex WithCurrentTag:(TagsIndex *)currentTagIndex
{
    
    if (_contentItems.count < aIndex) return nil ;
    
    if (aIndex > 0)
    {
        ActivityTableView *activeTable = (ActivityTableView *)m_activeList[aIndex - 1] ;
        [activeTable reFreshAllMyViewsManuallyWithTagID:currentTagIndex.tag_id] ;
        
        return activeTable ;
    } else {
        return m_homePage ;
    }
    
    return nil ;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = ( _scrollView.contentOffset.x + 320 / 2.0 ) / 320;

    if (mCurrentPage == page) return;
    
    mCurrentPage= page;
    
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate)
    {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        
    }
}

#pragma mark - HomePageViewDelegate
- (void)shutDownApp
{
    [self.delegate terminateApp] ;
//    [LSCommonFunc shutDownAppWithCtrller:self] ;
}

@end
