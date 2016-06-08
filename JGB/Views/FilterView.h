//
//  FilterView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-9-2.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Select_val.h"

@protocol FilterViewDelegate <NSObject>
/*
 * b  yes Commit , no Cancel 
**/
- (void)commitOrCancelWithFlag:(BOOL)b ;


/*
** flag
** selectValue      ... 品牌 价格 商城
**/
- (void)go2FliterControllerWithFlag:(NSString *)flag AndWithValue:(Select_val *)selectValue AndWithBrandList:(NSArray *)brandlist;

@end

@interface FilterView : UIView <UITableViewDataSource,UITableViewDelegate>

//attrs
@property (nonatomic,retain) id <FilterViewDelegate> delegate   ;
@property (nonatomic,retain) Select_val     *m_selectVal        ;
@property (nonatomic,retain) NSArray        *brandList          ;


//views

@property (weak, nonatomic) IBOutlet UIButton *backBt;
- (IBAction)backAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *mianView;

@property (weak, nonatomic) IBOutlet UIView *barView;

@property (weak, nonatomic) IBOutlet UIButton *commitBt;

@property (weak, nonatomic) IBOutlet UIButton *resetBt;

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIView *touchView;

- (IBAction)commitAciton:(id)sender;

- (IBAction)resetAction:(id)sender;






@end
