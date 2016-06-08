//
//  ProScrView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ProScrView.h"

#define MY_SCRO_WIDTH       _killProView.frame.size.width
#define MY_SCRO_HEIGHT      _killProView.frame.size.height

#define SLEEP_INTERVAL      5.0f


#import "Activity.h"
#import "KillSegView.h"
#import "ServerRequest.h"

@interface ProScrView()<UIScrollViewDelegate,KillSegViewDelegate>
{
    UIScrollView *_scrollView;

    

}
@end


@implementation ProScrView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {

    }
    return self;
}



- (void)setkillScrollView
{
    _pageControl.center = CGPointMake(160, 106) ;
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    _pageControl.currentPageIndicatorTintColor = COLOR_PINK;
    // base scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MY_SCRO_WIDTH, MY_SCRO_HEIGHT)] ;
    _scrollView.backgroundColor = COLOR_BACKGROUND ;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO ;
    // 设置内容大小
    [_killProView addSubview:_scrollView];
}

- (void)setKillSegment
{
    KillSegView *killSeg = [[KillSegView alloc] initWithFrame:_killSegView.frame AndMode:clock10]    ;
    killSeg.delegate = self ;
    [_killSegView addSubview:killSeg]    ;
    
    
}

- (void)awakeFromNib
{
    [super awakeFromNib]            ;
    
    [self setkillScrollView]        ;
    [self setKillSegment]           ;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
}



#pragma mark -
#pragma mark - SETTER
//auto play
- (void)setIsAutoPlay:(BOOL)isAutoPlay
{
    _isAutoPlay = isAutoPlay ;
    
    if (isAutoPlay)
    {
        [self autoPlay] ;
    }
    
}

- (void)autoPlay
{
    dispatch_queue_t queue = dispatch_queue_create("autoplayQueue", NULL) ;
    dispatch_async(queue, ^{
        while (1)
        {
            if (_listCount == 0) continue ;
            
            sleep(SLEEP_INTERVAL) ;
            
            NSInteger currentPage = _pageControl.currentPage ;
            NSInteger nextPage    = currentPage + 1 ;
            if (nextPage == _listCount) nextPage = 0 ;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ProScroSubView *proView = (ProScroSubView *)[_scrollView viewWithTag:nextPage];
                [_scrollView scrollRectToVisible:proView.frame animated:YES];
                self.pageControl.currentPage = nextPage;
                
            }) ;
        }
    }) ;
}



// pro list setter
- (void)setProList:(NSArray *)proList
{
    _proList = proList              ;
    
    _listCount = proList.count / 3  ;
    
    _pageControl.numberOfPages = _listCount ;
    
    _pageControl.currentPage = 0    ;
    
    _scrollView.contentSize = CGSizeMake(MY_SCRO_WIDTH * _listCount, MY_SCRO_HEIGHT);
    
    int _x = 0  ;
    
    for (int index = 0 ; index < _listCount ; index++)
    {
        ProScroSubView *subView = (ProScroSubView *)[[[NSBundle mainBundle] loadNibNamed:@"ProScroSubView" owner:self options:nil] lastObject] ;
        subView.frame = CGRectMake(0+_x, 0, MY_SCRO_WIDTH, MY_SCRO_HEIGHT)   ;
        subView.tag = index              ;
        
        //  ?
        int startIndex = index * 3 ;
        subView.activity1 = [proList objectAtIndex:startIndex]   ;
        subView.activity2 = [proList objectAtIndex:startIndex+1] ;
        subView.activity3 = [proList objectAtIndex:startIndex+2] ;
        
        [_scrollView addSubview:subView] ;
        
        _x += MY_SCRO_WIDTH              ;
    }
}


#pragma mark --
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x / MY_SCRO_WIDTH;
    _pageControl.currentPage = current ;
}

#pragma mark --
#pragma mark - KillSegViewDelegate
- (void)sendToClockMode:(SWITCH_MODE)clockMode
{
    NSLog(@"reset : %d",clockMode) ;
    
    
//    NSMutableArray *proActivityList = [NSMutableArray array] ;
//    
//    NSDictionary *productListDiction = [ServerRequest getPromotiomAreaWithPage:@"index" AndWithKeyWord:@"xianshi" AndWithNumber:9] ;
//    NSArray *tempArrayProductList = [[productListDiction objectForKey:@"promotiom"] objectForKey:@"list"] ;
//    for (NSDictionary *tempDic in tempArrayProductList)
//    {
//        Activity *activity = [[Activity alloc] initWithDic:tempDic] ;
//        [proActivityList addObject:activity] ;
//    }
//    
//    self.proList = proActivityList ;
    
//    
//    这里设好全局, 在内存中切换, 不推荐服务端访问
}


@end
