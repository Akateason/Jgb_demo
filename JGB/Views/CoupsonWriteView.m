//
//  CoupsonWriteView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-10.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CoupsonWriteView.h"
#import "ColorsHeader.h"


@implementation CoupsonWriteView

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
    
    _tf_input.delegate = self ;

    
    NSString *testCode = @"" ;      //@"9m6p86p" ;    
    _tf_input.text = testCode ;
    
    self.backgroundColor = COLOR_BACKGROUND ;
}


#pragma mark --
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect tfFrame = textField.frame;
//    int offset = tfFrame.origin.y - (self.frame.size.height - 285.0);
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:0.3f];
//    if (offset > 0)
//    {
//        self.frame = CGRectMake(0.0f, - offset, self.frame.size.width, self.frame.size.height) ;
//    }
//    [UIView commitAnimations] ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    [self keyboardBackToBase];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField resignFirstResponder])
    {
//        [self keyboardBackToBase];
    }
    
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.tf_input isExclusiveTouch])
    {
        [self.tf_input  resignFirstResponder];
//        [self keyboardBackToBase] ;
    }
}


//- (void)keyboardBackToBase
//{
//    [UIView beginAnimations:@"ReturnKeyboard" context:nil];
//    [UIView setAnimationDuration:0.3f];
//    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [UIView commitAnimations] ;
//}



#pragma mark --
#pragma mark - actions
- (IBAction)usePointAction:(id)sender
{
    [self.delegate sendCoupsonCode:_tf_input.text] ;
}



@end
