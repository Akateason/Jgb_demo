//
//  PopShipCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-2-27.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "PopShipCell.h"
#import "ColorsHeader.h"

@interface PopShipCell()

@property (nonatomic,retain) NSArray *dataShip ;

@end

@implementation PopShipCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib] ;
    
    [self setBorderWith:_lb_day1] ;
    [self setBorderWith:_lb_day2] ;
    [self setBorderWith:_lb_day3] ;
    [self setBorderWith:_lb_day4] ;
}

- (void)setBorderWith:(UIView *)theview
{
    theview.backgroundColor = [UIColor whiteColor] ;
    theview.layer.borderColor = COLOR_BACKGROUND.CGColor ;
    theview.layer.borderWidth = 1.0f ;
    theview.layer.cornerRadius = theview.frame.size.width / 2 ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --
#pragma mark - setter
- (void)setIsSelfSold:(BOOL)isSelfSold
{
    
    _lb_3.hidden = isSelfSold ;
    _lb_day3.hidden = isSelfSold ;
    _lb_4.hidden = isSelfSold ;
    _lb_day4.hidden = isSelfSold ;

}

- (void)setDataShip:(NSArray *)dataShip
{
    _dataShip = dataShip ;
    
    if (dataShip.count > 2)
    {
        // 非自营
        ExPressKVO *obj1 = (ExPressKVO *)_dataShip[0] ;
        [self putExpress:obj1 intoLabelCycle:_lb_day1 AndWithLabelWord:_lb_1] ;
        ExPressKVO *obj2 = (ExPressKVO *)_dataShip[1] ;
        [self putExpress:obj2 intoLabelCycle:_lb_day2 AndWithLabelWord:_lb_2] ;
        ExPressKVO *obj3 = (ExPressKVO *)_dataShip[2] ;
        [self putExpress:obj3 intoLabelCycle:_lb_day3 AndWithLabelWord:_lb_3] ;
        ExPressKVO *obj4 = (ExPressKVO *)_dataShip[3] ;
        [self putExpress:obj4 intoLabelCycle:_lb_day4 AndWithLabelWord:_lb_4] ;
        
        self.isSelfSold = NO ;
    }
    else
    {
        // 自营
        _lb_day1.text = @"2-5日" ;
        _lb_1.text = @"保税区发货" ;

        _lb_day2.text = @"1-4日" ;
        _lb_2.text = @"国内派送" ;
        
        self.isSelfSold = YES ;
    }

}

- (void)setExpressDetail:(ExpressageDetail *)expressDetail
{
    _expressDetail = expressDetail ;
    
    self.dataShip = expressDetail.kvoArr ;
    
    _lb_comeFrom.text = expressDetail.title ;
}


- (void)putExpress:(ExPressKVO *)obj intoLabelCycle:(UILabel *)lbCycle AndWithLabelWord:(UILabel *)lbWord
{
    lbCycle.text = obj.value ;
    lbWord.text  = obj.key ;
}


@end
