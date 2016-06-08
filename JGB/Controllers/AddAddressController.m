//
//  AddAddressController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-9.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "AddAddressController.h"
#import "DigitInformation.h"
#import "AddAddrView.h"
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ServerRequest.h"
#import "YXSpritesLoadingView.h"

@interface AddAddressController () <AddAddrViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate>
{
    AddAddrView     *m_addrView ;
    
    UIImage         *m_imageNeedsToDisplay;
    
    BOOL            m_isfrontOrBack ;      //身份证正反面

}
@end

@implementation AddAddressController

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
    
    
//1.
    self.title = (_myAddr) ? @"编辑地址" : @"新增地址" ;

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(confrim)] ;
    self.navigationItem.rightBarButtonItem = rightBarItem ;

//    
    [self setup] ;
    
}


- (void)addAddrView
{
    //2. my scroll view
    if (!m_addrView)
    {
        m_addrView = (AddAddrView *)[[[NSBundle mainBundle] loadNibNamed:@"AddAddrView" owner:self options:nil] objectAtIndex:0]   ;
        
        _scrollV.contentSize        = m_addrView.frame.size ;
        NSLog(@"addr contentsize : %@",NSStringFromCGSize(_scrollV.contentSize)) ;
        
        _scrollV.backgroundColor    = [UIColor whiteColor]  ;
        m_addrView.controller       = self                  ;
        
        m_addrView.delegate         = self                  ;
        [_scrollV addSubview:m_addrView]                    ;
    }
    
    //  set my address
    m_addrView.myAddress = _myAddr ;
}


- (void)bottomViewSetup
{
    //3. set bottom view
    UIView *upline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)] ;
    upline.backgroundColor = COLOR_BACKGROUND ;
    [_bottomView addSubview:upline] ;
    
    _bottomView.backgroundColor = [UIColor whiteColor] ;
    _bt_setDefault.backgroundColor = COLOR_PINK ;
    _bt_setDefault.layer.cornerRadius = CORNER_RADIUS_ALL ;
    [_bt_setDefault setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    // bottom view show or hide
    _bottomView.hidden = (_myAddr != nil) ? NO : YES ;
}

- (void)setup
{
    [self addAddrView] ;


    [self bottomViewSetup] ;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated] ;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated] ;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - AddAddrViewDelegate
- (void)navigationPopBack
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (void)confrim
{
    [m_addrView confirmPressedAction:nil] ;
}


#pragma mark --
#pragma mark - actions
- (IBAction)defaultAddressPressedAction:(UIButton *)sender
{
    // 设置默认地址
    NSLog(@"设置默认地址") ;
    
    if (_myAddr)
    {
        _myAddr.isDefault = YES ;
        
        [YXSpritesLoadingView showWithText:WD_HUD_GOON andShimmering:NO andBlurEffect:YES] ;
        
        [DigitInformation showHudWhileExecutingBlock:^{
            
            [ServerRequest editAddressWithAddress:_myAddr] ;
            
        } AndComplete:^{
            
            [YXSpritesLoadingView dismiss] ;
            
            [self.navigationController popViewControllerAnimated:YES] ;
            
        } AndWithMinSec:0] ;
    }
    
}


@end


