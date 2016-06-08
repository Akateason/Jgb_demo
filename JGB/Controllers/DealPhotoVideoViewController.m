//
//  DealPhotoVideoViewController.m
//  TDIMap
//
//  Created by mini1 on 13-10-24.
//  Copyright (c) 2013年 SHJEC. All rights reserved.
//

#import "DealPhotoVideoViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageManagerDelegate.h"
#import "SDImageCache.h"
//  #import <MediaPlayer/MediaPlayer.h>
//  #import "PlayerViewController.h"

#define APPWIDTH   [UIScreen mainScreen].applicationFrame.size.width
#define APPHEIGHT  ([UIScreen mainScreen].applicationFrame.size.height + 20)


@interface DealPhotoVideoViewController ()
{
    ImageScrollView *imgScrollView;
    int arrNum;
    NSMutableArray *allArr;
    int pageIndex;
    
    NSMutableArray *m_videoIndex;
    NSMutableArray *m_pathStr;
}

@end

@implementation DealPhotoVideoViewController

@synthesize m_imgKeyArray,m_currentImgVideoIndex ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO  animated:NO] ;
}

- (void)setup
{
    self.automaticallyAdjustsScrollViewInsets = NO ;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    allArr = [NSMutableArray arrayWithArray:m_imgKeyArray];
    arrNum = [allArr count];
    //------------------------------------------------//
    _count = arrNum;
    _index = m_currentImgVideoIndex;
    //------------------------------------------------//
    // base scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, APPWIDTH, APPHEIGHT)];
    _scrollView.backgroundColor = [UIColor whiteColor];//[UIColor blackColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    // 设置内容大小
    _scrollView.contentSize = CGSizeMake((APPWIDTH) * arrNum, APPHEIGHT);                                           // - 44
    [self.view addSubview:_scrollView];
    
    // 设置ScrollView已经去的位置,
    CGRect fm = [UIScreen mainScreen].applicationFrame;
    CGPoint p = _scrollView.contentOffset;
    p.x       = m_currentImgVideoIndex * (fm.size.width) ;
    _scrollView.contentOffset = p ;
    
    // imgsArr = [NSMutableArray arrayWithCapacity:1] ;
    
    for (int i = 0; i < arrNum; i++)
    {
        //地址字符串
        NSString *pathForTheMedia = [allArr objectAtIndex:i];
        if ([pathForTheMedia hasSuffix:@"MP4"]||[pathForTheMedia hasSuffix:@"mp4"])
        {
            //            //是视频的缩略图
            //            //缩略图
            //            NSData *imgData = [[allArr objectAtIndex:i] objectAtIndex:0];
            //            UIImage *img = [UIImage imageWithData:imgData];
            //            [imgsArr addObject:img];
            //            [m_videoIndex addObject:[NSNumber numberWithInt:i]];//nsnumber
        }
        else
        {
            //原图
            //            UIImage *img = [[SDImageCache sharedImageCache] imageFromKey:[allArr objectAtIndex:i]] ;
            //            [imgsArr addObject:img];
        }
        [m_pathStr addObject:pathForTheMedia];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setup] ;
    
//------------------------------------------------//
    
    if (_index == 0 )
    {
        [self creatFirstView];
    }
    else if(_index == arrNum - 1)
    {
        [self creatLastView];
    }
    else
    {
        [self createIndexView];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageIndex = ( scrollView.contentOffset.x / ([UIScreen mainScreen].applicationFrame.size.width) );
    NSLog(@"pageIndex:%d",pageIndex);
    NSLog(@"_index:%d",_index);
    if (arrNum == 2) {
        _currentType = 2;
    }
    NSLog(@"_currentType:%d",_currentType);
    
    //判断index是否是视频
    for (NSNumber *numIndex in m_videoIndex) {
        if (pageIndex == [numIndex intValue]) {
            NSLog(@" %d is video!!!!!",pageIndex);
        }
    }
    
    //----------------------------------------//
    if ( (pageIndex == 0)&&(_index == 1)&&(_currentType == 2)&&(arrNum == 1) ) {
        return;
    }else{
        switch (_currentType) {
            case 0:
            {
                _index = _index + pageIndex;
                if (pageIndex == 1) {
                    [self createIndexView];
                }
                break;
            }
            case 1:
            {
                _index = _index + pageIndex - 1;
                if (pageIndex == 0) {
                    [self createIndexView];
                }
                break;
            }
            case 2:
            {
                _index = _index + pageIndex - 1;
                NSLog(@"ciciINdex:%d",_index);
                if (_index == 0) {
                    if (arrNum == 2) {
                        if ((_index == 0)&&(pageIndex == 0)) {
                            [self creatFirstView];
                        }else{
                            [self creatLastView];
                        }
                    }else{
                        [self creatFirstView];
                    }
                }else if (_index == _count - 1){
                    [self creatLastView];
                }else if (_index == -1){
                    if (arrNum == 2) {
                        [self creatFirstView];
                    }else{
                        return;
                    }
                }
                else {
                    [self createIndexView];
                }
                break;
            }
            default:
                break;
        }
    }
    
    scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = NO;
    if (arrNum == 2) {
        scrollView.userInteractionEnabled = YES;
    }
}

#define MY_SIZE   CGSizeMake(APPWIDTH, APPHEIGHT)

- (void)createIndexView{
    [_firstView removeFromSuperview];
    [_secondView removeFromSuperview];
    [_thirdView removeFromSuperview];

    //type -------   0 is photo , 1 is video
    //判断是否是视频
    BOOL isVdo1 = NO;
    BOOL isVdo2 = NO;
    BOOL isVdo3 = NO;
    for (NSNumber *vIndex in m_videoIndex) {
        //
        if (_index-1 == [vIndex intValue]) {
            //load movie play view
            isVdo1 = YES;
        }
        if (_index == [vIndex intValue]) {
            //load movie play view
            isVdo2 = YES;
        }
        if (_index+1 == [vIndex intValue]) {
            //load movie play view
            isVdo3 = YES;
        }
    }
    //1st
    _firstView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, APPWIDTH, APPHEIGHT)];
    _firstView.delegateImageSV = self;
    
