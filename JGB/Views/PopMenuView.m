//
//  PopMenuView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "PopMenuView.h"
#import "DigitInformation.h"

#import "LSCommonFunc.h"
#import "IndexViewController.h"//首页
#import "MemberCenterController.h"//会员中心
#import "ShopCarViewController.h"//购物车
#import <AKATeasonFramework/AKATeasonFramework.h>

@implementation PopMenuView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    //over write ...
    
    UIColor *color = [UIColor colorWithWhite:1 alpha:1] ;//0.95
    _v1.backgroundColor = color ;
    _v2.backgroundColor = color ;
    _v3.backgroundColor = color ;
    _v4.backgroundColor = color ;
    _v5.backgroundColor = color ;
    _lb_howManyShopCar.backgroundColor = COLOR_PINK                 ;
    _lb_signInOrNo.backgroundColor = COLOR_WD_GREEN                 ;
    [TeaCornerView setRoundHeadPicWithView:_lb_howManyShopCar]   ;
    [TeaCornerView setRoundHeadPicWithView:_lb_signInOrNo]       ;
    [TeaCornerView setRoundHeadPicWithView:_headPicView]         ;

//Down Head First
    dispatch_queue_t queue = dispatch_queue_create("queuehead", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( (G_USER_CURRENT.avatar == nil) || ([G_USER_CURRENT.avatar isEqualToString:@""]) )
            {
                self.headPicView.image = IMG_NOPIC ;
            }
            else
            {
                [self.headPicView setImageWithURL:[NSURL URLWithString:G_USER_CURRENT.avatar] placeholderImage:IMG_NOPIC AndSaleSize:self.headPicView.frame.size];
            }
        });
    }) ;

//登录名字
    if (G_USER_CURRENT.nickName == nil || G_USER_CURRENT == nil)
    {
        _name_lb.text   = @"会员中心"    ;
    }
    else
    {
        _name_lb.text   = [NSString stringWithFormat:@"%@",G_USER_CURRENT.nickName];
    }
    _name_lb.font = [UIFont boldSystemFontOfSize:18] ;
//    _name_lb.textColor = COLOR_PINK ;
    
//购物车数量
    if (G_SHOP_CAR_COUNT == 0)
    {
        _lb_howManyShopCar.hidden = YES ;
    }
    else
    {
        _lb_howManyShopCar.hidden = NO  ;
        _lb_howManyShopCar.text   = [NSString stringWithFormat:@"%d",G_SHOP_CAR_COUNT] ;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)pressedPopMenuAction:(id)sender
{
    UIButton *bt = (UIButton *)sender ;
//    NSLog(@"bt.tag %d",bt.tag);

    [_delegate goToContollerWithTag:bt.tag] ;
}

- (IBAction)tapWhite:(id)sender {
//    NSLog(@"tapWhite") ;
    
    [_delegate clickOutSide];
}


#pragma mark --
#pragma mark - POP MENU GLOBAL FUNTION
+ (void)showHidePopMenuWithVC:(UIViewController *)vc AndWithMustRemove:(BOOL)flag
{
    if ( (G_POPMENU == nil)||(G_POPMENU == NULL) )
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"PopMenuView" owner:self options:nil];
        G_POPMENU = (PopMenuView *)[nibs objectAtIndex:0];
        CGRect appFm = [UIScreen mainScreen].applicationFrame ;
        G_POPMENU.frame = CGRectMake(0, 0, appFm.size.width, appFm.size.height + 20);
        G_POPMENU.backgroundColor = [UIColor clearColor] ;
    }
//
    if (G_POPMENU.delegate == nil) {
        G_POPMENU.delegate = vc ;
    }
//
    int num = 0 ;
    for (UIView *sub in [vc.view subviews]) {
        if ([sub isKindOfClass:[PopMenuView class]]) {
            num ++ ;
        }
    }
    
    if (num) {
        [G_POPMENU removeFromSuperview];
    }else {
        [vc.view addSubview:G_POPMENU];
    }
    
    if (flag) {
        [G_POPMENU removeFromSuperview];
        G_POPMENU.delegate = nil ;
    }
}

@end


