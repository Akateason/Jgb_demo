//
//  LoginFirstController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-7.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "LoginFirstController.h"
#import "DigitInformation.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import "YXSpritesLoadingView.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "BindThirdLogin.h"
#import "LSCommonFunc.h"
#import "BindAccountController.h"
#import "WXApi.h"
#import "ServerRequest.h"
#import "ColorsHeader.h"
#import "PlatformInfomation.h"
#import "MyFileManager.h"


@interface LoginFirstController () <UITextFieldDelegate>
{
    NSArray         *_permissions   ;
    TencentOAuth    *_tencentOAuth  ;
}
// third login
@property (weak, nonatomic) IBOutlet UIButton *weixinLog;
@property (weak, nonatomic) IBOutlet UIButton *qqLog;
@property (weak, nonatomic) IBOutlet UIButton *weiboLog;
@property (weak, nonatomic) IBOutlet UILabel *lb_weibo ;
@property (weak, nonatomic) IBOutlet UILabel *lb_weixin ;
@property (weak, nonatomic) IBOutlet UILabel *lb_qq ;

//third login
- (IBAction)pressedAnyButton:(id)sender ;

@property (weak, nonatomic) IBOutlet UIImageView *img_logo;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIView *backView_tf;
@property (weak, nonatomic) IBOutlet MyTextField *tf_account;
@property (weak, nonatomic) IBOutlet MyTextField *tf_secret;

//reg but
@property (weak, nonatomic) IBOutlet UIButton *bt_regist        ;
//forget secret
@property (weak, nonatomic) IBOutlet UIButton *bt_forgetSecret  ;

//立即登录
@property (weak, nonatomic) IBOutlet UIButton *bt_loginNow;

- (IBAction)forgetSecretAction:(id)sender;
- (IBAction)registAction:(id)sender;
- (IBAction)backPressedAction:(id)sender;
- (IBAction)loginNowPressedAction:(UIButton *)sender;

@end

@implementation LoginFirstController

@synthesize weiboLog,qqLog,weixinLog ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiboLogCallBack:) name:NOTIFICATION_WEIBO_CALLBACK object:nil] ;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_WEIBO_CALLBACK object:nil] ;
}

- (void)setMyViews
{
    self.view.backgroundColor = COLOR_PINK ;
    
    _backView_tf.layer.cornerRadius = CORNER_RADIUS_ALL ;
    _backView_tf.layer.masksToBounds = YES ;
    _backView_tf.layer.borderColor = COLOR_BACKGROUND.CGColor ;
    _backView_tf.layer.borderWidth = 1.0f ;
    
    [_bt_loginNow setTitleColor:COLOR_PINK forState:UIControlStateNormal] ;
    _bt_loginNow.backgroundColor = [UIColor whiteColor] ;
    _bt_loginNow.layer.cornerRadius = CORNER_RADIUS_ALL ;

    _tf_account.layer.borderColor = COLOR_BACKGROUND.CGColor ;
    _tf_account.layer.borderWidth = 0.5f ;
    _tf_secret.layer.borderColor = COLOR_BACKGROUND.CGColor ;
    _tf_secret.layer.borderWidth = 0.5f ;
    
    [_tf_secret     anyStyle] ;
    [_tf_account    anyStyle] ;
    _tf_secret.secureTextEntry = YES ;
    
    _tf_account.delegate = self ;
    _tf_secret.delegate = self ;
}


- (IBAction)forgetSecretAction:(id)sender
{
    [self performSegueWithIdentifier:@"logfirst2forget" sender:nil] ;
}

- (IBAction)registAction:(id)sender
{
    [self performSegueWithIdentifier:@"logfir2reg" sender:nil] ;
}

- (IBAction)backPressedAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil] ;
}

- (IBAction)loginNowPressedAction:(UIButton *)sender
{
    [_tf_account resignFirstResponder];
    [_tf_secret  resignFirstResponder];
    //
    NSLog(@"立即登录") ;
    //
    if  (  (_tf_account.text == NULL) || (_tf_account.text == nil) || ([_tf_account.text isEqualToString:@""]) )
    {
        [DigitInformation showWordHudWithTitle:@"请输入您的账号"];// AndWithController:self] ;
        return ;
    }
    else if ( (_tf_secret.text == NULL) || (_tf_secret.text == nil) || ([_tf_secret.text isEqualToString:@""]) )
    {
        [DigitInformation showWordHudWithTitle:@"请输入您的密码"]; //AndWithController:self] ;
        return ;
    }
    
    __block User *userSend = [[User alloc] init] ;
    userSend.accountName   = _tf_account.text    ;
    userSend.password      = _tf_secret.text     ;
    
    __block NSString    *mytoken    ;
    __block NSString    *showInfo   ;
    
    dispatch_queue_t queue = dispatch_queue_create("loginQueue", NULL) ;
    dispatch_async(queue, ^{
        
        // login
        ResultPasel *result = [ServerRequest getAuthorizeWithUserName:userSend.accountName AndWithPassword:userSend.password] ;
        
        if (result.code == 200)
        {
            NSString *tempCode = [result.data objectForKey:@"code"] ;
            mytoken = [ServerRequest getAccessTokenWithTempCode:tempCode] ;
        }
        
        showInfo = (!result) ? @"登录失败" : result.info ;
        
        //login finished
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loginFinished:mytoken AndUser:userSend AndShowInfo:showInfo] ;
        }) ;

    }) ;
    
    
}


