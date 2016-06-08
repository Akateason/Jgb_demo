//
//  UIImage+AddFunction.m
//  ParkingSys
//
//  Created by mini1 on 14-6-13.
//  Copyright (c) 2014年 mini1. All rights reserved.
//

#import "UIImage+AddFunction.h"

@implementation UIImage (AddFunction)

#pragma mark --
#pragma mark - 1.添加圆角
//1.添加圆角
+ (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    AddRoundedRectToPath(context, rect, 42, 42);/****the corner degree****/
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}
static void AddRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

#pragma mark --
#pragma mark - 2.裁剪正方
//2.裁剪正方
+ (UIImage *)cuttingImageWithShortSide:(UIImage *)orignImage
{
    
    float wideOffset = 0;
    float heighOffset = 0;
    float squareSide = 0;
    int _abs = abs(orignImage.size.width - orignImage.size.height) ;
    //判断正方
    if ( ( _abs >= 0 ) && ( _abs < 3.0 ) )
    {
        return orignImage;//如果是正方(接近正方),直接返回原图
    }
    
    //判断胖瘦
    if (orignImage.size.width - orignImage.size.height > 0)
    {
        //pang
        wideOffset = (orignImage.size.width - orignImage.size.height)/2;
        squareSide = orignImage.size.height;
    }
    else
    {
        //shou
        heighOffset = (orignImage.size.height - orignImage.size.width)/2;
        squareSide = orignImage.size.width;
    }
    
    CGRect rect =  CGRectMake(wideOffset, heighOffset, squareSide, squareSide);//要裁剪的图片区域以及大小,按照原图的像素大小来，超过原图大小的边自动适配
    
    //    NSLog(@"rect:%@",NSStringFromCGRect(rect));
    
    CGImageRef cgimg = CGImageCreateWithImageInRect([orignImage CGImage], rect);//裁剪
    
    UIImage *imgSend    ;
    
    if (imgSend == nil)
    {
        imgSend = [[UIImage alloc]init]         ;
    }
    imgSend = [UIImage imageWithCGImage:cgimg]  ;
    
    //    NSLog(@"sendIMG:%@",NSStringFromCGSize(imgSend.size));
    
    return imgSend;
}


#pragma mark --
#pragma mark - 3.添加水印
// 画水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext([self size]);
    }
#endif
    //原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //水印图
    [mask drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}


#pragma mark --
#pragma mark - 4.缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        double d = oldsize.width/oldsize.height ;
        if ( d>1 )
        {
            asize.width = asize.height * d;
        }
        else{
            asize.height = asize.width / d;
        }
        
        rect.size.width = asize.width ;
        rect.size.height = asize.height ;
        rect.origin.x = 0;
        rect.origin.y = 0;
        
        //
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
    }
    
    return newimage;
}

+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        double d = oldsize.width/oldsize.height ;
        if ( d>1 )
        {
            asize.width = asize.height * d;
        }
        else{
            asize.height = asize.width / d;
        }
        
        rect.size.width = asize.width ;
        rect.size.height = asize.height ;
        rect.origin.x = 0;
        rect.origin.y = 0;
        
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return newimage;
}

#pragma mark --
#pragma mark - 5.拍完照片的自适应旋转(和相机一起用)
+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
    return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
        break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        break;
        default:
        break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
        default:
        break;
    }
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        // Grr...
        CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
        break;
        default:
        CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
        break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


#pragma mark - 颜色变图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
//    CGContextRelease(context);
    return img;
}


#pragma mark - 将UIView转成UIImage
+ (UIImage *)getImageFromView:(UIView *)theView
{
    CGSize orgSize = theView.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(orgSize, YES, theView.layer.contentsScale * 2);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()]   ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext()    ;
    UIGraphicsEndImageContext() ;
    
    return image                ;
}



#pragma mark --
#pragma mark - UIimage转换NSdata
//1.UIimage转换NSdata
- (NSData *)imageToData
{
    NSData *dataVphoto = [NSData data];
    if (UIImagePNGRepresentation(self) == nil) {
        dataVphoto = UIImageJPEGRepresentation(self, 1);
    } else {
        dataVphoto = UIImagePNGRepresentation(self);
    }
    
    return dataVphoto;
}


#pragma mark --
#pragma mark - NSdata转换UIimage
//2.NSdata转换UIimage
- (UIImage *)dataToImage:(NSData *)_data
{
    return [UIImage imageWithData:_data];
}


/*
**  CGRect rect = CGRectMake(wideOffset, heighOffset, squareSide, squareSide)  **
**/
+ (UIImage *)cuttingImageWithImg:(UIImage *)orignImage AndWithRect:(CGRect)rect
{
    //  裁剪
    CGImageRef cgimg = CGImageCreateWithImageInRect([orignImage CGImage], rect);
    
    UIImage *imgSend    ;
    
    if (imgSend == nil)
    {
        imgSend = [[UIImage alloc]  init]       ;
    }
    imgSend = [UIImage imageWithCGImage:cgimg]  ;
    
    //    NSLog(@"sendIMG:%@",NSStringFromCGSize(imgSend.size));
    
    return imgSend;
}



@end
