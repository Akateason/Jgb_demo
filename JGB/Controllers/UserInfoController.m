//
//  UserInfoController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "UserInfoController.h"
#import "DigitInformation.h"
#import "InfoWriteController.h"
#import "SBJson.h"
#import "ServerRequest.h"
#import "UIImageView+WebCache.h"
#import "Base64.h"
#import "NSString+HMac_SHA1.h"
#import "UIImage+AddFunction.h"
#import "LSCommonFunc.h"
#import "SDImageCache.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "UserHeadCell.h"
#import "DealPhotoVideoViewController.h"

/*
 *  MY HEAD PICTURE PATH
 **/
#define PATH_MY_HEAD_PIC        [NSString stringWithFormat:@"%@/myHead.jpg",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]]


@implementation UserInfoCell

@end


@interface UserInfoController () <UserHeadCellDelegate>
{
    NSArray *m_array ;
    UIImage *m_imageNeedsToDisplay;
}

@end

@implementation UserInfoController
@synthesize m_sUploader ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.
    self.title = @"我的信息" ;

    //2.    datasource
    m_array = @[@"昵称",@"真实姓名",@"邮箱",@"手机",@"性别",@"生日"];     //,@"身份证号"

    //3.    table view outlite
    _table.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15) ;
    _table.separatorColor = COLOR_LIGHT_GRAY ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    [_table reloadData] ;
    [self.navigationController.navigationBar setTranslucent:YES] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
    
    [self.navigationController.navigationBar setTranslucent:NO ] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return m_array.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row)
    {
        static NSString *CellIdentfier = @"UserHeadCell";
        UserHeadCell *cell = (UserHeadCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
        if (cell == nil)
        {
            cell = [[UserHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
        }
        cell.strImgs = G_USER_CURRENT.avatar ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        cell.delegate = self ;
        
        return cell;
    }
    
    
    static NSString *CellIdentfier = @"UserInfoCell" ;
    
    UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (cell == nil)
    {
        cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
    }
    
    NSString *key = [m_array objectAtIndex:indexPath.row - 1] ;
    cell.lab_key.text = key ;
    cell.lab_value.text = [self getValueWithKey:key] ;

    cell.accessoryType = ([key isEqualToString:@"邮箱"] || [key isEqualToString:@"手机"]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell;
}

- (NSString *)getValueWithKey:(NSString *)key
{
//    m_array = @[@"昵称",@"真实姓名",@"邮箱",@"手机",@"性别",@"生日"];/////,@"身份证号"
    
    if ([key isEqualToString:@"昵称"]) {
        return G_USER_CURRENT.nickName ;
    }else if ([key isEqualToString:@"真实姓名"]) {
        return G_USER_CURRENT.realName ;
    }else if ([key isEqualToString:@"邮箱"]) {
        return [G_USER_CURRENT.email isEqualToString:@""] ? @"未绑定" : G_USER_CURRENT.email ;
    }else if ([key isEqualToString:@"手机"]) {
        return [G_USER_CURRENT.phone isEqualToString:@""] ? @"未绑定" : G_USER_CURRENT.phone ;
    }else if ([key isEqualToString:@"性别"]) {
        return [LSCommonFunc boyGirlNum2Str:G_USER_CURRENT.sex] ;
    }else if ([key isEqualToString:@"生日"]) {
        if (!G_USER_CURRENT.birth) {
            return nil;
        }
        NSDate *date = [MyTick getNSDateWithTick:G_USER_CURRENT.birth] ;
        
        return [MyTick getStrWithNSDate:date AndWithFormat:TIME_STR_FORMAT_1] ;
    }
    
    return nil ;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
     
        [self CameraActionPressed] ;
        
        return ;
    }
    
    NSString *key = [m_array objectAtIndex:indexPath.row - 1] ;
    
    if ([key isEqualToString:@"邮箱"]) {
        return ;
    }else if ([key isEqualToString:@"手机"]) {
        return ;
    }
    
    [self performSegueWithIdentifier:@"info2Write" sender:key];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) return 90.0f ;

    return 40.0f ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getEmptyView] ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self getEmptyView] ;
}


- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0 ;
}


- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0 ;
}

- (UIView *)getEmptyView
{
    UIView *empty = [[UIView alloc] init] ;
    empty.backgroundColor = nil ;
    return empty ;
}

#pragma mark --
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    InfoWriteController *infoVC = (InfoWriteController *)[segue destinationViewController] ;
    infoVC.beSelectFlag_str = (NSString *)sender ;
}


#pragma mark --
#pragma mark - CameraActionPressed
- (void)CameraActionPressed
{
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"更新头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"本地相册", nil];
    
    [ac showInView:self.view];
}


