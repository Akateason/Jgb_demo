//
//  ChangeSecretViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ChangeSecretViewController.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "DigitInformation.h"
#import "ServerRequest.h"

@interface ChangeSecretViewController ()

@end

@implementation ChangeSecretViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tf_firstSecret.secureTextEntry     = YES ;
    _tf_secondSecret.secureTextEntry    = YES ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    self.navigationController.navigationBar.translucent = YES ;
}

#pragma mark --
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( (textField == _tf_secondSecret) && ( [_tf_firstSecret.text isEqualToString:@""] ) )
    {
        [DigitInformation showWordHudWithTitle:@"请输入您的新密码"] ;

        return ;
    }
    
    CGRect tfFrame = textField.frame;
    int offset = tfFrame.origin.y - (self.view.frame.size.height - 285.0);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    if (offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, - offset, self.view.frame.size.width, self.view.frame.size.height) ;
    }
    [UIView commitAnimations] ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self keyboardBackToBase];
    
    BOOL bSussess = [Verification validatePassword:textField.text] ;
    if (!bSussess)
    {
        [DigitInformation showWordHudWithTitle:@"密码格式不符合规范\n6-15个字符"] ;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField resignFirstResponder])
    {
        [self keyboardBackToBase];
    }
    
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.tf_firstSecret isExclusiveTouch] || ![self.tf_secondSecret isExclusiveTouch])
    {
        [self.tf_firstSecret  resignFirstResponder];
        [self.tf_secondSecret resignFirstResponder];

        [self keyboardBackToBase] ;
    }
}

- (void)keyboardBackToBase
{
    [UIView beginAnimations:@"ReturnKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations] ;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --
#pragma mark - actions
- (IBAction)submitAction:(id)sender
{
    
    if ([_tf_firstSecret.text isEqualToString:@""] || !_tf_firstSecret.text)
    {
        [DigitInformation showWordHudWithTitle:@"请输入您的新密码"] ;
        
        return ;
    }
    else if ([_tf_secondSecret.text isEqualToString:@""] || !_tf_secondSecret.text)
    {
        [DigitInformation showWordHudWithTitle:@"请再次输入您的新密码"] ;
        
        return ;
    }
    
    
    if ( ![_tf_firstSecret.text isEqualToString:_tf_secondSecret.text] )
    {
        [DigitInformation showWordHudWithTitle:@"两次输入的密码不一致哦,请核对后再试"] ;

        return ;
    }
    
    
    // ok
    // send new secret to server
    [self performSelectorInBackground:@selector(changePassword) withObject:nil] ;
    
}


- (void)changePassword
{
    ResultPasel *result = [ServerRequest resetNewPassword:_tf_firstSecret.text AndWithAccount:_account] ;

    NSString *showStr = @"" ;
    
    if (!result) showStr = WD_HUD_BADNETWORK ;
    
    showStr = result.info ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [DigitInformation showWordHudWithTitle:showStr] ;
        
        if (result.code == 200) [self performSelector:@selector(popToRoot) withObject:nil afterDelay:1.0f] ;
        
    }) ;
    
}


- (void)popToRoot
{
    [self.navigationController popToRootViewControllerAnimated:YES] ;
}


@end
