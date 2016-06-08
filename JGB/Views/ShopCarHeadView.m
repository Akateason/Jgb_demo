//
//  ShopCarHeadView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-6.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ShopCarHeadView.h"
#import "ColorsHeader.h"


@implementation ShopCarHeadView

- (void)layoutSubviews
{
    [super layoutSubviews] ;
}

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    [_bt_edit setTitleColor:COLOR_PINK forState:UIControlStateNormal] ;
    [_bt_edit setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected] ;
    [_bt_edit setTintColor:COLOR_PINK] ;
    
    self.backgroundColor = [UIColor whiteColor] ;
    
    UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 320, 1)]  ;
    baseline.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:baseline] ;

    
    [_bt_edit setTitle:@"编辑" forState:UIControlStateNormal]    ;
    [_bt_edit setTitle:@"完成" forState:UIControlStateSelected]  ;
}

- (void)setIsAllHead:(BOOL)isAllHead
{
    _isAllHead = isAllHead ;
    
//    _bgView.hidden = isAllHead ;
}


- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected ;
    
    if (isSelected)
    {
        _img_checkBox.image = [UIImage imageNamed:@"y"] ;
    }
    else
    {
        _img_checkBox.image = [UIImage imageNamed:@"n"] ;
    }
    
}

- (void)setIsEdited:(BOOL)isEdited
{
    _isEdited = isEdited ;
    
    _bt_edit.selected = _isEdited ;

}




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (IBAction)editAction:(id)sender
{
    NSLog(@"_isSelected : %d",_isEdited) ;
    
    [_delegate editBuyNumWithSection:_section AndWithEditOrNot:self.isEdited] ;
}

- (IBAction)checkPressedAction:(id)sender
{
    [_delegate sendTheSelectedSection:_section AndWithAllSelect:!self.isSelected];
}

@end
