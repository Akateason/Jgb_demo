//
//  AddAddrView.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "AddAddrView.h"
#import "DigitInformation.h"
#import "District.h"
#import "DistrictTB.h"
#import "ServerRequest.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "PinkButton.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SBJson.h"
#import "MyFileManager.h"
#import "MyMD5.h"
#import "IdCard.h"
#import "YXSpritesLoadingView.h"



@interface AddAddrView ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate>
{
    UIImage         *m_imageNeedsToDisplay ;
    
    BOOL            m_isfrontOrBack ;               //身份证正反面

    NSString        *m_front ;
    NSString        *m_back  ;
    
    NSString        *m_tel_Str ;
    
    BOOL            m_hasFront ;
    BOOL            m_hasBack  ;
    
    
}
@end

@implementation AddAddrView

@synthesize m_sUploader ;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {

    }
    return self;
}

- (void)initialDatas
{
    m_provinceList  = [NSMutableArray array] ;
    m_cityList      = [NSMutableArray array] ;
    m_areaList      = [NSMutableArray array] ;
    
    m_pid_province      = 0     ;
    m_pid_city          = 0     ;
    
    m_front     = @"" ;
    m_back      = @"" ;
    m_tel_Str   = @"" ;
}


- (void)awakeFromNib
{
    [super awakeFromNib]        ;
    
    [self setViewStyles]        ;
    
    [self initialDatas]         ;
    
}


- (void)setMyAddress:(ReceiveAddress *)myAddress
{
    _myAddress = myAddress ;
    
    
    [self setup] ;
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
}

- (void)setup
{
    // 新增 or 编辑
    _isAddOrEdit =  (_myAddress == nil) ? NO : YES ;
    
    NSLog(@"_isAddOrEdit : %d",_isAddOrEdit) ;
    
    //    text delegate
    
    _tf_recieveName.delegate    = self ;
    _tf_phone.delegate          = self ;
    _tf_email.delegate          = self ;
    _tf_idCard.delegate         = self ;
    _tv_detailAddress.delegate  = self ;
    _tf_postCode.delegate       = self ;
    
    _tf_tel_main.delegate       = self ;
    
    // in Editint mode
    if (_isAddOrEdit)
    {
        [self editMode] ;
    }
    
    // Picker Data Source
    [self setPickerDataSource] ;
}


#pragma mark --

- (void)setPickerDataSource
{
    m_provinceList = [NSMutableArray arrayWithArray:[[DistrictTB shareInstance] getDistrictListWithPid:0]] ;
    
    if (!m_pid_province)
    {
        District *districtP = m_provinceList[0] ;
        m_pid_province = districtP.districtID ;
    }
    
    m_cityList = [NSMutableArray arrayWithArray:[[DistrictTB shareInstance] getDistrictListWithPid:m_pid_province]] ;
    
    if (!m_pid_city)
    {
        District *districtC = m_cityList[0] ;
        m_pid_city = districtC.districtID ;
    }
    
    m_areaList = [NSMutableArray arrayWithArray:[[DistrictTB shareInstance] getDistrictListWithPid:m_pid_city]] ;
    
    if (!m_pid_area)
    {
        District *districtA = m_areaList[0] ;
        m_pid_area = districtA.districtID ;
    }
    
}


#pragma mark --
#pragma mark - in edit mode
- (void)editMode
{
    _tf_postCode.text = [NSString stringWithFormat:@"%d",_myAddress.areacode];
    
    m_pid_province  = _myAddress.province   ;
    m_pid_city      = _myAddress.city       ;
    m_pid_area      = _myAddress.area       ;
    
    
    _tf_recieveName.text = _myAddress.uname ;
    _tf_phone.text = _myAddress.phone ;
    _tf_email.text = _myAddress.email ;
    _tf_idCard.text = _myAddress.idcard ;
    _tv_detailAddress.text = _myAddress.address ;
    
//    m_segmentView.currentIndex = _myAddress.isDefault ;
    
    _tv_RegionLocation.text = [self getRegionStr] ;
    
    _tf_tel_main.text = _myAddress.tel ;    //暂时这样, 不设区号和分机
    
    
//
    if (!_myAddress.idcard_status)
    {
        NSLog(@"没上传身份证的嘛") ; //
        
        _lb_title_idcard.text = @"身份证照片:" ;

        _img_back.hidden = NO ;
        _img_font.hidden = NO ;
    }
    else
    {
        //上传过身份证...
        _lb_title_idcard.text = @"身份证照片已上传" ;
        
        _img_back.hidden = YES ;
        _img_font.hidden = YES ;
    }
    
    
}


