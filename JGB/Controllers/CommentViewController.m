//
//  CommentViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "CommentViewController.h"
#import "DigitInformation.h"
#import "CmtSendView.h"

//#import "StarView.h"
//#import <MobileCoreServices/UTCoreTypes.h>
//#import "ELCImagePickerHeader.h"



@interface CommentViewController () <UITextViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,CmtSendViewDelegate>//ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
//    UIImage *m_imageNeedsToDisplay;
//    NSMutableArray *m_photosArray ;
//    UITableView     *m_table_pic  ;
    
    CmtSendView *m_sendView ;
}

//@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;

@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1. set views
    m_sendView = (CmtSendView *)[[[NSBundle mainBundle] loadNibNamed:@"CmtSendView" owner:self options:nil] objectAtIndex:0];
    m_sendView.delegate = self ;
    m_sendView.cmt = _cmt ;
    
    _mainScroll.contentSize = m_sendView.frame.size ;
    [_mainScroll addSubview:m_sendView]    ;
    _mainScroll.backgroundColor = COLOR_BACKGROUND ;
    
    
    //2. right bar send button
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendPressedAction)] ;
    self.navigationItem.rightBarButtonItem = rightItem ;
    
    
/*
    //1.5 set horizon table view
    float h = 70.0f ;
    m_table_pic = [[UITableView alloc] initWithFrame:CGRectMake(0, h, h, 280)];
    m_table_pic.backgroundColor = [UIColor whiteColor];
    [m_table_pic.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    m_table_pic.transform = CGAffineTransformMakeRotation( M_PI / -2 );
    m_table_pic.showsVerticalScrollIndicator = NO;
    m_table_pic.frame = CGRectMake(0, h, 280, h); //280
    m_table_pic.rowHeight = h;
    m_table_pic.separatorStyle = 0 ;
    m_table_pic.delegate = self;
    m_table_pic.dataSource = self;
    [_photoView addSubview:m_table_pic];

    //2.set contents
    _img_good.image = [UIImage imageNamed:@"goods2"] ;
    m_photosArray = [NSMutableArray array] ;
*/

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






/*
- (IBAction)cameraPressedAction:(id)sender
{
    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"本地相册", nil];
    
    [ac showInView:self.view];
}
*/



- (void)sendPressedAction
{
    NSLog(@"sendPressedAction") ;
    
    [m_sendView sendCommentToServer] ;
}

/*
#pragma mark --
#pragma mark - StarViewDelegate
- (void)sendStarLevel:(int)level
{
    NSLog(@"level :%d",level) ;
}

*/


/*

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
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            
            elcPicker.maximumImagesCount = 10 ; //Set the maximum number of images to select to 100
            elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
            elcPicker.onOrder = NO; //For multiple image selection, display and return order of selected images
            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage];// @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
            
            elcPicker.imagePickerDelegate = self;
            
            [self presentViewController:elcPicker animated:YES completion:nil];
            
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
    m_imageNeedsToDisplay = [info objectForKey: @"UIImagePickerControllerEditedImage"];//UIImagePickerControllerOriginalImage//UIImagePickerControllerEditedImage
    //    m_imageNeedsToDisplay = [UIImage fixOrientation:m_imageNeedsToDisplay];
    [m_photosArray addObject:m_imageNeedsToDisplay] ;
    
    // 1 put in view
    [m_table_pic reloadData] ;
//    _img_head.image = m_imageNeedsToDisplay;
//    _img_head.contentMode = UIViewContentModeScaleAspectFit;     //UIViewContentModeScaleAspectFill;
    
    // 2 put in doucument , db , server
    [self performSelectorInBackground:@selector(saveTheHeadIMG:) withObject:m_imageNeedsToDisplay];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark --
#pragma mark - saveTheHeadIMG

#define         FILE_SIZE               10240

- (void)saveTheHeadIMG:(UIImage *)headIMG
{
    //put in doucument , db , server
    //1 in doucument
    //    NSString *homePath = NSHomeDirectory();
    //    NSString *fileName = [DigitInforMation getHeadName];
    //    NSString *path = [homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/%@",fileName]]; //newFile created
    //    NSData *recData = UIImageJPEGRepresentation(headIMG,1);
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    [fileManager createFileAtPath:path contents:recData attributes:nil];
    
    //2 path in db
    //update picture with currentUserID
    //    [[UserTB shareInstance] updatePicture:path WithUserID:[DigitInforMation shareInstance].currentUser.userID];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_DOWNLOAD_IMG_END object:nil];
    
    //3 to server
    //    int length = [recData length];
    //    NSLog(@"length:%d",length);
    //    int round;//分几段
    //    int fileSize = FILE_SIZE;//每段的size
    //    if (fileSize <= length) {
    //        round = (length%FILE_SIZE) ? ((length/FILE_SIZE)+1) : (length/FILE_SIZE);//文件分成几份
    //    }else {
    //        round = 1;
    //        fileSize = length;
    //    }
    //
    //    for (int times = 0; times < round; times++) {//分段文件
    //        if ((times == round - 1)&&(times != 0)) {
    //            fileSize = length % FILE_SIZE;
    //        }
    //        Byte sectionByte[fileSize];
    //        [recData getBytes:&sectionByte range:NSMakeRange(fileSize*times, fileSize)];
    //        NSData *sectionData = [NSData dataWithBytes:sectionByte length:fileSize];//拿到分段文件
    //        //NSLog(@"sectionLength:%d",[sectionData length]);
    //        //send request
    //        BOOL success = [ServerRequestASI UploadHeadWithHeadName:[NSString stringWithFormat:@"head_%d.jpg",[DigitInforMation shareInstance].currentUser.userID] AndWithFileNO:[NSString stringWithFormat:@"%d",times+1] AndWithFileLength:[NSString stringWithFormat:@"%d",fileSize] AndWithThisFileData:sectionData];
    //
    //        if (!success) {//如果不成功break
    //            break;
    //        }else {
    //            if (times == round - 1) {
    //                [ServerRequestASI updateUserHeadFileName:[NSString stringWithFormat:@"head_%d.jpg",[DigitInforMation shareInstance].currentUser.userID]];
    //            }
    //        }
    //    }
}


#pragma mark --
#pragma mark - ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
	for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                EYLargePhoto *photo = [[EYLargePhoto alloc] init];
                photo.thumb = [dict objectForKey:UIImagePickerControllerOriginalImage];
                UIImage* image=photo.thumb;
                [images addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                EYLargePhoto *photo = [[EYLargePhoto alloc] init];
                photo.thumb = [dict objectForKey:UIImagePickerControllerOriginalImage];
                UIImage* image=photo.thumb;
                [images addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }

//show in table
    m_photosArray = images ;
    [m_table_pic reloadData] ;
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --
#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return m_photosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.imageView.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    cell.imageView.image = [m_photosArray objectAtIndex:indexPath.row] ;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"--------->%d",indexPath.row);
}
*/

#pragma mark --
#pragma mark - CmtSendViewDelegate
- (void)popBackSuperController
{
    [self.navigationController popViewControllerAnimated:YES] ;
}



#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
