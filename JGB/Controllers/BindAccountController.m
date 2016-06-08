 //
//  BindAccountController.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-22.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "BindAccountController.h"
#import "ServerRequest.h"
#import "LSCommonFunc.h"
#import "BindAlreadyController.h"
#import <AKATeasonFramework/AKATeasonFramework.h>


@interface BindAccountController () <UITextFieldDelegate>
{
    int         m_checkCode ;

}
@end

@implementation BindAccountController

- (void)setup
{
    _bgView.layer.cornerRadius = 4.0f ;
    self.view.backgroundColor  = COLOR_BACKGROUND ;
    
    _tf_checkCode.delegate  = self ;
    _tf_secret.delegate     = self ;
    _tf_telNum.delegate     = self ;
    
    _tf_secret.secureTextEntry = YES ;
    
    
    [_bt_bindAlready setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal] ;
    
    UIBarButtonItem *skipButton = [[UIBarButtonItem alloc] initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(skipAction)] ;
    self.navigationItem.rightBarButtonItem = skipButton ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup] ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    self.navigationController.navigationBar.translucent = YES ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - ask Server Send SMS
- (void)askServerSendSMS
{
    // ask server to send SMS
    
    __block ResultPasel *result ;
    
    dispatch_queue_t queue = dispatch_queue_create("smsQueue", NULL) ;
    dispatch_async(queue, ^{
        
        result = [ServerRequest sendSMSWithPhoneNum:_tf_telNum.text AndWithTempletCode:@"reg" AndWithKeyArray:nil] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *showStr = @"" ;
            
            if (result.code == 200)
            {
                showStr         = result.info ;
                m_checkCode     = [[result.data objectForKey:@"captchaString"] intValue] ;
                [_bt_sms startingCountDown] ;
            }
            else
            {
                showStr = @"发送失败" ;
            }
            
            [DigitInformation showWordHudWithTitle:showStr] ;
            
        }) ;
        
    }) ;
    
}


#pragma mark --
#pragma mark - Actions
//  短信验证
- (IBAction)smsClickedAction:(id)sender
{
    NSLog(@"%s",__func__) ;
    
    if ( [_tf_telNum.text isEqualToString:@""] || !_tf_telNum.text )
    {
        [DigitInformation showWordHudWithTitle:@"请输入您的手机号"] ;
        
        return  ;
    }
    else {
        [_tf_checkCode becomeFirstResponder] ;
    }
    
    [self askServerSendSMS] ;
}




//  创建新用户
- (IBAction)createNewUserAction:(id)sender
{
    NSLog(@"%s",__func__) ;
    
    if ([_tf_telNum.text isEqualToString:@""] || _tf_telNum.text == nil || _tf_telNum.text == NULL)
    {
        [DigitInformation showWordHudWithTitle:@"请输入\n您的手机号" ];//AndWithController:self] ;
        return ;
    }
    
    if ([_tf_secret.text isEqualToString:@""] || _tf_secret.text == nil || _tf_secret.text == NULL)
    {
        [DigitInformation showWordHudWithTitle:@"请输入\n您的密码"]; //AndWithController:self] ;
        return ;
    }
    
    if ([_tf_checkCode.text integerValue] != m_checkCode)
    {
        [DigitInformation showWordHudWithTitle:@"您输入的验证码不正确"];
        return ;
    }
    
    
    //验证此账号, 是否是一个新账号
    dispatch_queue_t queue = dispatch_queue_create("checkAccount", NULL) ;
    dispatch_async(queue, ^{
        
        ResultPasel *resultCheckAccount = [ServerRequest checkAccountWithAccount:_tf_telNum.text] ;
        
        if (resultCheckAccount.code == 0)
        {
            //账号不存在, 是一个新账号
            ResultPasel *resultRegAccount = [ServerRequest thirdLoginRegisterConnectWithThirdLoginObj:_loginObj AndWithPhone:_tf_telNum.text AndWithPassword:_tf_secret.text] ;
            
            if (resultRegAccount.code == 200)
            {
                // success ;
                [LSCommonFunc saveAndLoginWithResultDataDiction:resultRegAccount.data AndWithViewController:self AndWithFailInfo:nil] ;
            }
            else
            {
                NSLog(@"info : %@", resultRegAccount.info) ;
            }
        }
        else
        {
            //账号已存在, 或者其他情况
            [DigitInformation showWordHudWithTitle:resultCheckAccount.info] ;
            return ;
        }
        
    }) ;
    
}

//  跳过
- (void)skipAction
{
    NSLog(@"%s",__func__) ;
    
    //跳过, 新建空账号
    ResultPasel *result = [ServerRequest thirdLoginCreateConnectWithThirdLoginObj:_loginObj] ;
    
    
    if (result.code == 200)
    {
        // success ;
        [LSCommonFunc saveAndLoginWithResultDataDiction:result.data AndWithViewController:self AndWithFailInfo:nil] ;
    }
    else
    {
        NSLog(@"info : %@", result.info) ;
    }
}

//绑定已有jgb账号
- (IBAction)bingAlreadyAction:(id)sender
{
    [self performSegueWithIdentifier:@"bind2bindAlready" sender:_loginObj] ;
}


#pragma mark --
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField resignFirstResponder])
    {
        [self keyboardBackToBase];
    }
    
    if (textField == _tf_telNum)
    {
        BOOL bSuccess = [Verification validateMobile:_tf_telNum.text] ;
        if (! bSuccess)
        {
            [DigitInformation showWordHudWithTitle:@"请输入正确格式的手机号码"] ;
        }
    }
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((![_tf_checkCode isExclusiveTouch])||(![_tf_secret isExclusiveTouch])||(![_tf_telNum isExclusiveTouch]))
    {
        [_tf_checkCode  resignFirstResponder];
        [_tf_secret     resignFirstResponder];
        [_tf_telNum     resignFirstResponder];
        
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


 #pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"bind2bindAlready"])
    {
        BindAlreadyController *alreadyVC = (BindAlreadyController *)[segue destinationViewController] ;
        alreadyVC.loginObj = (BindThirdLogin *)sender ;
    }
    
}
 

@end
