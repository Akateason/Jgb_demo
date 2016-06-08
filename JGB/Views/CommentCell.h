//
//  CommentCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbText;

@property (weak, nonatomic) IBOutlet UILabel *lbTime;

@property (weak, nonatomic) IBOutlet UILabel *lbColor;

@property (weak, nonatomic) IBOutlet UILabel *lbSize;


@end
