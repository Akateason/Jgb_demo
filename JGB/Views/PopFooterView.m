//
//  PopFooterView.m
//  JGB
//
//  Created by
//on 15-2-28.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "PopFooterView.h"
#import "ColorsHeader.h"

@implementation PopFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    
    [super awakeFromNib] ;
    
    
}

- (void)setStrContent:(NSString *)strContent
{
    _strContent = strContent ;
    
    // set label
    _lb_content.text = strContent ;
    
    // set frame
    CGRect rect = self.frame ;
    rect.size.height = [PopFooterView getPopFooterViewHeightWithContent:strContent] ;
    self.frame = rect ;
    
    // add base line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, rect.size.height - 1, 320-30, 1)] ;
    line.backgroundColor = COLOR_BACKGROUND ;
    [self addSubview:line] ;
}





+ (float)getPopFooterViewHeightWithContent:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:10.0f];
    CGSize size = CGSizeMake(290,200);
    CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    float h = 25 - 12 + labelsize.height ;
  
    return h ;
}


@end