#pragma mark --
#pragma mark - set View Styles
- (void)setViewStyles
{
    
    _tv_detailAddress.backgroundColor     = [UIColor whiteColor] ;

    _tv_RegionLocation.backgroundColor    = [UIColor whiteColor] ;
    
//    region location text view delegate accessory
    UIPickerView *pickerView    = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, APPFRAME.size.width, 200)] ;
    pickerView.delegate         = self;
    pickerView.dataSource       = self;
    
    _tv_RegionLocation.inputView = pickerView ;
    _tv_RegionLocation.inputAccessoryView = _toolBar;
    
    PinkButton *button = [[PinkButton alloc] initWithFrame:CGRectMake(0, 0, 60, 35)] ;
    [button setTitle:@"确定" forState:UIControlStateNormal] ;
    [button addTarget:self action:@selector(toolBarCommitAction) forControlEvents:UIControlEventTouchUpInside] ;
    
    _barbt_commit.customView = button ;
    _toolBar.barTintColor = COLOR_BACKGROUND ;
    
//    switch
//    _switchView.onTintColor = COLOR_PINK ;
    
    
    _img_font.image = [UIImage imageNamed:@"idcardf"];
    _img_font.contentMode = UIViewContentModeScaleAspectFit ;
    _img_back.image = [UIImage imageNamed:@"idcardb"];
    _img_back.contentMode = UIViewContentModeScaleAspectFit ;
    
}


#pragma mark --
#pragma mark - RFSegmentViewDelegate
- (void)segmentViewSelectIndex:(NSInteger)index
{
    NSLog(@"current index is %d",index) ;
}


#pragma mark --
#pragma mark - textfield delegate

#define     MOVE_LENGTH        430

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = COLOR_PINK.CGColor ;

    CGRect tfFrame = textField.frame;
    int offset     = tfFrame.origin.y - (self.frame.size.height - 64.0f - 64.0f - MOVE_LENGTH);
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    if (offset > 0)
    {
        self.frame = CGRectMake(0.0f, - offset, self.frame.size.width,
                                self.frame.size.height);
    }
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self keyboardBackToBase];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderColor = COLOR_LIGHT_GRAY.CGColor ;

    if (![textField resignFirstResponder]) [self keyboardBackToBase];
    

    
}

#pragma mark --
#pragma mark - text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.layer.borderColor = COLOR_PINK.CGColor ;
    
    CGRect tfFrame = textView.frame;
    int offset = tfFrame.origin.y - (self.frame.size.height - (MOVE_LENGTH+20));
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    if (offset > 0)
    {
        self.frame = CGRectMake(0.0f, - offset, self.frame.size.width, self.frame.size.height);
    }
    
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self keyboardBackToBase];
        [textView resignFirstResponder];
    
        return NO;
    }
    
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.layer.borderColor = COLOR_LIGHT_GRAY.CGColor ;
}


#pragma mark - touchesEnded withEvent
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if ((![self.tf_phone isExclusiveTouch])||(![self.tf_email isExclusiveTouch])||(![self.tf_recieveName isExclusiveTouch])||(![self.tf_idCard isExclusiveTouch])||(![self.tv_detailAddress isExclusiveTouch])||(![self.tv_RegionLocation isExclusiveTouch])||(![self.tf_tel_main isExclusiveTouch])||(![self.tf_postCode isExclusiveTouch]) )
    {
        [_tf_recieveName resignFirstResponder];
        [_tf_phone resignFirstResponder];
        [_tf_email resignFirstResponder];
        [_tf_idCard resignFirstResponder];
        [_tv_detailAddress resignFirstResponder] ;
        [_tv_RegionLocation resignFirstResponder] ;
        [_tf_tel_main resignFirstResponder] ;
        [_tf_postCode resignFirstResponder] ;
        
        [self keyboardBackToBase];
    }
    
}

- (void)keyboardBackToBase
{
    [UIView beginAnimations:@"ReturnKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f]  ;
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) ;
    [UIView commitAnimations] ;
}


#pragma mark - Action
// 确定
- (void)confirmPressedAction:(id)sender
{
    //1 fill all blanks
    BOOL bFillAll = [self fillAllBlanks] ;
    
    if (!bFillAll) return;
    
    
    
    
    //2 send address 2 server
    BOOL bSuccess = [self sendAddressInfoToServer] ;
 
    //3 send idcard name
    [self sendIdCardInfoRToServer] ;
    
    //4
    if (bSuccess)
    {
        //[DigitInformation showWordHudWithTitle:@"提交成功"] ;
        [self performSelector:@selector(wantPop) withObject:nil afterDelay:0.1f] ;
    }
   
}

