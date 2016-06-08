/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "UIImage+AddFunction.h"
#import "DigitInformation.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "SDImageCache.h"

@implementation UIImageView (WebCache)


- (void)setImageWithURL:(NSURL *)url AndSaleSize:(CGSize)aSize
{
    [self setImageWithURL:url placeholderImage:nil AndSaleSize:aSize];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder AndSaleSize:(CGSize)aSize
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 AndSaleSize:aSize AndWithRandom:NO];
}

- (NSURL *)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options AndSaleSize:(CGSize)aSize AndWithRandom:(BOOL)bRandom
{
    
    if (!bRandom)
    {
        //不需要随机数
        url = [self getUrlBeTransitedForOnlineConditionWithUrl:url] ; //根据网络情况拿图
    }
    else
    {
        //需要随机数
        url = [self getUrlAddRandomWithUrl:url] ;
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self] ;
    
    self.image = placeholder ;
    
    if (url)
    {
        UIImage *cacheImage = [manager imageWithURL:url]            ;
        BOOL b =  ( (aSize.width == 0.0) && (aSize.height == 0.0) ) ;
        if ( !b )
        {
            cacheImage      = [UIImage thumbnailWithImage:cacheImage size:aSize] ;
        }
        
        if (cacheImage)
        {
            self.image = cacheImage;
        }
        else
        {
            [manager downloadWithURL:url delegate:self options:options];
        }
    }
    
    return url ;
}

//首页
- (NSURL *)setIndexImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options AndSaleSize:(CGSize)aSize
{
    
    url = [self getUrlBeTransitedForIndexPageWithUrl:url AndWithWid:aSize.width] ; //根据手机的最大宽度 拿图
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self] ;
    
    self.image = placeholder ;
    
    if (url)
    {
        UIImage *cacheImage = [manager imageWithURL:url]            ;
        BOOL b =  ( (aSize.width == 0.0) && (aSize.height == 0.0) ) ;
        if ( !b )
        {
            cacheImage      = [UIImage thumbnailWithImage:cacheImage size:aSize] ;
        }
        
        if (cacheImage)
        {
            self.image = cacheImage;
        }
        else
        {
            [manager downloadWithURL:url delegate:self options:options];
        }
    }
    
    return url ;
}


- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image ;
}

- (void)updateNewImgWithNewUrl:(NSURL *)url AndWithNewImg:(UIImage *)newImage
{
    NSString *urlStr = url.absoluteString ;                                         //加随机数的图
    NSString *orgStr = [[urlStr componentsSeparatedByString:@"?"] firstObject] ;    //原图
    
    [[SDImageCache sharedImageCache] storeImage:newImage forKey:orgStr toDisk:YES] ;
}



#pragma mark - private get images with netword condition
- (NSURL *)getUrlBeTransitedForOnlineConditionWithUrl:(NSURL *)url
{
    NSString *urlStr = url.absoluteString ;

    if (G_IMG_MODE == 0)
    {
        if (G_ONLINE_MODE == 2)
        {
            urlStr = [urlStr stringByAppendingString:IMG_3G_STR] ;
            url = [NSURL URLWithString:urlStr] ;
        }
    }
    else if (G_IMG_MODE == 2)
    {
        urlStr = [urlStr stringByAppendingString:IMG_3G_STR]    ;
        url = [NSURL URLWithString:urlStr]  ;
    }
    
    return url ;
}

#pragma mark -  get images with the phones widths
- (NSURL *)getUrlBeTransitedForIndexPageWithUrl:(NSURL *)url AndWithWid:(int)wid
{
    NSString *urlStr = url.absoluteString ;
    
    urlStr = [urlStr stringByAppendingString:IMG_PHONE_WID(wid)] ;
    url = [NSURL URLWithString:urlStr]  ;
    
    return url ;
}

- (NSURL *)getUrlAddRandomWithUrl:(NSURL *)url
{
    NSString *urlStr    = url.absoluteString ;
    NSString *tickStr   = [NSString stringWithFormat:@"%@%lld",IMG_RANDOM,[MyTick getTickWithDate:[NSDate date]]] ;
    urlStr              = [urlStr stringByAppendingString:tickStr] ;
    
    url = [NSURL URLWithString:urlStr]  ;
    
    return url ;
}

@end
