//
//  MemberTopView.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-3-4.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "MemberTopView.h"
#import "ColorsHeader.h"
#import "UIImageView+WebCache.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@implementation MemberTopView

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
    
    [self setup] ;
    
}


#pragma mark --
#pragma mark - setup
- (void)setup
{
    _topRedView.backgroundColor = COLOR_PINK ;
    self.backgroundColor = [UIColor whiteColor] ;
    
    [TeaCornerView setRoundHeadPicWithView:_imgHead] ;
    
    _imgHead.layer.borderColor = COLOR_LIGHT_GRAY.CGColor ;
    _imgHead.layer.borderWidth = 2.0f ;
    _imgHead.backgroundColor   = [UIColor whiteColor] ;
    
}

#pragma mark --
#pragma mark - Actions
- (IBAction)settingButtonPressed:(id)sender
{
    [self.delegate settingButtonPressedCallBack] ;
}

- (IBAction)pressedUserInfoAndLogin:(id)sender
{
    [self.delegate pressedUserInfoCallBack] ;
}

- (IBAction)pressedHeadPic:(id)sender
{
    [self.delegate pressedHeadCallBack] ;
}

#pragma mark --
#pragma mark - setter
- (void)setStrImg:(NSString *)strImg
{
    _strImg = strImg ;
    
    
    CGSize tempSize = _imgHead.frame.size ;
    
    [_imgHead setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:[UIImage imageNamed:@"loginLogo"] AndSaleSize:CGSizeMake(tempSize.width*2, tempSize.height*2)] ;
}

- (void)setStrUserName:(NSString *)strUserName
{
    _strUserName = strUserName ;
    
    
    _lb_userName.text = strUserName ;
}

@end