- (void)loginFinished:(NSString *)mytoken AndUser:(User *)userSend AndShowInfo:(NSString *)info
{
    if (mytoken == nil)
    {
        [DigitInformation showWordHudWithTitle:info] ;
    }
    else
    {
        NSLog(@"login success")     ;
        
        G_TOKEN         = mytoken   ;
        G_USER_CURRENT  = nil       ;
        
        [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:YES andBlurEffect:NO] ;
        
        [DigitInformation showHudWhileExecutingBlock:^{
            
            NSString *homePath = NSHomeDirectory() ;
            NSString *path = [homePath stringByAppendingPathComponent:PATH_TOKEN_SAVE] ;
            [MyFileManager archiveTheObject:mytoken AndPath:path] ;
            
            NSString *lastLogPath = [homePath stringByAppendingPathComponent:PATH_LAST_TOKEN] ;
            [MyFileManager archiveTheObject:mytoken AndPath:lastLogPath] ;
            
            [[DigitInformation shareInstance] g_currentUser] ;
            
        } AndComplete:^{
            
            [YXSpritesLoadingView dismiss] ;
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_WEBVIEW object:nil] ;
            }] ;
            
        } AndWithMinSec:FLOAT_HUD_MINSHOW] ;
        
    }
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.0

    self.title = @"登录中心" ;
//

    
//
    [self setMyViews]       ;
    
//
    [self qqLoginSetup]     ;
    
//
    if (!G_BOOL_OPEN_APPSTORE)
    {
        qqLog.hidden = YES ;
        weiboLog.hidden = YES ;
        _lb_qq.hidden = YES ;
        _lb_weibo.hidden = YES ;
        weixinLog.hidden  = YES ;
        _lb_weixin.hidden = YES ;
    }
}

- (void)qqLoginSetup
{
    _permissions = [NSArray arrayWithObjects:
                    kOPEN_PERMISSION_GET_USER_INFO,
                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                    nil] ;
/*
    kOPEN_PERMISSION_ADD_ALBUM,
    kOPEN_PERMISSION_ADD_IDOL,
    kOPEN_PERMISSION_ADD_ONE_BLOG,
    kOPEN_PERMISSION_ADD_PIC_T,
    kOPEN_PERMISSION_ADD_SHARE,
    kOPEN_PERMISSION_ADD_TOPIC,
    kOPEN_PERMISSION_CHECK_PAGE_FANS,
    kOPEN_PERMISSION_DEL_IDOL,
    kOPEN_PERMISSION_DEL_T,
    kOPEN_PERMISSION_GET_FANSLIST,
    kOPEN_PERMISSION_GET_IDOLLIST,
    kOPEN_PERMISSION_GET_INFO,
    kOPEN_PERMISSION_GET_OTHER_INFO,
    kOPEN_PERMISSION_GET_REPOST_LIST,
    kOPEN_PERMISSION_LIST_ALBUM,
    kOPEN_PERMISSION_UPLOAD_PIC,
    kOPEN_PERMISSION_GET_VIP_INFO,
    kOPEN_PERMISSION_GET_VIP_RICH_INFO,
    kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
    kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
*/
    
    NSString *appid = kAppID_QQ ;
    
    _tencentOAuth   = [[TencentOAuth alloc] initWithAppId:appid
                                              andDelegate:self];
    
//    _tencentOAuth.redirectURI   = @"www.jgb.com" ;
    
    _tencentOAuth.localAppId    = kAppID_QQ     ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self animation] ;
}


- (void)animation
{
    CABasicAnimation *animaiton = [TeaAnimation verticalRotationWithDuration:0.15f degree:90 direction:1 repeatCount:2] ;
    [_img_logo.layer addAnimation:animaiton forKey:@"loginHeadAnimation"] ;
    
    
    CABasicAnimation *flash = [TeaAnimation opacityForever_Animation:1.0] ;
    [_lb_title.layer addAnimation:flash forKey:@"flashAnimation"] ;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}



#pragma mark --
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect tfFrame = textField.frame;
    int offset = tfFrame.origin.y - (self.view.frame.size.height - 285.0);
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
}

