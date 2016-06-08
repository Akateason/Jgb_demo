//
//  ForgetSecretController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ForgetSecretController.h"
#import "DigitInformation.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "ServerRequest.h"
#import "MyFileManager.h"
#import "ChangeSecretViewController.h"

@interface ForgetSecretController ()
{
    int         m_checkCode ;
    
//    NSString    *m_account ;
    
}
@end

@implementation ForgetSecretController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"忘记密码" ;
        
    m_checkCode = 0 ;
    
//    m_account = @"" ;
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect tfFrame = textField.frame;
    int offset = tfFrame.origin.y - (self.view.frame.size.height - 285.0);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    if (offset > 0) {
        self.view.frame = CGRectMake(0.0f, - offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self keyboardBackToBase];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField resignFirstResponder])
    {
        [self keyboardBackToBase];
    }
    
    if (textField == _tf_imputPhoneNum)
    {
        BOOL bSussess = [Verification validateMobile:textField.text] ;
        if (!bSussess)
        {
            [DigitInformation showWordHudWithTitle:@"请输入正确格式的手机号码"] ;
        }
    }
    
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.tf_imputPhoneNum isExclusiveTouch])
    {
        [self.tf_imputPhoneNum resignFirstResponder];
        [self keyboardBackToBase];
    }
}

- (void)keyboardBackToBase
{
    [UIView beginAnimations:@"ReturnKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark --
#pragma mark - Actions
- (IBAction)checkCodeAction:(id)sender
{
    if ( [_tf_imputPhoneNum.text isEqualToString:@""] || !_tf_imputPhoneNum.text ) {
        [DigitInformation showWordHudWithTitle:@"请输入手机号码"] ;
        return ;
    } else {
        [_tf_checkCode becomeFirstResponder] ;
    }
    
    __block ResultPasel *result ;
    dispatch_queue_t queue = dispatch_queue_create("checkAcountQueue", NULL) ;
    dispatch_async(queue, ^{
        
        result = [ServerRequest checkAccountWithAccount:_tf_imputPhoneNum.text] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result.code == 1)
            {
                [self askServerSendSMS] ;
            }
            else
            {
                [DigitInformation showWordHudWithTitle:@"该账号未绑定手机"] ;
            }
        }) ;
    
    }) ;
    
}


- (void)askServerSendSMS
{
    // ask server to send SMS
    
    __block ResultPasel *result ;
    
    dispatch_queue_t queue = dispatch_queue_create("smsQueue", NULL) ;
    dispatch_async(queue, ^{
        
        result = [ServerRequest sendSMSWithPhoneNum:_tf_imputPhoneNum.text AndWithTempletCode:@"reg" AndWithKeyArray:nil] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *showStr = @"" ;
            
            if (result.code == 200)
            {
                showStr         = result.info ;
                m_checkCode     = [[result.data objectForKey:@"captchaString"] intValue] ;
                
                // 发送成功
                // 倒计时开始
                [_bt_checkCode startingCountDown] ;
            }
            else
            {
                showStr = result.info ;
            }
            
            [DigitInformation showWordHudWithTitle:showStr] ;

        }) ;

    }) ;


}



- (IBAction)nextAction:(id)sender
{
    NSLog(@"下一步") ;
    
    if ([_tf_imputPhoneNum.text isEqualToString:@""] || !_tf_imputPhoneNum.text || (_tf_imputPhoneNum.text == NULL))
    {
        [DigitInformation showWordHudWithTitle:@"请输入您的手机号码"] ;
        return ;
    }
    if ([_tf_checkCode.text isEqualToString:@""] || !_tf_checkCode.text || (_tf_checkCode.text == NULL))
    {
        [DigitInformation showWordHudWithTitle:@"请输入您收到的验证码"] ;
        return ;
    }
    if ( [_tf_checkCode.text intValue] != m_checkCode )
    {
        [DigitInformation showWordHudWithTitle:@"您输入的验证码错误"] ;
        return ;
    }
    
    //
    
    [self performSegueWithIdentifier:@"forget2changeSecret" sender:_tf_imputPhoneNum.text] ;
    
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
     ChangeSecretViewController *changeVC = (ChangeSecretViewController *)[segue destinationViewController] ;
     changeVC.account = (NSString *)sender ;
}


@end