#pragma mark -- actionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://拍照
        {
            [self startCameraControllerFromViewController: self
                                            usingDelegate: self];
            break;
        }
        case 1://本地相册
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
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
    cameraUI.allowsEditing = YES;    //是否在拍照时让编辑
    cameraUI.delegate = delegate;
    [controller presentViewController:cameraUI animated:YES completion:^{}];
    
    return YES;
}

#pragma mark --
#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    m_imageNeedsToDisplay = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    //UIImagePickerControllerOriginalImage
    //UIImagePickerControllerEditedImage
    //m_imageNeedsToDisplay = [UIImage fixOrientation:m_imageNeedsToDisplay];
    
    // 1 put in view
    UserHeadCell *headcell = (UserHeadCell *)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] ;
    headcell.imgPhotoOver = m_imageNeedsToDisplay;

    
    // 2 put in  server
    [self performSelectorInBackground:@selector(saveTheHeadIMG:) withObject:m_imageNeedsToDisplay];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark --
#pragma mark - saveTheHeadIMG

#define         FILE_SIZE               10240

- (void)saveTheHeadIMG:(UIImage *)headIMG
{
//1  write in file
    //    save in hard memo
    NSString *filePath = PATH_MY_HEAD_PIC      ;

    NSData *data = UIImageJPEGRepresentation(headIMG,1)   ;
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    //    write date in the file
    [fileManager createFileAtPath:filePath contents:data attributes:nil];

//2  uploadHeadPicWithPath
    [self uploadHeadPicWithPath:filePath] ;

//3  change pic cache
    [[SDImageCache sharedImageCache] removeImageForKey:G_USER_CURRENT.avatar]            ;
    [[SDImageCache sharedImageCache] storeImage:headIMG forKey:G_USER_CURRENT.avatar toDisk:YES] ;
    
}


#pragma mark --
#pragma mark - upload
- (void)uploadHeadPicWithPath:(NSString *)picPath
{
    dispatch_queue_t queue = dispatch_queue_create("uploadHeadQueue", NULL) ;
    dispatch_async(queue, ^{
        
        NSString *uploadToken = @"" ;
        
        NSString *response = [ServerRequest getUploadPictureWithPictureName:[NSString stringWithFormat:@"%d.jpg",G_USER_CURRENT.uid] AndWithBuckect:@"heads"] ;
        SBJsonParser *parser = [[SBJsonParser alloc] init]          ;
        NSDictionary *dic   = [parser objectWithString:response]    ;
        BOOL success = ([[dic objectForKey:@"code"] integerValue] == 200) ? YES : NO ;
        if (success)
        {
            uploadToken = [[dic objectForKey:@"data"] objectForKey:@"token"];
        }
        else
        {
            [DigitInformation showWordHudWithTitle:WD_HUD_BADNETWORK ]; //AndWithController:self] ;
            
            return ;
        }
        
        m_sUploader = [QiniuSimpleUploader uploaderWithToken:uploadToken];
        //m_sUploader.delegate = self;
        
        //start upload !
        NSString *key = [NSString stringWithFormat:@"%d.jpg",G_USER_CURRENT.uid] ;
        [m_sUploader uploadFile:picPath
                            key:key
                          extra:nil];
        
    }) ;
    
}

/*
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
}

// Upload failed
- (void)uploadFailed:(NSString *)theFilePath error:(NSError *)error
{
    NSString *failMsg = [NSString stringWithFormat:@"Upload Failed: %@  - Reason: %@", theFilePath, error];
    
    NSLog(@"failMsg:%@",failMsg) ;
}
*/


#pragma mark --
#pragma mark - UserHeadCellDelegate <NSObject>
- (void)pressUserHeadPictureCallBack
{
    
    if (G_USER_CURRENT.uid == 0 || G_USER_CURRENT == nil) return ;
    
    if (G_USER_CURRENT.avatar == nil)
        G_USER_CURRENT.avatar = @"" ;
    else
    {
        [[SDImageCache sharedImageCache] removeImageForKey:G_USER_CURRENT.avatar] ;
    }
    
    NSLog(@"G_USER_CURRENT.avatar : %@",G_USER_CURRENT.avatar) ;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    DealPhotoVideoViewController *detailVC = (DealPhotoVideoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DealPhotoVideoViewController"] ;
    
    detailVC.m_imgKeyArray          = @[G_USER_CURRENT.avatar] ;
    detailVC.m_currentImgVideoIndex = 0 ;
    detailVC.isRandom = YES ;   //每次查看头像大图,加随机数,更新就的头像缓存
    
    [detailVC setHidesBottomBarWhenPushed:YES] ;
    [self.navigationController pushViewController:detailVC animated:YES] ;
    
}


@end
