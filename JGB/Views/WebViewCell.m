//
//  WebViewCell.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "WebViewCell.h"
#import "ColorsHeader.h"


@implementation WebViewCell


- (void)awakeFromNib
{
    // Initialization code
//    
    self.backgroundColor = COLOR_BACKGROUND ;

    
    _webView.delegate = self ;
    _webView.autoresizesSubviews = YES;             //自动调整大小
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    _webView.scalesPageToFit =YES;                //自动对页面进行缩放以适应屏幕
    _webView.scrollView.scrollEnabled = NO ;

}




- (void)setHtml:(NSString *)html
{
    _html = html ;
    
//    NSLog(@"html :%@",_html) ;
    
}

- (void)refresh
{
    [_webView loadHTMLString:self.html baseURL:nil];

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    int height = [height_str intValue] ;
    webView.frame = CGRectMake(0,0,320,height) ;
    
    NSLog(@"webView cell height: %@", height_str);
    
    self.webHeight.constant = height ;
    
    [self.delegate sendDescriptionHeight:height] ;
}

@end
