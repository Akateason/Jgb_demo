//
//  KillView.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-31.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "KillView.h"
#import "ColorsHeader.h"
#import "TimeCountView.h"
#import "UIImageView+WebCache.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

#define NOTIFICATION_SECKILL            @"NOTIFICATION_SECKILL"

@interface KillView () <TimeCountViewDelegate>
{
    TimeCountView       *m_countDownView ;
}

@property (weak, nonatomic) IBOutlet UIView         *view_countDown_content ; //倒计时容器
@property (weak, nonatomic) IBOutlet UIImageView    *imgProduct ;
@property (weak, nonatomic) IBOutlet UILabel        *lb_price ;
@property (weak, nonatomic) IBOutlet UILabel        *lb_status ; //未开始,已结束
@property (weak, nonatomic) IBOutlet UIImageView    *img_soldOut ; //已卖完

@end


@implementation KillView

- (IBAction)pressedKillViewAction:(id)sender
{
    NSLog(@"myPromot : %@", _myPromot.name) ;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SECKILL object:_myPromot.code] ;
}


- (void)viewStyle
{
    self.backgroundColor    = [UIColor whiteColor] ;
    
    _lb_price.textColor     = COLOR_PINK ;
    _lb_status.textColor    = [UIColor darkGrayColor] ;
    
    _img_soldOut.hidden     = YES ;
    
    m_countDownView = (TimeCountView *)[[[NSBundle mainBundle] loadNibNamed:@"TimeCountView" owner:self options:nil] firstObject] ;
    m_countDownView.delegate = self ;
    [_view_countDown_content addSubview:m_countDownView] ;
}

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    [self viewStyle] ;
    
    _imgProduct.image = IMG_NOPIC ;
    
}

#pragma mark --
#pragma mark - setter
- (void)setMyPromot:(Promotiom *)myPromot
{
    _myPromot = myPromot ;
    
    //  imgs
    [_imgProduct setIndexImageWithURL:[NSURL URLWithString:myPromot.image] placeholderImage:IMG_NOPIC options:0 AndSaleSize:CGSizeMake(140, 140)] ;
    
    //  price
    _lb_price.text = [NSString stringWithFormat:@"￥%.2f",myPromot.price] ;
    
    // 判断状态, 未开始, 进行中, 已结束 , 已抢光;
    long long tickNow = [MyTick getTickWithDate:[NSDate date]] ;
    
    //时间未开始
    BOOL bTimeWillStart = tickNow < myPromot.begintime ;
    //时间进行中
    BOOL bTimeOnSaleing = (tickNow >= myPromot.begintime) && (tickNow <= myPromot.endtime) ;
    //时间已结束
    BOOL bTimeEnd       = tickNow > myPromot.endtime ;
    //商品秒光
    BOOL bStockOver     = myPromot.stock == 0 ;
    
    //未开始
    if (bTimeWillStart)
    {
        _view_countDown_content.hidden = YES ;
        //
        NSString *timeStr = [MyTick getDateWithTick:myPromot.begintime AndWithFormart:@"HH:mm"] ;
        _lb_status.text = [NSString stringWithFormat:@"%@开始",timeStr] ;
    }
    //进行中
    else if (bTimeOnSaleing && !bStockOver)
    {
        _view_countDown_content.hidden = NO ;
        m_countDownView.countDown = (int)(myPromot.endtime - tickNow) ;
    }
    //已结束
    else if (bTimeEnd || bStockOver)
    {
        _lb_status.text = @"已结束" ;
        _view_countDown_content.hidden = YES ;
        _lb_price.textColor = [UIColor blackColor] ;
        _img_soldOut.hidden = NO ;
    }
    
}

#pragma mark --
#pragma mark - TimeCountViewDelegate
- (void)countDownIsFinished
{
    _view_countDown_content.hidden = YES ;
    _lb_status.text = @"已结束" ;
    _lb_price.textColor = [UIColor blackColor] ;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
