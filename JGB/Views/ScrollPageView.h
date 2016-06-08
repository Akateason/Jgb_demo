//
//  ScrollPageView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "IndexFirstTestController.h"
//#import "ActivityViewController.h"
#import "ResultPasel.h"
#import "TagsIndex.h"

@protocol ScrollPageViewDelegate <NSObject>

- (void)didScrollPageViewChangedPage:(NSInteger)aPage;

- (void)terminateApp ;

@end



@interface ScrollPageView : UIView<UIScrollViewDelegate>
{
    NSInteger   mCurrentPage        ;
    BOOL        mNeedUseDelegate    ;
    
    
//    IndexFirstTestController    *m_firstCtrller         ;
//    NSMutableArray              *m_activeCtrllerList    ;
}

@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) NSMutableArray *contentItems;
@property (nonatomic,assign) id<ScrollPageViewDelegate> delegate;

- (void)setResult:(ResultPasel *)result ;

#pragma mark 添加ScrollowViewd的ContentView
- (void)setContentOfTables:(NSInteger)aNumerOfTables;


#pragma mark 滑动到某个页面
- (void)moveScrollowViewAthIndex:(NSInteger)aIndex;
#pragma mark 刷新某个页面
- (UIScrollView *)freshContentTableAtIndex:(NSInteger)aIndex WithCurrentTag:(TagsIndex *)currentTagIndex ;

@end
