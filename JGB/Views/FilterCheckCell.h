//
//  FilterCheckCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IsOnSaleSwitch = 0,         //  cell index = 0
    IsChineseSwitch                   //  cell index = 1
} FilterCheckCellType;

@protocol FilterCheckCellDelegate <NSObject>
/*
 * mode : enum
**/
- (void)switchTheCondition:(BOOL)onOff AndWithMode:(FilterCheckCellType)FilterCheckCellType;

@end


@interface FilterCheckCell : UITableViewCell

@property (nonatomic,assign) int cellIndex ; //cellIndex == FilterCheckCellType

@property (nonatomic,retain) id <FilterCheckCellDelegate> delegate ;

@property (weak, nonatomic) IBOutlet UILabel    *lb_key         ;

@property (weak, nonatomic) IBOutlet UISwitch   *switchView     ;


- (IBAction)switchValueChanged:(id)sender;

@end
