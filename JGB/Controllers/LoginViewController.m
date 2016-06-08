//
//  LoginViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "LoginViewController.h"
#import "DigitInformation.h"
#import "ServerRequest.h"
#import "SBJson.h"
#import "User.h"
#import "IndexViewController.h"
#import "YXSpritesLoadingView.h"
#import "MyFileManager.h"

@interface LoginViewController ()
{
    User *m_userSend ;
}
@end

@implementation LoginViewController

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
    
    self.title = @"登录" ;

    
    _tf_password.secureTextEntry = YES;


    _tf_username.text = @"";        //@"max.yang@jingubang.com";  //@"15189995158";     //@"447944439@qq.com" ;
    _tf_password.text = @"";        //@"115119";                  //@"123456";          //@"11sb11" ;
    
    _bgView.layer.cornerRadius  = 4.0f ;
    _bgView.layer.masksToBounds = YES ;
    
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
#pragma mark - Actions
- (IBAction)loginActionPressed:(id)sender {
    [self.tf_password resignFirstResponder];
    [self.tf_username resignFirstResponder];
    NSLog(@"立即登录") ;
    //
    if  (  (_tf_username.text == NULL) || (_tf_username.text == nil) || ([_tf_username.text isEqualToString:@""]) )
    {
        [DigitInformation showWordHudWithTitle:@"请输入您的账号"];// AndWithController:self] ;
        return ;
    }
    else if ( (_tf_password.text == NULL) || (_tf_password.text == nil) || ([_tf_password.text isEqualToString:@""]) )
    {
        [DigitInformation showWordHudWithTitle:@"请输入您的密码"]; //AndWithController:self] ;
        return ;
    }
    m_userSend = [[User alloc] init] ;
    m_userSend.accountName = _tf_username.text ;
    m_userSend.password    = _tf_password.text ;
    // login
    ResultPasel *result = [ServerRequest getAuthorizeWithUserName:_tf_username.text AndWithPassword:_tf_password.text] ;
    NSString *tempCode = result.data ;
    NSString *mytoken  = [ServerRequest getAccessTokenWithTempCode:tempCode] ;
    
    if (mytoken == nil)
    {
        [DigitInformation showWordHudWithTitle:[NSString stringWithFormat:@"登录失败"]] ;
    }
    else
    {
        NSLog(@"login success") ;
        G_TOKEN = mytoken ;
        G_USER_CURRENT = m_userSend ;

        [YXSpritesLoadingView showWithText:WD_HUD_LOGINSUCESS andShimmering:YES andBlurEffect:NO] ;
        
        [DigitInformation showHudWhileExecutingBlock:^{
            
            NSString *homePath = NSHomeDirectory() ;
            NSString *path = [homePath stringByAppendingPathComponent:PATH_TOKEN_SAVE] ;
            [MyFileManager archiveTheObject:mytoken AndPath:path] ;
            
            NSString *lastLogPath = [homePath stringByAppendingPathComponent:PATH_LAST_TOKEN] ;
            [MyFileManager archiveTheObject:mytoken AndPath:lastLogPath] ;
            
            [ServerRequest getMemberCenterMyInfo] ;
            
        } AndComplete:^{
            
            [YXSpritesLoadingView dismiss] ;

            [self dismissViewControllerAnimated:YES completion:^{}] ;
            
//            [self.navigationController popToRootViewControllerAnimated:YES] ;
            
        } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
        
    }
    
}


- (IBAction)forgetSecret:(id)sender {
    NSLog(@"忘记密码") ;
    [self performSegueWithIdentifier:@"log2forget" sender:nil];
}

- (IBAction)regVipAction:(id)sender {
    NSLog(@"注册会员") ;
    [self performSegueWithIdentifier:@"log2reg" sender:nil];
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
    if ((![self.tf_password isExclusiveTouch])||(![self.tf_username isExclusiveTouch]))
    {
        [self.tf_password resignFirstResponder];
        [self.tf_username resignFirstResponder];

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



