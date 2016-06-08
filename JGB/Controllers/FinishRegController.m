//
//  FinishRegController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "FinishRegController.h"
#import "DigitInformation.h"
#import "User.h"
#import "ServerRequest.h"
#import "SBJson.h"
#import "MyFileManager.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "LSCommonFunc.h"

@interface FinishRegController ()
{
    User        *m_userSend ;
    int         m_checkCode ;
}
@end

@implementation FinishRegController
@synthesize tf_account,tf_nickName,tf_password,tf_checkCode ;

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
    
    m_checkCode = 0 ;
    
    tf_account.delegate     = self ;
    tf_checkCode.delegate   = self ;
    tf_password.delegate    = self ;
    tf_nickName.delegate    = self ;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --
#pragma mark - askServerSendSMS
- (void)askServerSendSMS
{
    // ask server to send SMS
    
    __block ResultPasel *result ;
    
    dispatch_queue_t queue = dispatch_queue_create("smsQueue", NULL) ;
    dispatch_async(queue, ^{
        
        result = [ServerRequest sendSMSWithPhoneNum:tf_account.text AndWithTempletCode:@"reg" AndWithKeyArray:nil] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *showStr = @"" ;
            
            if ( result.code == 200 )
            {
                showStr         = result.info ;
                m_checkCode     = [[result.data objectForKey:@"captchaString"] intValue] ;
                
                
                // 发送成功
                // 倒计时开始
                [_bt_checkCode startingCountDown] ;

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
#pragma mark - exist account or not
- (BOOL)accountExistOrNot
{
    ResultPasel *result = [ServerRequest checkAccountWithAccount:tf_account.text] ;
    if (result.code == 1)   //账号已经存在
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [DigitInformation showWordHudWithTitle:result.info] ;
        }) ;
        
        return TRUE ;
    }
    else if (!result.code)  //账号不存在,可以注册
    {
        return FALSE ;
    }
    
    return TRUE ;
}


#pragma mark --
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect tfFrame = textField.frame    ;
    int offset = tfFrame.origin.y - (self.view.frame.size.height - 285.0)   ;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    if (offset > 0)
    {
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
    
    if (textField == tf_account)
    {
        BOOL bSuccess = [Verification validateMobile:tf_account.text] ;
        if (! bSuccess)
        {
            [DigitInformation showWordHudWithTitle:@"请输入正确格式的手机号码"] ;
        }
    }
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (![self.tf_account isExclusiveTouch]||![self.tf_password isExclusiveTouch]||![self.tf_nickName isExclusiveTouch]||![self.tf_checkCode isExclusiveTouch])
    {
        [self.tf_account resignFirstResponder]      ;
        [self.tf_password resignFirstResponder]     ;
        [self.tf_nickName resignFirstResponder]     ;
        [self.tf_checkCode resignFirstResponder]    ;
        
        [self keyboardBackToBase]                   ;
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
    if ( [tf_account.text isEqualToString:@""] || !tf_account.text )
    {
        [DigitInformation showWordHudWithTitle:@"请输入您的手机号"] ;
        
        return  ;
    } else {
        [tf_checkCode becomeFirstResponder] ;
    }
    
//    ? 是否已经注册过
    dispatch_queue_t queue = dispatch_queue_create("existQueue", NULL) ;
    dispatch_async(queue, ^{
        
        BOOL bAccountExist = [self accountExistOrNot] ;
        if (bAccountExist) return ;
        
        // 发送验证码
        [self askServerSendSMS] ;
        
    }) ;
    
}



- (IBAction)submitAction:(id)sender
{
    
    if ([tf_account.text isEqualToString:@""] || tf_account.text == nil || tf_account.text == NULL)
    {
        [DigitInformation showWordHudWithTitle:@"请输入\n您的账号" ];//AndWithController:self] ;
        return ;
    }
    
    if ([tf_password.text isEqualToString:@""] || tf_password.text == nil || tf_password.text == NULL)
    {
        [DigitInformation showWordHudWithTitle:@"请输入\n您的密码"]; //AndWithController:self] ;
        return ;
    }
    
    if ([tf_nickName.text isEqualToString:@""] || tf_nickName.text == nil || tf_nickName.text == NULL)
    {
        [DigitInformation showWordHudWithTitle:@"请输入\n您的昵称"]; //AndWithController:self] ;
        return ;
    }
    
    if ([tf_checkCode.text integerValue] != m_checkCode) {
        [DigitInformation showWordHudWithTitle:@"您输入的验证码不正确"];
        return ;
    }
    

    NSLog(@"提交注册申请") ;
    
    m_userSend             = [[User alloc] init] ;
    m_userSend.accountName = tf_account.text ;
    m_userSend.password    = tf_password.text;
    m_userSend.nickName    = tf_nickName.text;
    
    // reg  server
    ResultPasel *result = [ServerRequest registerWithUser:m_userSend ];
    
    // reg  parser
    if (result.code != 200)
    {
        //reg fail
        [DigitInformation showWordHudWithTitle:[NSString stringWithFormat:@"注册失败:\n%@",result.info]]; //AndWithController:self] ;
    }
    else
    {
        //reg success
        NSLog(@"reg success") ;
        NSDictionary *dataDic = result.data ;
        
        [LSCommonFunc saveAndLoginWithResultDataDiction:dataDic AndWithViewController:self AndWithFailInfo:@"注册失败"] ;
        
    }
    
}



@end



