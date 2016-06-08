//
//  CONormalCell.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTextField.h"
#import "PinkButton.h"

@protocol  COScoreCellDelegate <NSObject>

/*
 *  scoreWrited
 */
- (void)sendScore:(int)scoreWrited ;

/*
 *  bShowHide : Y == show , N == hide
 */
- (void)showHideKeyBoard:(BOOL)bShowHide ;


@end

@interface COScoreCell : UITableViewCell <UITextFieldDelegate>

//  attrs
@property (nonatomic,retain) id <COScoreCellDelegate> delegate ;
@property (nonatomic)       int      myScore ;      //现在可用的积分

//  views
@property (weak, nonatomic) IBOutlet MyTextField *tf_point;

- (void)useAction ;

@property (weak, nonatomic) IBOutlet UILabel *lb_PointsYouOwn;//您拥有的积分

@end
