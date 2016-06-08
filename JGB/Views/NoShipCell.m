//
//  NoShipCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "NoShipCell.h"
#import "UIImageView+WebCache.h"
#import "BagNumView.h"
#import "ColorsHeader.h"


@implementation NoShipCell

- (void)awakeFromNib
{
    //  Initialization code
    [super awakeFromNib] ;
    
    
    _smallScrolls.bounces = NO ;
    self.isCanSelect = NO ;
    
    _lb_signIn.backgroundColor = [UIColor whiteColor] ;
    _lb_signIn.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _lb_signIn.layer.borderWidth = 1 ;
    _lb_signIn.layer.borderColor = COLOR_PINK.CGColor ;
    _lb_signIn.textColor = COLOR_PINK ;
    _lb_signIn.text = @"确认收货" ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --
#pragma mark - setter
- (void)setIsCanSelect:(BOOL)isCanSelect
{
    _isCanSelect            = isCanSelect   ;
    
    _img_rightArrow.hidden  = !isCanSelect  ;
    _smallScrolls.frame     = !isCanSelect ? CGRectMake(_smallScrolls.frame.origin.x, _smallScrolls.frame.origin.y, _smallScrolls.frame.size.width + 20, _smallScrolls.frame.size.height) : CGRectMake(_smallScrolls.frame.origin.x, _smallScrolls.frame.origin.y, 273, _smallScrolls.frame.size.height) ;
    
    _bt_clicked.hidden      = !isCanSelect ;
}

- (void)setIsBag:(BOOL)isBag
{
    _isBag = isBag ;
    
}

- (void)setIsGetBag:(BOOL)isGetBag
{
    _isGetBag = isGetBag ;
    
    _bt_signIn.hidden = isGetBag ;
    _lb_signIn.hidden = isGetBag ;

}


- (void)setProArray:(NSArray *)proArray
{
    _proArray       = proArray ;
    
//  draw bags products scrolls
    float flexWidth = 60.0f ;
    int nums        =  0.0f ;
    for (int i = 0; i < [proArray count]; i ++ )
    {
        OrderProduct *proTemp = (OrderProduct *)[proArray objectAtIndex:i] ;

        BagNumView *bagView = (BagNumView *)[[[NSBundle mainBundle] loadNibNamed:@"BagNumView" owner:self options:nil] lastObject];
        bagView.frame = CGRectMake(i * flexWidth, 0, bagView.frame.size.width, bagView.frame.size.height) ;
        bagView.product = proTemp ;
        
        [_smallScrolls addSubview:bagView] ;
        
        nums ++ ;
    }
    
    _smallScrolls.contentSize   = CGSizeMake(flexWidth * nums, 62) ;
}


#pragma mark --
#pragma mark - delegate

- (IBAction)clickedAction:(id)sender
{
    [self.delegate sendIndexPath:_indexPath] ;
}


- (IBAction)signinPressedAction:(id)sender
{
    NSLog(@"signinPressedAction") ;
    
    [self.delegate signInBags:_indexPath] ;
}

@end