- (BOOL)sendAddressInfoToServer
{
    ReceiveAddress *address = [[ReceiveAddress alloc] initWithUname:_tf_recieveName.text AndWithProvinceID:m_pid_province AndWithCityID:m_pid_city AndWithAreaID:m_pid_area AndWithAddress:_tv_detailAddress.text AndWithPostalCode:[_tf_postCode.text intValue] AndWithPhone:_tf_phone.text AndWithEmail:_tf_email.text AndWithIdCard:_tf_idCard.text AndWithDefault:_myAddress.isDefault AndWithAddressID:_myAddress.addressId AndWithUid:_myAddress.uid AndWithTel:m_tel_Str] ;
    
    BOOL bSuccess = NO ;
    
    // in Edit mode
    if (_isAddOrEdit)
    {
        bSuccess = [ServerRequest editAddressWithAddress:address] ;
    }
    // in add  mode
    else
    {
        bSuccess = [ServerRequest addAddressWithAddress:address] ;
    }
    
    NSString *strShow = (bSuccess) ? @"新增or编辑 地址成功" : WD_HUD_BADNETWORK ;
    
    NSLog(@"strShow : %@",strShow) ;
    
    return bSuccess ;
}

- (void)sendIdCardInfoRToServer
{
    
    dispatch_queue_t queue = dispatch_queue_create("sendCardQueue", NULL) ;
    dispatch_async(queue, ^{
        
            ResultPasel *result = [ServerRequest addIdCard:_tf_idCard.text AndWithFront:m_front AndWithBack:m_back] ;
            NSLog(@"code : %d",result.code) ;
        
    }) ;

}

- (void)wantPop
{
    [self.delegate navigationPopBack] ;
}

- (BOOL)fillAllBlanks
{
    BOOL bTelNO = ([_tf_tel_main.text isEqualToString:@""]) ;
    
    
    if ([_tf_recieveName.text isEqualToString:@""])
    {
        [DigitInformation showWordHudWithTitle:@"请填写收货人姓名"] ;
        return NO;
    }
    else if ( (!m_pid_province)||(!m_pid_city)||(!m_pid_area) )
    {
        [DigitInformation showWordHudWithTitle:@"请选择所在地区"] ;
        return NO;
    }
    else if ([_tv_detailAddress.text isEqualToString:@""])
    {
        [DigitInformation showWordHudWithTitle:@"请填写街道地址"] ;
        return NO;
    }
    else if ([_tf_phone.text isEqualToString:@""] && (bTelNO) )
    {
        [DigitInformation showWordHudWithTitle:@"请填写电话或者手机"] ;
        return NO;
    }
    else if ([_tf_email.text isEqualToString:@""])
    {
        [DigitInformation showWordHudWithTitle:@"请填写Email"] ;
        return NO;
    }
    else if ([_tf_idCard.text isEqualToString:@""])
    {
        [DigitInformation showWordHudWithTitle:@"请填写身份证号"] ;
        return NO;
    }
    
    
    //  Verification
    BOOL bEmail = [Verification validateEmail:_tf_email.text] ;
    if (!bEmail)
    {
        [DigitInformation showWordHudWithTitle:@"邮箱格式不正确"] ;
        return NO;
    }

    BOOL bIdcard = [Verification validateIdentityCard:_tf_idCard.text] ;
    if (!bIdcard)
    {
        [DigitInformation showWordHudWithTitle:@"身份证不正确"] ;
        return NO;
    }

    BOOL bPhone = [Verification validateMobile:_tf_phone.text] ;
    if (!bPhone)
    {
        [DigitInformation showWordHudWithTitle:@"手机号码不正确"] ;
        return NO;
    }

    BOOL bRecieveName = [Verification validateRealname:_tf_recieveName.text] ;
    if (!bRecieveName)
    {
        [DigitInformation showWordHudWithTitle:@"姓名格式不正确"] ;
        return NO;
    }
    
    
    
//    else if ( ((!m_front) || ([m_front isEqualToString:@""])) && !_isAddOrEdit )
//    {
//        [DigitInformation showHudWithTitle:@"请拍摄身份证正面"] ;
//        return NO;
//    }
//    else if ( ((!m_back) || ([m_back isEqualToString:@""])) && !_isAddOrEdit )
//    {
//        [DigitInformation showHudWithTitle:@"请拍摄身份证反面"] ;
//        return NO;
//    }
    
    return YES ;
}


