//
//  CmtSendView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-15.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CmtSendView.h"
#import "UIImageView+WebCache.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "DigitInformation.h"
#import "ServerRequest.h"

#define TV_PLACEHOLDER      @"亲,您的评价对其他买家有很大帮助"

@interface  CmtSendView ()
{
    BOOL    m_firstTime ;
    
    int     m_score ;       //default is 5
}
@end

@implementation CmtSendView

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
    
    m_firstTime = YES   ;
    m_score     = 5     ;
//    
    _lb_goodPrice.textColor = COLOR_PINK ;
    _lb_goodTitle.textColor = [UIColor darkGrayColor] ;
    _tv_commentContent.textColor = [UIColor grayColor] ;
    _tv_commentContent.text = TV_PLACEHOLDER ;
    
    _lb_hate.textColor      = [UIColor darkGrayColor] ;
    _lb_normal.textColor    = [UIColor darkGrayColor] ;
    _lb_like.textColor      = COLOR_PINK;
    
    _img_hate.image         = [UIImage imageNamed:@"like1no"]   ;
    _img_normal.image       = [UIImage imageNamed:@"like2no"]   ;
    _img_like.image         = [UIImage imageNamed:@"like3"]     ;
    
    _tv_commentContent.backgroundColor      = [UIColor whiteColor] ;
    _tv_commentContent.layer.borderColor    = COLOR_BACKGROUND.CGColor ;
    _tv_commentContent.layer.borderWidth    = 1.0f ;
    _tv_commentContent.delegate             = self ;
    
    _lb_uCanInput.font      = [UIFont systemFontOfSize:12.0f] ;
}




- (IBAction)likeAction:(id)sender
{
    UIButton *bt = (UIButton *)sender ;
    
    switch (bt.tag) {
        case TAG_LIKE_BT:
        {
            [self refreshLevelContentWithLabel:_lb_like andWithLikeLevel:3 AndImage:_img_like AndWithSelected:YES] ;
            [self refreshLevelContentWithLabel:_lb_normal andWithLikeLevel:2 AndImage:_img_normal AndWithSelected:NO] ;
            [self refreshLevelContentWithLabel:_lb_hate andWithLikeLevel:1 AndImage:_img_hate AndWithSelected:NO] ;
            m_score = 5 ;
        }
            break;
        case TAG_NORMAL_BT:
        {
            [self refreshLevelContentWithLabel:_lb_like andWithLikeLevel:3 AndImage:_img_like AndWithSelected:NO] ;
            [self refreshLevelContentWithLabel:_lb_normal andWithLikeLevel:2 AndImage:_img_normal AndWithSelected:YES] ;
            [self refreshLevelContentWithLabel:_lb_hate andWithLikeLevel:1 AndImage:_img_hate AndWithSelected:NO] ;
            m_score = 3 ;
        }
            break;
        case TAG_HATE_BT:
        {
            [self refreshLevelContentWithLabel:_lb_like andWithLikeLevel:3 AndImage:_img_like AndWithSelected:NO] ;
            [self refreshLevelContentWithLabel:_lb_normal andWithLikeLevel:2 AndImage:_img_normal AndWithSelected:NO] ;
            [self refreshLevelContentWithLabel:_lb_hate andWithLikeLevel:1 AndImage:_img_hate AndWithSelected:YES] ;
            m_score = 1 ;
        }
            break;
        default:
            break;
    }
    
}


- (void)refreshLevelContentWithLabel:(UILabel *)label andWithLikeLevel:(int)level AndImage:(UIImageView *)imgView AndWithSelected:(BOOL)selected
{
    label.textColor     = selected ? COLOR_PINK : [UIColor grayColor] ;

    NSString *imgStr    = selected ? [NSString stringWithFormat:@"like%d",level] : [NSString stringWithFormat:@"like%dno",level] ;
    imgView.image       = [UIImage imageNamed:imgStr] ;
    
    if (!selected) return ;
    [TeaAnimation shakeRandomDirectionWithDuration:0.65f AndWithView:imgView]   ;
    [TeaAnimation shakeRandomDirectionWithDuration:0.65f AndWithView:label]     ;
}




- (void)setCmt:(ListComment *)cmt
{
    _cmt = cmt ;
    
    _lb_goodTitle.text = _cmt.title ;
    _lb_goodPrice.text = [NSString stringWithFormat:@"￥%.2f",_cmt.totalPrice]  ;
    [_img_good setImageWithURL:[NSURL URLWithString:_cmt.image] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(70*2, 70*2)] ;
}




#pragma mark --
#pragma mark - text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if (m_firstTime == YES)
    {
        textView.text = @"" ;
        m_firstTime = NO ;
    }
    
    
    CGRect tfFrame = textView.frame;
    int offset     = tfFrame.origin.y - (self.frame.size.height - 450.0) ;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil] ;
    [UIView setAnimationDuration:0.3f] ;
    if (offset > 0)
    {
        self.frame = CGRectMake(0.0f, - offset, self.frame.size.width, self.frame.size.height) ;
    }
    
    [UIView commitAnimations] ;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int length = [textView.text length] ;
    
    if (length > 500)
    {
        [DigitInformation showWordHudWithTitle:@"超过范围了哦,亲"];
        
        return NO ;
    }
    
    //
    _lb_uCanInput.text = [NSString stringWithFormat:@"您还可以输入%d字", 500 - length] ;
    
    //
    if ([text isEqualToString:@"\n"])
    {
        [self keyboardBackToBase];
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = TV_PLACEHOLDER ;
        m_firstTime = YES ;
    }
    
    if (m_firstTime)
    {
        _lb_uCanInput.text = @"您还可以输入500字" ;
        return ;
    }

}


#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![_tv_commentContent isExclusiveTouch])
    {
        [_tv_commentContent resignFirstResponder];

        [self keyboardBackToBase];
    }
}

- (void)keyboardBackToBase
{
    [UIView beginAnimations:@"ReturnKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}


#pragma mark --
#pragma mark - send action
- (void)sendCommentToServer
{
    NSString *content = @"" ;
    if (![_tv_commentContent.text isEqualToString:TV_PLACEHOLDER] )
    {
        content = _tv_commentContent.text ;
    }
    
    ResultPasel *result = [ServerRequest commentCreateWithScore:m_score AndWithImgList:nil AndWithComment:content AndWithOrdersProductID:_cmt.orderProductId AndWithProductCode:_cmt.code] ;
    
    if (result.code != 200)
    {
        [DigitInformation showWordHudWithTitle:result.info] ;
        return ;
    }
    
    [DigitInformation showWordHudWithTitle:@"发送成功"] ;
    
    
    [self performSelector:@selector(popBack) withObject:nil afterDelay:1.0f] ;
}

- (void)popBack
{
    [self.delegate popBackSuperController] ;
}

@end
