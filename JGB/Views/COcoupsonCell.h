//
//  COcoupsonCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-12-12.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface COcoupsonCell : UITableViewCell


/*
 ******  isReadOnly  ******
 *  yes -- readonly         hide right arrow img
 *  no  -- nomal            show right arrow img
 *  (   default is NO   )
***************************/
@property (nonatomic)       BOOL     isReadOnly ;       //



@property (weak, nonatomic) IBOutlet UILabel *lb_key;
@property (weak, nonatomic) IBOutlet UILabel *lb_value;
@property (weak, nonatomic) IBOutlet UIImageView *img_rightArrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSideConstrant;

@end
