//
//  UserInfoController.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootCtrl.h"
#import "QiniuSimpleUploader.h"
#import "QiniuResumableUploader.h"

@interface UserInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lab_key;

@property (weak, nonatomic) IBOutlet UILabel *lab_value;

@end



@interface UserInfoController : RootCtrl <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,QiniuUploadDelegate>


@property (weak, nonatomic) IBOutlet UITableView *table;

@property (retain, nonatomic)QiniuSimpleUploader *m_sUploader;

@end