#pragma mark--
#pragma mark - UIPickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3 ;       //province , city , region
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int theCount = 0 ;
    
    switch (component)
    {
            //province
        case 0:
        {
            theCount = m_provinceList.count ;
        }
            break;
            //city
        case 1:
        {
            theCount = m_cityList.count ;
        }
            break;
            //region
        case 2:
        {
            theCount = m_areaList.count ;
        }
            break;
        default:
            break;
    }
    
    
    return theCount;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    District *district = [[District alloc] init] ;
    
    switch (component)
    {
            //province
        case 0:
        {
            district = [m_provinceList objectAtIndex:row] ;
        }
            break;
            //city
        case 1:
        {
            district = [m_cityList objectAtIndex:row] ;
        }
            break;
            //region
        case 2:
        {
            district = [m_areaList objectAtIndex:row] ;
        }
            break;
        default:
            break;
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)] ;
    lab.text = district.name ;
    lab.font = [UIFont systemFontOfSize:14.0f] ;
    [lab sizeToFit] ;
    lab.minimumScaleFactor = 0.5 ;

    return lab ;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    switch (component)
    {
            //province
        case 0:
        {
            District *pro_district = m_provinceList[row] ;
            m_pid_province = pro_district.districtID ;
            m_cityList = [NSMutableArray arrayWithArray:[[DistrictTB shareInstance] getDistrictListWithPid:m_pid_province]] ;
            [pickerView reloadComponent:1] ;

            District *cit_district = m_cityList[0] ;
            m_pid_city = cit_district.districtID ;
            m_areaList = [NSMutableArray arrayWithArray:[[DistrictTB shareInstance] getDistrictListWithPid:m_pid_city]] ;
            [pickerView reloadComponent:2] ;
            
            District *are_district = m_areaList[0] ;
            m_pid_area = are_district.districtID ;

        }
            break ;
        case 1:
        {
            District *adistrict = m_cityList[row] ;
            m_pid_city = adistrict.districtID ;
            
            m_areaList = [NSMutableArray arrayWithArray:[[DistrictTB shareInstance] getDistrictListWithPid:m_pid_city]] ;
            
            [pickerView reloadComponent:2] ;
        }
            break;
            //region
        case 2:
        {
            District *adistrict = m_areaList[row] ;
            m_pid_area = adistrict.districtID ;
        }
            break;
        default:
            break;
    }
    
    
}



#pragma mark --
#pragma mark - tool bar action
- (void)toolBarCommitAction
{
    
    if ([_tv_RegionLocation isFirstResponder]) [_tv_RegionLocation resignFirstResponder] ;
    
    _tv_RegionLocation.text = [self getRegionStr] ;
}


- (NSString *)getRegionStr
{
    District *districtProvince = [[DistrictTB shareInstance] getDistrictWithID:m_pid_province] ;
    District *districtCity     = [[DistrictTB shareInstance] getDistrictWithID:m_pid_city] ;
    District *districtArea     = [[DistrictTB shareInstance] getDistrictWithID:m_pid_area] ;
    
    NSString *resultStr = [NSString stringWithFormat:@"%@ %@ %@",districtProvince.name,districtCity.name,districtArea.name] ;

    return resultStr ;
}

#pragma mark -- actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self.delegate sendActionSheetIndex:buttonIndex] ;
    [self sendActionSheetIndex:buttonIndex] ;
}

- (void)sendActionSheetIndex:(int)buttonIndex
{
    switch (buttonIndex)
    {
        case 0://拍照
        {
            [self startCameraControllerFromViewController: _controller
                                            usingDelegate: self];
            break;
        }
        case 1://本地相册
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [_controller presentViewController:imagePickerController animated:YES completion:^{}];
            
            break;
        }
        case 2://取消
            break;
        default:
            break;
    }
}


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate
{
    // here, check the device is available  or not
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)|| (controller == nil)) return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES ;    //是否在拍照时让编辑
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:YES completion:^{}];
    
    return YES;
}

#pragma mark --
#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    m_imageNeedsToDisplay = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    // 1 put in view
    [self showImagesOnViewWithImg:m_imageNeedsToDisplay] ;
    
    // 2 put in doucument , db , server
    [self performSelectorInBackground:@selector(saveAndUploadImg:) withObject:m_imageNeedsToDisplay];
    [_controller dismissViewControllerAnimated:YES completion:^{
        
        if (m_hasBack && m_front)
        {
            [self keyboardBackToBase] ;
        }

    }];
}

#pragma mark --
#pragma mark - saveTheHeadIMG

