//
//  MyFileManager.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-29.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MyFileManager.h"

@implementation MyFileManager


#pragma mark --
//创建文件夹
+ (void)createFileBoxesWithPath:(NSString *)pathStr
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",pathStr];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//判断文件名存在吗
+ (BOOL)is_file_exist:(NSString *)path
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:path];
}

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

//删除文件
+ (BOOL)deleteFileWithFileName:(NSString *)fileName
{
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm removeItemAtPath:fileName error:nil];
}

//归档对象
+ (void)archiveTheObject:(id)obj AndPath:(NSString *)path
{
    BOOL success = [NSKeyedArchiver archiveRootObject:obj toFile:path];
    if (success) {
        NSLog(@"Archive success");
    }
}

//解归档
+ (id)getObjUnarchivePath:(NSString *)path
{
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];//因为知道是数组,所以用数组接受
    
    return obj;
}


@end
