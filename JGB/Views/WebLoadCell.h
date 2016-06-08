//
//  WebLoadCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-4-8.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebLoadCellDelegate <NSObject>

- (void)setWebLoadCellHeight:(int)height ;

@end


@interface WebLoadCell : UITableViewCell <UIWebViewDelegate>

@property (nonatomic,retain) id <WebLoadCellDelegate> delegate ;

@property (nonatomic,copy) NSString *html ;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webHeight;

- (void)refresh ;

@end