- (void)saveAndUploadImg:(UIImage *)img
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
    }) ;
    
    
    //1  write in file
    //    save in hard memo
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], [MyTick getStrWithNSDate:[NSDate date] AndWithFormat:@"YYYYMMdd-HHmmss.jpg"]] ;
    
    NSData *data = UIImageJPEGRepresentation(img,1)   ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    //    write date in the file
    [fileManager createFileAtPath:filePath contents:data attributes:nil];
    
    //2  tell server file name
    NSString *cardStringFrontOrBack = [NSString stringWithFormat:@"%@%@%@",_tf_idCard.text,KEY_SECRET_IDCARD,[MyTick getStrWithNSDate:[NSDate date] AndWithFormat:TIME_STR_FORMAT_4]] ;
    
    cardStringFrontOrBack = [MyMD5 md5:cardStringFrontOrBack] ;
    
    if (! m_isfrontOrBack)
    {
        // front
        m_front = cardStringFrontOrBack ;
    }
    else
    {
        // back
        m_back  = cardStringFrontOrBack ;
    }
    
    //3  uploadHeadPicWithPath
    [self uploadHeadPicWithPath:filePath AndFileName:cardStringFrontOrBack] ;
    
}


#pragma mark --
#pragma mark - upload

#define BUCKETNAME      @"idcard"

- (void)uploadHeadPicWithPath:(NSString *)picPath AndFileName:(NSString *)fileName
{
//
    NSString *uploadToken   = @"" ;
//
    NSString *response      = [ServerRequest getUploadPictureWithPictureName:fileName AndWithBuckect:BUCKETNAME] ;
    SBJsonParser *parser    = [[SBJsonParser alloc] init]           ;
    NSDictionary *dic       = [parser objectWithString:response]    ;
    BOOL success            = ([[dic objectForKey:@"code"] integerValue] == 200) ? YES : NO ;
    if (success)
    {
        uploadToken         = [[dic objectForKey:@"data"] objectForKey:@"token"]    ;
        m_sUploader         = [QiniuSimpleUploader uploaderWithToken:uploadToken]   ;
        m_sUploader.delegate = self ;
        //start upload !
        NSString *key = fileName ;
        [m_sUploader uploadFile:picPath
                            key:key
                          extra:nil];
    }
    
}


#pragma mark --
#pragma mark - QiNiu delegate
// Upload progress
- (void)uploadProgressUpdated:(NSString *)theFilePath percent:(float)percent
{
    NSString *progressStr = [NSString stringWithFormat:@"Progress Updated: - %f\n", percent];
    
    NSLog(@"progressStr : %@",progressStr) ;
}

// upload Succeeded
- (void)uploadSucceeded:(NSString *)theFilePath ret:(NSDictionary *)ret
{
    NSString *succeedMsg = [NSString stringWithFormat:@"Upload Succeeded: - Ret: %@\n", ret];
    
    NSLog(@"succeedMsg:%@",succeedMsg) ;
    
    NSLog(@"theFilePath : %@",theFilePath) ;
    
    [MyFileManager deleteFileWithFileName:theFilePath] ;

    [YXSpritesLoadingView dismiss] ;
    [DigitInformation showWordHudWithTitle:@"上传成功"] ;
}

// Upload failed
- (void)uploadFailed:(NSString *)theFilePath error:(NSError *)error
{
    NSString *failMsg = [NSString stringWithFormat:@"Upload Failed: %@  - Reason: %@", theFilePath, error];
    
    NSLog(@"failMsg:%@",failMsg) ;
    
    [YXSpritesLoadingView dismiss] ;
    [DigitInformation showWordHudWithTitle:@"上传失败"] ;
}




#pragma mark --
#pragma mark - Actions

//img1
- (IBAction)tapPics:(UITapGestureRecognizer *)sender
{
    NSLog(@"img1") ;
    m_isfrontOrBack = NO ;
    
    if (![self showPhotoActionSheet])  return ;
}

//img2
- (IBAction)tapPics2:(UITapGestureRecognizer *)sender
{
    NSLog(@"img2") ;
    m_isfrontOrBack = YES ;
    
    if (![self showPhotoActionSheet])  return ;
}

- (BOOL)showPhotoActionSheet
{
    for (UIView *subView in [self subviews])
    {
        if ( [subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]] )
        {
            if ([subView isFirstResponder])
            {
                [subView resignFirstResponder] ;
            }
        }
    }
    
    
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"本地相册", nil];
    [ac showInView:self];
    
    return YES ;
}



#pragma mark - showImagesOnViewWithImg
- (void)showImagesOnViewWithImg:(UIImage *)img
{
    if (!m_isfrontOrBack)
    {
        //front
        _img_font.image = img ;
        m_hasFront = YES ;
    }
    else
    {
        //back
        _img_back.image = img ;
        m_hasBack = YES ;
    }
    
}


@end
