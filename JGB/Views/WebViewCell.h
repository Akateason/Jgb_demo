//
//  WebViewCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewCellDelegate <NSObject>

- (void)sendDescriptionHeight:(int)height ;

@end


@interface WebViewCell : UITableViewCell <UIWebViewDelegate>

@property (nonatomic,retain) id <WebViewCellDelegate> delegate ;

@property (nonatomic,copy) NSString *html ;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webHeight;

- (void)refresh ;

@end
