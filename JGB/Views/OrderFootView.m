//
//  OrderFootView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "OrderFootView.h"
#import "DigitInformation.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "OrderStatus.h"
#import "ColorsHeader.h"


@implementation OrderFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _bt1.hidden = YES ;
    _bt2.hidden = YES ;
    _bt3.hidden = YES ;
    
    self.backgroundColor    = [UIColor whiteColor] ;

    
    [self setButtonStyle:_bt1]    ;
    [self setButtonStyle:_bt2]    ;
    [self setButtonStyle:_bt3]    ;
    
    _lb_orderStatus.hidden = YES ;

    
    _baseLine.backgroundColor = COLOR_BACKGROUND ;
    
    UIView *upline      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)] ;
    upline.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:upline] ;
    

}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    [self setButtons]   ;

}


- (void)setOrder:(Order *)order
{
    _order = order ;
    
    //
    NSArray *arrlist = [self getButtonNameList] ;
    
    _isNull = (!arrlist.count) ? YES : NO ;
}



//- (void)showStatus
//{
//    NSString *statusStr = @""       ;
//    for (OrderStatus *status in G_ORDERSTATUS_DIC)
//    {
//        if (_order.orderInfo.status == status.idStatus)
//        {
//            statusStr = status.name ;
//        }
//    }
//    _lb_orderStatus.text = statusStr ;
//}


- (void)setButtonStyle:(UIButton *)button
{
    
    [button setFont:[UIFont systemFontOfSize:14.0f]] ;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    
//    button.layer.borderColor = COLOR_PINK.CGColor ;
//    button.layer.borderWidth = 1.0f ;

    button.backgroundColor      = COLOR_PINK ;
    button.layer.cornerRadius   = 4.0f ;

}


- (NSArray *)getButtonNameList
{
    NSArray *arrlist = [NSArray array] ;
    
    switch (_order.orderInfo.status)
    {
        case 1://待付款
        {
            arrlist = @[TITLE_SEE_ORDER,TITLE_PAY_NOW];
        }
            break;
        case 2://待发货
        {
            arrlist = @[TITLE_SEE_ORDER];
        }
            break;
        case 3://已发货
        {
            arrlist = @[TITLE_SEE_ORDER,TITLE_SEE_SHIP,TITLE_CHECK_OUT];
        }
            break;
        case 4://已签收
        {
            arrlist = @[TITLE_SEE_ORDER,TITLE_SEE_SHIP];
        }
            break;
        case 5://已取消
        {
            arrlist = @[TITLE_SEE_ORDER];
        }
            break;
        case 6://已退款
        {
            arrlist = @[TITLE_SEE_ORDER];
        }
            break;
        case 7://待审核
        {
            arrlist = @[TITLE_SEE_ORDER];
        }
            break;
        case 8://退款中
        {
            arrlist = @[TITLE_SEE_ORDER];
        }
            break;
            
        default:
            break;
    }
    
    if (!_isNeedDetail)
    {
        
        
        switch (_order.orderInfo.status)
        {
            case 1://待付款
            {
                arrlist = @[TITLE_CANCEL_ORDER,TITLE_PAY_NOW];
            }
                break;
            case 2://待发货
            {
                arrlist = @[];
            }
                break;
            case 3://已发货
            {
                arrlist = @[TITLE_CHECK_OUT];//@[TITLE_SEE_SHIP,TITLE_CHECK_OUT];
            }
                break;
            case 4://已签收
            {
                arrlist = @[];//@[TITLE_SEE_SHIP]; ,已签收的, 看不到了, 到底是看哪个包裹无法知道,所以不显示
            }
                break;
            case 5://已取消
            {
                arrlist = @[];
            }
                break;
            case 6://已退款
            {
                arrlist = @[];
            }
                break;
            case 7://待审核
            {
                arrlist = @[];
            }
                break;
            case 8://退款中
            {
                arrlist = @[];
            }
                break;
            default:
                break;
        }
    }

    
    return arrlist ;
}


- (void)setButtons
{
    NSArray *arrlist = [self getButtonNameList] ;
    
//
    int arrCount = arrlist.count ;
    
    self.isNull = (!arrlist.count) ? YES : NO ;
    
//    
    for (int i = TAG_BUTTON_ORDERFOOT_1; i < TAG_BUTTON_ORDERFOOT_1 + 3; i++)
    {
        if (i <= arrCount + TAG_BUTTON_ORDERFOOT_1 - 1)
        {
            for (UIView *subs in self.subviews)
            {
                if ([subs isKindOfClass:[UIButton class]])
                {
                    UIButton *button = (UIButton *)subs ;
                    if (button.tag == i)
                    {
                        [button setTitle:arrlist[i - TAG_BUTTON_ORDERFOOT_1] forState:UIControlStateNormal] ;
                        button.hidden = NO ;
                    }
                }
            }
        }
    }
//
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)clickBtAction:(id)sender
{
    UIButton *bt = (UIButton *)sender ;
    
    [self.delegate callBackWithSection:self.section AndWithButtonTitle:bt.titleLabel.text] ;
    
}


@end
