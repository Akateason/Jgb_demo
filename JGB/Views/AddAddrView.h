//
//  AddAddrView.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#define  TAG_BT_PROVINCE        46681
#define  TAG_BT_CITY            46682
#define  TAG_BT_REGION          46683

#define  TAG_SHEET_PROVINCE     56681
#define  TAG_SHEET_CITY         56682
#define  TAG_SHEET_REGION       56683


#import <UIKit/UIKit.h>
#import "ReceiveAddress.h"
#import "AddAddressController.h"
#import "QiniuSimpleUploader.h"
#import "QiniuResumableUploader.h"
#import "MyTextField.h"
#import "MyTextView.h"


@protocol AddAddrViewDelegate <NSObject>

- (void)navigationPopBack ;

- (void)sendActionSheetIndex:(int)buttonIndex ;


@end



@interface AddAddrView : UIView <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,QiniuUploadDelegate>
{
    NSMutableArray *m_provinceList  ;

    NSMutableArray *m_cityList  ;

    NSMutableArray *m_areaList  ;

    int             m_pid_province  ;
    int             m_pid_city      ;
    int             m_pid_area      ;
}

//  attrs
@property (nonatomic,retain)AddAddressController *controller ;

@property (nonatomic,retain) id <AddAddrViewDelegate> delegate  ;

@property (nonatomic,assign) BOOL isAddOrEdit                   ;     //0->新增模式, 1->编辑模式

@property (nonatomic,retain) ReceiveAddress *myAddress          ;     //编辑模式下,传来的地址

// views

@property (weak, nonatomic) IBOutlet MyTextField *tf_tel_main;

@property (weak, nonatomic) IBOutlet UILabel     *lb_postalCode;
@property (weak, nonatomic) IBOutlet MyTextField *tf_postCode;


@property (weak, nonatomic) IBOutlet MyTextField *tf_recieveName;
@property (weak, nonatomic) IBOutlet MyTextField *tf_phone;
@property (weak, nonatomic) IBOutlet MyTextField *tf_email;
@property (weak, nonatomic) IBOutlet MyTextField *tf_idCard;

@property (weak, nonatomic) IBOutlet MyTextView  *tv_RegionLocation; //所在区域

@property (weak, nonatomic) IBOutlet MyTextView  *tv_detailAddress;  //街道地址

- (void)confirmPressedAction:(id)sender;


// idcard front back
@property (weak, nonatomic) IBOutlet UIImageView *img_font;//正面
@property (weak, nonatomic) IBOutlet UIImageView *img_back;//反面
- (IBAction)tapPics:(UITapGestureRecognizer *)sender;
- (IBAction)tapPics2:(UITapGestureRecognizer *)sender;


// input accessory view
@property (weak,nonatomic) IBOutlet UIToolbar       *toolBar ;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *barbt_commit ;

// qi niu upload
@property (retain, nonatomic)QiniuSimpleUploader *m_sUploader;


@property (weak, nonatomic) IBOutlet UILabel *lb_title_idcard;






@end