//    _firstView.imageView.image = imgsArr[_index - 1];
//    [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index - 1]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
    [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index - 1]] placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom] ;
    
    if (isVdo1) {
        _firstView.type = 1;
    }else{
        _firstView.type = 0;
    }
    _firstView.indexBeSend = _index;
    [_scrollView addSubview:_firstView];
    //sec
    _secondView = [[ImageScrollView alloc] initWithFrame:CGRectMake(APPWIDTH, 0, APPWIDTH, APPHEIGHT)];
    _secondView.delegateImageSV = self;

//    _secondView.imageView.image = imgsArr[_index];
//    [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
    [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index]] placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom] ;
    
    if (isVdo2) {
        _secondView.type = 1;
    }else{
        _secondView.type = 0;
    }
    _secondView.indexBeSend = _index;
    [_scrollView addSubview:_secondView];
    //3rd
    _thirdView = [[ImageScrollView alloc] initWithFrame:CGRectMake(APPWIDTH*2, 0, APPWIDTH, APPHEIGHT)];
    _thirdView.delegateImageSV = self;

//    _thirdView.imageView.image = imgsArr[_index + 1];
//    [_thirdView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index + 1]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
    [_thirdView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index + 1]] placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom] ;
    
    if (isVdo3) {
        _thirdView.type = 1;
    }else{
        _thirdView.type = 0;
    }
    _thirdView.indexBeSend = _index;
    [_scrollView addSubview:_thirdView];
        
    [_scrollView scrollRectToVisible:CGRectMake(APPWIDTH, 0, APPWIDTH, APPHEIGHT) animated:NO];
    _scrollView.contentSize = CGSizeMake(APPWIDTH*3, APPHEIGHT);
    _currentType = 2;
}

