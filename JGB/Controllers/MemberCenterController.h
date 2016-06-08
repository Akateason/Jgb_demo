//
//  MemberCenterController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
//#import "XHPathCover.h"
#import "MemberTopView.h"

#pragma mark --
#pragma mark - MemberCell
@interface MemberCell : UITableViewCell

//  attrs
/*
 *  values if >= 0  ,the lb_value will show;
 *  valuew < 0 , lb_value hidden
 */
@property (nonatomic)       int     values ;


//  views
@property (weak, nonatomic) IBOutlet UILabel *lb_key;
@property (weak, nonatomic) IBOutlet UILabel *lb_value;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (nonatomic,copy) NSString *strImg ;

@end




#pragma mark --
#pragma mark - MemberCenterController
@interface MemberCenterController : RootCtrl <UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, strong) XHPathCover *pathCover;

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet MemberTopView *topView;



@end






