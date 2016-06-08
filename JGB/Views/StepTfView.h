//
//  StepTfView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>


#define NOTIFICATION_SHOW_NUM_KEY_BOARD     @"NOTIFICATION_SHOW_NUM_KEY_BOARD"


@protocol StepTfViewDelegate <NSObject>

- (void)refreshTableWithNum:(int)numbuy AndWithSection:(int)section AndWithRow:(int)row ;

@end

@interface StepTfView : UIView <UITextFieldDelegate>

@property (nonatomic,retain) id <StepTfViewDelegate> delegate ;

@property (nonatomic,assign) int num     ;      //购买数量

@property (nonatomic,assign) int maxNum  ;      //最大库存

@property (nonatomic,assign) int section ;

@property (nonatomic,assign) int row     ;

//@property (nonatomic)        BOOL canBeEnabled ; //是否

//

@property (weak, nonatomic) IBOutlet UIButton *bt_minus;
@property (weak, nonatomic) IBOutlet UIButton *bt_add;

@property (weak, nonatomic) IBOutlet UITextField *tf_num;

- (IBAction)actionMinus:(id)sender;

- (IBAction)actionPlus:(id)sender;

@end