- (void)creatFirstView
{
    [_firstView     removeFromSuperview] ;
    [_secondView    removeFromSuperview] ;
    [_thirdView     removeFromSuperview] ;
    
    //type -------   0 is photo , 1 is video
    
    //判断是否是视频
    BOOL isVdo1 = NO;
    BOOL isVdo2 = NO;
    BOOL isVdo3 = NO;
    for (NSNumber *vIndex in m_videoIndex)
    {
        if (_index == [vIndex intValue]) {
            //load movie play view
            isVdo1 = YES;
        }
        if (_index+1 == [vIndex intValue]) {
            //load movie play view
            isVdo2 = YES;
        }
        if (_index+2 == [vIndex intValue]) {
            //
            isVdo3 = YES;
        }
    }
    
    _firstView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, APPWIDTH, APPHEIGHT)];
    _firstView.delegateImageSV = self;

    [_scrollView addSubview:_firstView];
    
    NSURL *headNewStr ;
    if (_index == -1)
    {
//        _firstView.imageView.image = imgsArr[_index + 1];
//        [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index + 1]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
        headNewStr = [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index + 1]] placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:+_isRandom] ;
        
        _firstView.indexBeSend = _index + 1;
        if (isVdo2) {
            _firstView.type = 1;
        }else{
            _firstView.type = 0;
        }
    }
    else
    {
//        _firstView.imageView.image = imgsArr[_index];
//        [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
        headNewStr = [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index]] placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom] ;
        
        _firstView.indexBeSend = _index;
        if (isVdo1) {
            _firstView.type = 1;
        }else{
            _firstView.type = 0;
        }
    }
    
    [self updateNewImagesWithNewUrl:headNewStr] ;
    
    int allArrNum  = [allArr count];
    NSLog(@"allarrNUm:%d",allArrNum);
    if (allArrNum == 1) return ;
    
    _secondView = [[ImageScrollView alloc] initWithFrame:CGRectMake(APPWIDTH, 0, APPWIDTH, APPHEIGHT)];
    _secondView.delegateImageSV = self;

    [_scrollView addSubview:_secondView];
    _secondView.indexBeSend = _index;
    if (_index == -1) {
//        _secondView.imageView.image = imgsArr[_index+2];
//        [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index+2]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
        [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index+2]] placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom] ;
        
        _secondView.indexBeSend = _index + 2;
        _index = 0;
        if (isVdo3) {
            _secondView.type = 1;
        }
        else {
            _secondView.type = 0;
        }
    }
    else {
//        _secondView.imageView.image = imgsArr[_index+1];
//        [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index+1]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
        [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index+1]] placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom ] ;
        
        _secondView.indexBeSend = _index + 1;
        if (isVdo2) {
            _secondView.type = 1;
        }
        else {
            _secondView.type = 0;
        }
    }
    
    _scrollView.contentSize = CGSizeMake(APPWIDTH * 2, APPHEIGHT);
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, APPWIDTH, APPHEIGHT) animated:NO];
    _currentType = 0;

}

- (void)updateNewImagesWithNewUrl:(NSURL *)newURl
{
// 当且仅当是头像
    if (_isRandom)
    {
        dispatch_queue_t queue = dispatch_queue_create("renewImgs", NULL) ;
        dispatch_async(queue , ^{
            
            sleep(1) ;
            
            UIImage *newImage = [[SDImageCache sharedImageCache] imageFromKey:newURl.absoluteString] ;
            
            [[SDImageCache sharedImageCache] updateNewImgWithNewUrl:newURl AndWithNewImg:newImage] ;
            
        }) ;
    }
}

