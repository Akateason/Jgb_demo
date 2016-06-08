//
//  BagConditionHeader.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-25.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "BagConditionHeader.h"
#import "ColorsHeader.h"

@interface BagConditionHeader ()

@property (weak, nonatomic) IBOutlet UIButton *baseButton;
@property (weak, nonatomic) IBOutlet UILabel *lb_bagCondition;
@property (weak, nonatomic) IBOutlet UIButton *bt_recieveOrComment;

@end

@implementation BagConditionHeader


- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _baseButton.backgroundColor = nil ;
    _bt_recieveOrComment.backgroundColor = COLOR_PINK ;
    _bt_recieveOrComment.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _bt_recieveOrComment.layer.masksToBounds = YES ;
}

- (void)setAbag:(Bag *)abag
{
    _abag = abag ;
    
    NSString *statusBag = [Bag getBagStatusStrWithStatus:abag.status] ;
    _lb_bagCondition.text = [NSString stringWithFormat:@"包裹 : %@",statusBag] ;
    
    _bt_recieveOrComment.hidden = abag.status ;

}

//背景选中 -> 查看包裹详情
- (IBAction)backGroundClickSelector:(id)sender
{
    [self.delegate seeShipDetailCallBack:_section] ;
}

//签收包裹, 评价商品
- (IBAction)recieveOrCommitButtonClickedSelector:(id)sender
{
    [self.delegate signInOrComment:_section] ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
