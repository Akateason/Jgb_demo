//
//  WebLoadCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-8.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import "WebLoadCell.h"
#import "ColorsHeader.h"
#import "DigitInformation.h"



@implementation WebLoadCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib] ;

    self.backgroundColor = COLOR_BACKGROUND ;

    _webView.autoresizesSubviews    = YES;
    
    _webView.autoresizingMask       = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    _webView.scrollView.scrollEnabled = NO ;
    _webView.delegate = self ;
    
    _webHeight.constant = APPFRAME.size.height - 35 - 12 ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHtml:(NSString *)html
{
    _html = html ;
}

- (void)refresh
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_html]] ;
    [_webView loadRequest:request];
    
//    NSString *resultStr = [NSString stringWithFormat:@"%@%@%@%@",H5,CSSSTR,SCRIPTSTR,[DigitInformation shareInstance].g_urlSizeGuige] ;
//    [_webView loadHTMLString:resultStr baseURL:nil];
    
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
//    [YXSpritesLoadingView dismiss] ;
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    int height = [height_str intValue] ;
    
    if (height < APPFRAME.size.height - 35 ) {
        height = APPFRAME.size.height - 20 ;
    }
    
    webView.frame = CGRectMake(0,0,320,height) ;
    
    NSLog(@"webView cell height: %@", height_str);
    
    self.webHeight.constant = height ;
    
    [self.delegate setWebLoadCellHeight:height] ;
}


- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError:%@", error);
    
//    [YXSpritesLoadingView dismiss] ;
    
}


@end
