//
//  BindAlreadyController.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-23.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "BindAlreadyController.h"
#import "ServerRequest.h"
#import "LSCommonFunc.h"

@interface BindAlreadyController () <UITextFieldDelegate>

@end

@implementation BindAlreadyController


- (void)setup
{
    _bgView.layer.cornerRadius = 4.0f ;
    self.view.backgroundColor = COLOR_BACKGROUND ;
    
    _tf_account.delegate  = self ;
    _tf_password.delegate = self ;
    
    _tf_password.secureTextEntry = YES ;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"绑定已有账号"  ;
    
    [self setup] ;
    
    _tf_account.text = @"" ;    //@"15000710541" ;
    _tf_password.text = @"";    //@"0000000" ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    self.navigationController.navigationBar.translucent = YES ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - ACTIONS
- (IBAction)bindNowAction:(id)sender
{
    // 检查此jgb老账号是否绑定过第三方账号
    ResultPasel *resultCheckBind = [ServerRequest thirdLoginCheckBindWithThirdLoginObj:_loginObj AndAccount:_tf_account.text AndWithPassword:_tf_password.text]  ;
    //[ServerRequest thirdLoginCheckBindWithConnectType:_loginObj.type AndWithAccount:_tf_account.text AndWithPassword:_tf_password.text] ;
    
    if ( resultCheckBind.code == 0 )
    {
        //== 0还没绑定第三方账号
        ResultPasel *resultBind = [ServerRequest thirdLoginBindWithThirdLoginObj:_loginObj AndWithAccount:_tf_account.text AndWithPassword:_tf_password.text] ;
        //[ServerRequest thirdLoginBindWithConnectType:_loginObj.type AndWithConnectUser:_loginObj.user AndWithConnectAccessToken:_loginObj.token_Third AndWithAccount:_tf_account.text AndWithPassword:_tf_password.text AndConnectRefreshToken:_loginObj.refreshToken AndWithConnectRemindIn:_loginObj.remindIn AndWithExpiresIn:_loginObj.expireIn] ;
        
        if (resultBind.code == 200)
        {
            // success ;
            [LSCommonFunc saveAndLoginWithResultDataDiction:resultBind.data AndWithViewController:self AndWithFailInfo:nil] ;
        }
        else
        {
            [DigitInformation showWordHudWithTitle:resultBind.info] ;
            return ;
        }
            
    }
    else if ( resultCheckBind.code == 1 )
    {
        //== 1已经绑定第三方账号
        [DigitInformation showWordHudWithTitle:WD_THIRD_BIND_AGAIN] ;
    }
    else
    {
        [DigitInformation showWordHudWithTitle:resultCheckBind.info] ;
    }
    
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
    if (![textField resignFirstResponder]) {
        [self keyboardBackToBase];
    }
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((![_tf_account isExclusiveTouch])||(![_tf_password isExclusiveTouch]))
    {
        [_tf_account resignFirstResponder];
        [_tf_password resignFirstResponder];
        
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



@end
