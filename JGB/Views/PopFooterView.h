//
//  PopFooterView.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-2-28.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopFooterView : UIView

//attrs
@property (nonatomic,copy) NSString *strContent ;

//views
@property (weak, nonatomic) IBOutlet UILabel *lb_content;

+ (float)getPopFooterViewHeightWithContent:(NSString *)str ;


@end
