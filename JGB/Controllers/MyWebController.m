//
//  MyWebController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-10.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MyWebController.h"
#import "GoodsDetailViewController.h"
#import "YXSpritesLoadingView.h"
#import "WordsHeader.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "LSCommonFunc.h"
#import "NavRegisterController.h"
#import "DigitInformation.h"

#define LABEL_HIDEBACKBUTTON            @"&hideBackButton=1"
#define NOTIFICATION_REFRESH_WEBVIEW    @"NOTIFICATION_REFRESH_WEBVIEW"


@interface MyWebController () <UIWebViewDelegate>
{

}
@end

@implementation MyWebController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowLoginOnH5WhenAppLoginSuccessed) name:NOTIFICATION_REFRESH_WEBVIEW object:nil] ;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REFRESH_WEBVIEW object:nil] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView.autoresizesSubviews    = YES;          //自动调整大小
    _webView.autoresizingMask       = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    
    
    NSString *tempStr ;
    if (_urlStr)
    {
        if (_isActivity)
        {
            // 2 ask server everytime get hash token ;
            long long tick = [MyTick getTickWithDate:[NSDate date]] ;
            
            NSString *resultUrlStr = @"" ;
            if (G_TOKEN == nil || [G_TOKEN isEqualToString:@""])
            {
                //未登录
                resultUrlStr = [NSString stringWithFormat:@"%@?appnotlogin=1",_urlStr] ;
            } else {
                //已登录
                resultUrlStr = [LSCommonFunc getUrlWhenLoginH5WithTick:tick AndWithOrgUrl:_urlStr] ;
            }
            
            tempStr = [resultUrlStr stringByAppendingString:LABEL_HIDEBACKBUTTON] ; // hide h5 back button
        }
        else
        {
            tempStr = _urlStr ;
        }
    }
    

    
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:tempStr]] ;  //_urlStr
    [_webView loadRequest:request];
    _webView.delegate = self ;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [YXSpritesLoadingView dismiss] ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated] ;
}

#pragma mark --
#pragma mark - app login finished now login on H5
- (void)nowLoginOnH5WhenAppLoginSuccessed
{
    [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;

    
    long long tick = [MyTick getTickWithDate:[NSDate date]] ;
    NSString *resultUrlStr = [LSCommonFunc getUrlWhenLoginH5WithTick:tick AndWithOrgUrl:_urlStr] ;
    resultUrlStr = [resultUrlStr stringByAppendingString:LABEL_HIDEBACKBUTTON] ; // hide h5 back button

    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:resultUrlStr]] ;  //_urlStr
    [_webView loadRequest:request];
    
    
}

#pragma mark --
#pragma mark - web view delegate
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    [YXSpritesLoadingView dismiss] ;
}


- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
    
    [YXSpritesLoadingView dismiss] ;

    self.isNothing = YES ;
}

//判断用户点击类型
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *tempUrl = request.URL ;
    NSString *absoluteStr = [tempUrl absoluteString] ;
    NSLog(@"url str : %@", absoluteStr) ;

    if ([absoluteStr isEqualToString:@"http://m.jgb.cn/"])
    {
        //去登录, app登录成功后, 登录h5
        if (G_TOKEN == nil || [G_TOKEN isEqualToString:@""])
        {
            [NavRegisterController goToLoginFirstWithCurrentController:self AppLoginFinished:YES] ;
        }
        
        return NO ;
    }
    
    switch (navigationType)
    {
            //点击连接
        case UIWebViewNavigationTypeLinkClicked:
        {
            NSLog(@"clicked");
            
            if (!tempUrl) return YES ;
            
            NSString *sepStr = @"?sku=" ;
            
            if ([[absoluteStr componentsSeparatedByString:sepStr] count] <= 1) {
                return YES ;
            }
            
            NSString *goodsCode = [[absoluteStr componentsSeparatedByString:sepStr] lastObject];
            
            [self goIntoGoodsDetail:goodsCode] ;

            return NO ;
        }
            break ;
            //提交表单
        case UIWebViewNavigationTypeFormSubmitted:
        {
            NSLog(@"submitted");
        }
            break ;
        default:
            break;
    }
    
    return YES;
}


#pragma mark --
#pragma mark - goIntoGoodsDetail
- (void)goIntoGoodsDetail:(NSString *)codeGoods
{
    [self performSegueWithIdentifier:@"web2GoodDetail" sender:codeGoods] ;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"web2GoodDetail"])
    {
        GoodsDetailViewController *detailCtrller = (GoodsDetailViewController *)[segue destinationViewController] ;
        detailCtrller.codeGoods = (NSString *)sender ;
    }
    
}


@end
