//
//  SmallStarView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "SmallStarView.h"

@implementation SmallStarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setLevel:(int)level
{
    if ( (level < 0) || (level > 5) ) return ;
    
    int levelConvert = level + 67600 ;
    
    for (int i = 67601; i < 67606; i++) {
        
        if (i <= levelConvert) {
            //            NSLog(@"%@",self.starView);
            NSLog(@"%@",[self subviews]);
            for (UIView *sub in [self subviews]) {
                if ([sub isKindOfClass:[UIImageView class]]) {
                    UIImageView *imgV = (UIImageView *)sub ;
                    if (imgV.tag == i) {
                        imgV.image = [UIImage imageNamed:@"starY.png"] ;
                    }
                }
            }
        } else {
            for (UIView *sub in [self subviews]) {
                if ([sub isKindOfClass:[UIImageView class]]) {
                    UIImageView *imgV = (UIImageView *)sub ;
                    if (imgV.tag == i) {
                        imgV.image = [UIImage imageNamed:@"starN.png"] ;
                    }
                }
            }
        }
        
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

@end
