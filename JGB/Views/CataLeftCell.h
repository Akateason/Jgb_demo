//
//  CataLeftCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 15-2-25.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//


#define CELL_HEIGHT_LEFT    45.0f

#import <UIKit/UIKit.h>

@interface CataLeftCell : UITableViewCell

@property (nonatomic) BOOL  isSelected ;
@property (nonatomic,copy) NSString *name ;


@property (nonatomic,retain) UIView *leftView ;

@end
