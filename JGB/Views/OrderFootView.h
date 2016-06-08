//
//  OrderFootView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#define TAG_BUTTON_ORDERFOOT_1      8971
#define TAG_BUTTON_ORDERFOOT_2      8972
#define TAG_BUTTON_ORDERFOOT_3      8973

#define TITLE_SEE_ORDER             @"查看订单"
#define TITLE_CANCEL_ORDER          @"取消订单"
#define TITLE_PAY_NOW               @"立即付款"
#define TITLE_SEE_SHIP              @"查看物流"
#define TITLE_CHECK_OUT             @"确认收货"


#import "Order.h"
#import <UIKit/UIKit.h>

@protocol OrderFootViewDelegate <NSObject>

/*
 ******************************************
 *  1.section  :  表示所点击属于哪一section
 *  2.title    :  按钮文字
 ******************************************
 */
- (void)callBackWithSection:(int)section
         AndWithButtonTitle:(NSString *)title  ;

@end



@interface OrderFootView : UIView
//  attr
@property (nonatomic,retain) Order      *order ;        // order


/*
 *  default is NO
 *  it become YES when buttons comes null .
 */
@property (nonatomic)        BOOL       isNull ;

/*
 *  isNeedDetail 是否需要显示查看订单
 * yes show
 * no  hide
 **/
@property (nonatomic,assign) BOOL       isNeedDetail ;        // need see detail

/*
 *  views
 */
//实际付款
//@property (weak, nonatomic) IBOutlet UILabel *lb_payReal;


//the current section
@property (nonatomic,assign)int section ;
@property (nonatomic,retain)id <OrderFootViewDelegate> delegate ;

//views
@property (weak, nonatomic) IBOutlet UIButton *bt1;
@property (weak, nonatomic) IBOutlet UIButton *bt2;
@property (weak, nonatomic) IBOutlet UIButton *bt3;

@property (weak, nonatomic) IBOutlet UIView *baseLine;

@property (weak, nonatomic) IBOutlet UILabel  *lb_orderStatus;

- (IBAction)clickBtAction:(id)sender;

@end
