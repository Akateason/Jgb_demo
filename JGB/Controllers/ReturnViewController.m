//
//  ReturnViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "ReturnViewController.h"
#import "DigitInformation.h"
#import "ServerRequest.h"
#import "YXSpritesLoadingView.h"

@interface ReturnViewController ()

@end

@implementation ReturnViewController

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
    
    
    [_tf_emailAddr anyStyle] ;
    _tf_emailAddr.backgroundColor = [UIColor whiteColor] ;
    _tf_emailAddr.textColor = [UIColor lightGrayColor] ;
    _tf_emailAddr.layer.cornerRadius = 0 ;
    
    [_tv_contents anyStyle] ;
    _tv_contents.backgroundColor = [UIColor whiteColor] ;
    _tv_contents.textColor = [UIColor lightGrayColor] ;
    _tv_contents.layer.cornerRadius = 0 ;
    
    _backView.layer.borderWidth = 1.0f ;
    _backView.layer.borderColor = COLOR_BACKGROUND.CGColor ;
    _backView.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _backView.backgroundColor = [UIColor whiteColor] ;
    _backView.layer.masksToBounds = YES ;
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


#pragma mark --
#pragma mark - text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect tfFrame = textView.frame;
    int offset = tfFrame.origin.y - (self.view.frame.size.height - 285.0);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    if (offset > 0) {
        self.view.frame = CGRectMake(0.0f, - offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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
    
}


#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.tv_contents isExclusiveTouch]||![self.tf_emailAddr isExclusiveTouch])
    {
        [self.tv_contents  resignFirstResponder];
        [self.tf_emailAddr resignFirstResponder];
        
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



- (IBAction)iwantSendAction:(id)sender
{
//    * 1001 标题为空, 1002 内容为空, 1003 邮箱为空
    
    __block int code = 0;
    __block NSString *strShow = @"" ;
    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:YES] ;
    [DigitInformation showHudWhileExecutingBlock:^{
        
        code = [ServerRequest sendUserFeedBackWithEmail:_tf_emailAddr.text AndWithTitle:@"用户反馈" AndWithContent:_tv_contents.text] ;

    } AndComplete:^{
        
        [YXSpritesLoadingView dismiss] ;
        
        switch (code) {
            case 0:
            {
                strShow = WD_HUD_BADNETWORK ;
            }
                break;
            case 1001:
            {
                strShow = @"标题为空" ;
            }
                break;
            case 1002:
            {
                strShow = @"内容为空";
            }
                break;
            case 1003:
            {
                strShow = @"邮箱为空";
            }
                break;
            case 200:
            {
                strShow = @"发送成功";
            }
                break;
                
            default:
                break;
        }
        
        [DigitInformation showWordHudWithTitle:strShow] ;

        if (code == 200) {
            //success
            [self.navigationController popViewControllerAnimated:YES] ;
        }

    } AndWithMinSec:0] ;
    
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

@end
