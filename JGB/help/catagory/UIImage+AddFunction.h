//
//  UIImage+AddFunction.h
//  ParkingSys
//
//  Created by mini1 on 14-6-13.
//  Copyright (c) 2014年 mini1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AddFunction)

#pragma mark -- style

//1.添加圆角
+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size;

//2.裁剪正方
+ (UIImage *)cuttingImageWithShortSide:(UIImage *)orignImage;

//3.添加水印
- (UIImage *)imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;

//4.缩略图thumbnail
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;//常用这个
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;//

//5.拍完照片的自适应旋转(和相机一起用)
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//6.颜色变图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//7.将UIView转成UIImage
+ (UIImage *)getImageFromView:(UIView *)theView ;

/*8.裁剪
 **  CGRect rect = CGRectMake(wideOffset, heighOffset, squareSide, squareSide)  **
 **/
+ (UIImage *)cuttingImageWithImg:(UIImage *)orignImage AndWithRect:(CGRect)rect ;



#pragma mark -- convert

//1.UIimage转换NSdata
- (NSData *)imageToData;
//2.NSdata转换UIimage
- (UIImage *)dataToImage:(NSData *)_data;




@end