#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((![_tf_account isExclusiveTouch])||(![_tf_secret isExclusiveTouch]))
    {
        [_tf_secret  resignFirstResponder];
        [_tf_account resignFirstResponder];
        
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
// 第三方登录
- (IBAction)pressedAnyButton:(id)sender
{
    UIButton *bt = (UIButton *)sender ;
    NSLog(@"tag : %d",bt.tag);
    switch (bt.tag)
    {
        case TAG_WEIXIN_LOG:
        {
            G_WX_LOGIN_BOOL = YES ;
            
            //构造SendAuthReq结构体
            SendAuthReq* req = [[SendAuthReq alloc ] init] ;
            req.scope = @"snsapi_userinfo" ;
            req.state = @"123" ;
            //第三方向微信终端发送一个SendAuthReq消息结构
            [WXApi sendReq:req] ;
        }
            break;
        case TAG_QQ_LOG:
        {
            G_QQ_LOGIN_BOOL = YES ;
            
            [_tencentOAuth authorize:_permissions inSafari:NO];
        }
            break;
        case TAG_WEIBO_LOG:
        {
            G_WEIBO_LOGIN_BOOL = YES ;
            
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kRedirectURI;
            request.scope = @"all";
            
            [WeiboSDK sendRequest:request];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - TencentSessionDelegate - TECENT QQ SDK CALL BACK
/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin
{
    // 登录成功
    NSLog(@"登录完成") ;
    
    if ( (_tencentOAuth.accessToken) && (0 != [_tencentOAuth.accessToken length]) )
    {
        NSLog(@"_tencentOAuth.accessToken: %@",_tencentOAuth.accessToken) ;
        
        [_tencentOAuth getUserInfo] ;
    }
    else
    {
        NSLog(@"登录失败 没有获取accesstoken") ;
        [DigitInformation showWordHudWithTitle:@"登录失败,请检查网络,再试一次"] ;
    }
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"用户取消登录") ;
    }
    else
    {
        NSLog(@"登录失败") ;
    }
}


/**
 * Called when the notNewWork.
 */
- (void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络") ;
}


/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse *) response
{
    NSLog(@"get QQ user info : %@",response) ;
    
    G_QQ_LOGIN_BOOL = NO ;

    
    NSString *qq_token  = [_tencentOAuth accessToken] ;
    NSString *user      = [_tencentOAuth openId] ;
    NSLog(@"user : %@",user) ;
    
    NSDate *expireDate  = [_tencentOAuth expirationDate] ;
    long long expireEnd = [MyTick getTickWithDate:expireDate]       ;
    long long nowTick   = [MyTick getTickWithDate:[NSDate date]]    ;
    long long deta      = expireEnd - nowTick ;
    
    NSString *expireIn  = [NSString stringWithFormat:@"%lld",deta] ;
    
    NSDictionary *jsonResponse = response.jsonResponse ;
    NSLog(@"jsonResponse : %@",jsonResponse) ;
    NSString *qq_username = [jsonResponse objectForKey:@"nickname"] ;
    NSString *gender = [jsonResponse objectForKey:@"gender"] ;
    int qq_sex = [LSCommonFunc boyGirlStr2Num:gender] ;
    
    BindThirdLogin *bindThirdlogin = [[BindThirdLogin alloc] initWithQQUserName:qq_username AndWithQQUserSex:qq_sex AndWithQQUser:user AndWithAccessToken:qq_token AndWithExpireIn:expireIn] ;
//
    [self thirdBindLoginFuctionWithLoginObj:bindThirdlogin] ;
}


#pragma mark --
#pragma mark - weibo Log Call Back
/**********************************************************************
object
BindThirdLogin *bindLogin
***********************************************************************/
- (void)weiboLogCallBack:(NSNotification *)notification
{
    BindThirdLogin *bindLogin = (BindThirdLogin *)notification.object ;

    [self thirdBindLoginFuctionWithLoginObj:bindLogin] ;
}


#pragma mark --
#pragma mark - third Bind Login Fuction
- (void)thirdBindLoginFuctionWithLoginObj:(BindThirdLogin *)bindLogin
{
    ResultPasel *result = [ServerRequest thirdLoginCheckConnectWithThirdLoginObj:bindLogin] ;
    
    if (result.code == 200)
    {
        NSLog(@"已绑定过jgb账号") ;
        //  @"1"    1代表, 已经绑定过, 直接登录 , 传递resultdata
        [LSCommonFunc saveAndLoginWithResultDataDiction:result.data AndWithViewController:self AndWithFailInfo:nil] ;
    }
    else if (result.code == 404)
    {
        NSLog(@"还未绑定过jgb账号") ;
        //  @"0"    0代表, 未绑定账号      , 传递第三方登录对象
        
        [self performSegueWithIdentifier:@"logfirst2bindaccount" sender:bindLogin] ;
    }
    else
    {
        NSLog(@"info : %@",result.info) ;
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"logfirst2bindaccount"])
    {
        BindThirdLogin *bindLogin = (BindThirdLogin *)sender ;
        BindAccountController *bindAccontVC = (BindAccountController *)[segue destinationViewController] ;
        bindAccontVC.loginObj = bindLogin ;
    }
    
}



@end
