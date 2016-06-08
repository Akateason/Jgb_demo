//
//  HistoryHotCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-4.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryHotCellDelegate <NSObject>

- (void)deleteHistoryStringName:(NSString *)name ;

@end


@interface HistoryHotCell : UITableViewCell

@property (nonatomic,retain) id <HistoryHotCellDelegate> delegate ;

@property (weak, nonatomic) IBOutlet UILabel *lb;

- (IBAction)deleteAction:(id)sender;


@end