- (void)creatLastView{
    [_firstView removeFromSuperview];
    [_secondView removeFromSuperview];
    [_thirdView removeFromSuperview];
    
    //type -------   0 is photo , 1 is video
    //判断是否是视频
    BOOL isVdo1 = NO;
    BOOL isVdo2 = NO;
    BOOL isVdo3 = NO;
    for (NSNumber *vIndex in m_videoIndex) {
        //
        if (_index-1 == [vIndex intValue]) {
            //load movie play view
            isVdo1 = YES;
        }
        if (_index == [vIndex intValue]) {
            //load movie play view
            isVdo2 = YES;
        }
        if (_index+1 == [vIndex intValue]) {
            //load movie play view
            isVdo3 = YES;
        }
    }
    
    _firstView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, APPWIDTH, APPHEIGHT)];
    _firstView.delegateImageSV = self;

    [_scrollView addSubview:_firstView] ;
    
    if ((arrNum == 2)&&(_index != 1))
    {
//        _firstView.imageView.image = imgsArr[_index] ;
//        [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
        [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index]]  placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom] ;
        
        _firstView.indexBeSend = _index ;
        
        if (isVdo2)
        {
            _firstView.type = 1;
        }
        else
        {
            _firstView.type = 0;
        }
    }
    else
    {
//        _firstView.imageView.image = imgsArr[_index - 1];
//        [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index-1]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
        [_firstView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index-1]]  placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom] ;
        
        _firstView.indexBeSend = _index - 1;
        if (isVdo1) {
            _firstView.type = 1;
        }else{
            _firstView.type = 0;
        }
    }
    _secondView = [[ImageScrollView alloc] initWithFrame:CGRectMake(APPWIDTH, 0, APPWIDTH, APPHEIGHT)];
    _secondView.delegateImageSV = self;

    [_scrollView addSubview:_secondView];
    if ((arrNum == 2)&&(_index != 1)) {
//        _secondView.imageView.image = imgsArr[_index + 1];
//        [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index+1]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
        [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index+1]]  placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom] ;
        
        _secondView.indexBeSend = _index+1;
        if (isVdo3) {
            _secondView.type = 1;
        }else{
            _secondView.type = 0;
        }
    }else{
//        _secondView.imageView.image = imgsArr[_index];
//        [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index]]  placeholderImage:IMG_NOPIC AndSaleSize:MY_SIZE];
        [_secondView.imageView setImageWithURL:[NSURL URLWithString:allArr[_index]]  placeholderImage:IMG_NOPIC options:0 AndSaleSize:MY_SIZE AndWithRandom:_isRandom] ;
        
        _secondView.indexBeSend = _index;
        if (isVdo2)
        {
            _secondView.type = 1;
        }
        else
        {
            _secondView.type = 0;
        }
    }
    
    _scrollView.contentSize = CGSizeMake(APPWIDTH*2, APPHEIGHT);
    [_scrollView scrollRectToVisible:CGRectMake(APPWIDTH,0, APPWIDTH, APPHEIGHT) animated:NO];
    _currentType = 1;
}



#pragma mark --
#pragma mark -- imageScrollView delegate
/*
- (void)wantToPlayTheMovie:(int)vIndex
{
//    NSLog(@"播放,%D",vIndex);
    //video
    NSString *localStr = [m_pathStr objectAtIndex:vIndex];
    NSLog(@"local str:%@",localStr);
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:localStr]) {
        //NSLog(@"Exists");
    }else {
        //not exists
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:WORD_CONVERTWATING message:nil delegate:nil cancelButtonTitle:WORD_CANCEL otherButtonTitles:nil, nil];
        [alert show];
    }
    
    //play movie
    NSURL *url = [NSURL fileURLWithPath:localStr];
    MPMoviePlayerViewController *playerViewController = [[PlayerViewController alloc] initWithContentURL:url];
    playerViewController.moviePlayer.controlStyle = MPMovieControlModeVolumeOnly;
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
}
*/

- (void)shutDown
{
    [self.navigationController popViewControllerAnimated:YES] ;
}


@end

