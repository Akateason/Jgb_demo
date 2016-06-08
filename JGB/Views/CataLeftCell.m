//
//  CataLeftCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-2-25.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "CataLeftCell.h"
#import "ColorsHeader.h"

@implementation CataLeftCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib] ;
    
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, CELL_HEIGHT_LEFT)] ;
    
    _leftView.backgroundColor = COLOR_PINK ;
    [self.contentView addSubview:_leftView] ;
    _leftView.hidden = YES ;
    
    self.textLabel.font = [UIFont systemFontOfSize:12.0f] ;
    self.textLabel.textColor = [UIColor blackColor] ;
    self.textLabel.textAlignment = NSTextAlignmentCenter ;

    
    
}

- (void)setName:(NSString *)name
{
    _name = name ;
    
    self.textLabel.text = name ;
    
}


- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected ;
    
    self.textLabel.textColor = (isSelected) ? COLOR_PINK : [UIColor blackColor] ;
    _leftView.hidden = !isSelected ;
    self.backgroundColor = (isSelected) ? [UIColor whiteColor] : nil ;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
