//
//  CONormalCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "COScoreCell.h"
#import "DigitInformation.h"
#import "ColorsHeader.h"


@interface COScoreCell ()
{
    
    int m_maxScore ;
}
@end

@implementation COScoreCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;
    
    
    m_maxScore = G_USER_CURRENT.score ;
    
    self.backgroundColor = [UIColor whiteColor] ;
    
    _lb_PointsYouOwn.text = [NSString stringWithFormat:@"您拥有积分%d （100积分 = 1元）",m_maxScore] ;
    
    _tf_point.delegate = self ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark --
#pragma mark - Actions
- (void)useAction
{
    [self.delegate sendScore:[_tf_point.text intValue]] ;
}


#pragma mark --
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate showHideKeyBoard:YES] ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self keyboardBackToBase];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int scoreTemp = [textField.text intValue] ;
    
    if (scoreTemp > m_maxScore)
    {
        textField.text = [NSString stringWithFormat:@"%d",m_maxScore] ;
        
        [DigitInformation showWordHudWithTitle:WD_HUD_SCOREOUTBONNDS] ;
    }
        
    
    if (![textField resignFirstResponder])
    {
        [self keyboardBackToBase];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int scoreTemp = [textField.text intValue] ;
    
    if (scoreTemp > m_maxScore)
    {
        textField.text = [NSString stringWithFormat:@"%d",m_maxScore] ;
        
        [DigitInformation showWordHudWithTitle:WD_HUD_SCOREOUTBONNDS] ;
        
        return NO ;
    }
    
    return YES ;
}


#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![_tf_point isExclusiveTouch])
    {
        [_tf_point resignFirstResponder];
        [self keyboardBackToBase];
    }
}

- (void)keyboardBackToBase
{
    [self.delegate showHideKeyBoard:NO] ;
}



@end
