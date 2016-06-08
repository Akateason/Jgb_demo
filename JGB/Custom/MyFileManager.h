//
//  MyFileManager.h
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-29.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFileManager : NSObject


//创建文件夹
+ (void)createFileBoxesWithPath:(NSString *)pathStr;

//判断文件名存在吗
+ (BOOL)is_file_exist:(NSString *)path;

//单个文件大小
+ (long long) fileSizeAtPath:(NSString*) filePath;

//删除文件
+ (BOOL)deleteFileWithFileName:(NSString *)fileName;

//归档obj
+ (void)archiveTheObject:(id)obj AndPath:(NSString *)path;

//解归档
+ (id)getObjUnarchivePath:(NSString *)path;



@end
