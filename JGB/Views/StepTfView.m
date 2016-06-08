//
//  StepTfView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "StepTfView.h"
#import "DigitInformation.h"


@interface StepTfView ()

@end

@implementation StepTfView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    
    return self;
}


- (void)setViewStyle
{
    UIColor *borderColor = [UIColor lightGrayColor] ;
    
    [_bt_add.layer setBorderWidth:1.0f] ;
    [_bt_add.layer setBorderColor:borderColor.CGColor] ;
    [_bt_add.layer setCornerRadius:CORNER_RADIUS_ALL] ;
    
    [_bt_minus.layer setBorderWidth:1.0f] ;
    [_bt_minus.layer setBorderColor:borderColor.CGColor] ;
    [_bt_minus.layer setCornerRadius:CORNER_RADIUS_ALL] ;
    
    [_tf_num.layer setBorderWidth:1.0f] ;
    [_tf_num.layer setBorderColor:borderColor.CGColor] ;
    [_tf_num.layer setCornerRadius:CORNER_RADIUS_ALL] ;
}

- (void)awakeFromNib
{
    [self setViewStyle] ;
    

    _tf_num.keyboardType    = UIKeyboardTypeNumberPad ;
    _tf_num.userInteractionEnabled = NO ;
}

- (void)layoutSubviews
{
    [super layoutSubviews] ;
}

- (void)setNum:(int)num
{
    self.tf_num.text = [NSString stringWithFormat:@"%d",num] ;
    _num = num ;
}

- (void)setMaxNum:(int)maxNum
{
    _maxNum = maxNum ;
    
    if (!maxNum)
    {
        _bt_add.enabled = NO ;
        _bt_minus.enabled = NO ;
    }
    else
    {
        _bt_add.enabled = YES ;
        _bt_minus.enabled = YES ;
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

- (IBAction)actionMinus:(id)sender
{
    NSLog(@"%d",_num) ;
    
    if (_num == 1)
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_NUMTOOSMALL] ;

        return ;
    }
    else
    {
        _num -- ;
        
        [self setNeedsDisplay] ;
        
        [self.delegate refreshTableWithNum:_num AndWithSection:_section AndWithRow:_row] ;
    }
}

- (IBAction)actionPlus:(id)sender
{
    NSLog(@"%d",_num) ;
    
    if (_num == _maxNum)
    {
        [DigitInformation showWordHudWithTitle:WD_HUD_NUMOUTOFRANGE] ;

        return ;
    }
    else
    {
        _num ++ ;
        
        [self setNeedsDisplay] ;
        
        [self.delegate refreshTableWithNum:_num AndWithSection:_section AndWithRow:_row] ;
    }
}



#pragma mark --
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_NUM_KEY_BOARD object:textField] ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int numInView = [textField.text intValue] ;
    if (numInView > _maxNum)
    {
        numInView = _maxNum ;
        
        [DigitInformation showWordHudWithTitle:WD_HUD_NUMOUTOFRANGE] ;
    }else if (numInView < 1)
    {
        numInView = 1       ;
        
        [DigitInformation showWordHudWithTitle:WD_HUD_NUMTOOSMALL] ;
    }
    
    textField.text = [NSString stringWithFormat:@"%d",numInView] ;
    _num = numInView ;
    
    [self.delegate refreshTableWithNum:_num AndWithSection:_section AndWithRow:_row] ;
    
}


@end






