//
//  InfoWriteController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "MyTextField.h"

@interface WriteInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MyTextField *tf;

@end

#define SELECT_NICKNAME  @"昵称"
#define SELECT_REALNAME  @"真实姓名"
#define SELECT_MAIL      @"邮箱"
#define SELECT_PHONE     @"手机"
#define SELECT_GENDER    @"性别"
#define SELECT_BIRTHDAY  @"生日"

@interface InfoWriteController : RootCtrl <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,copy) NSString *beSelectFlag_str ; //str,

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIDatePicker *birthDate;

@end
