//
//  AEFilePath.m
//  ArtEast
//
//  Created by yibao on 16/10/19.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import "AEFilePath.h"

@implementation AEFilePath

+(void)createDirPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:kIconPath])
    {
        [manager createDirectoryAtPath:kIconPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![manager fileExistsAtPath:kJsonPath])
    {
        [manager createDirectoryAtPath:kJsonPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![manager fileExistsAtPath:kCCVideoPath])
    {
        [manager createDirectoryAtPath:kCCVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+(NSString *)filePathWithType:(enum AEFilePathType)type withFileName:(NSString *)fileName
{
    NSString *filePath = nil;
    switch (type)
    {
        case AEFilePathType_IconPath:
        {
            filePath = [kIconPath stringByAppendingPathComponent:@"Icon_200_200.jpg"];
        }
            break;
        case AEFilePathType_TypeListJson:
        {
            filePath = [kJsonPath stringByAppendingPathComponent:@"typeList.json"];
        }
            break;
        case AEFilePathType_CCVideo:
        {
            filePath = [kCCVideoPath stringByAppendingFormat:@"/%@.pcm",fileName];
        }
            break;
        case AEFilePathType_CCVideoLengthString:
        {
            filePath = [kCCVideoPath stringByAppendingFormat:@"/%@.string",fileName];
        }
            break;
        default:
            break;
    }
    return filePath;
}

+(long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+(NSString *)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath])
    {
        return @"0MB";
    }
    else
    {
        NSArray *childFiles = [fileManager subpathsAtPath:folderPath];
        long long folderSize = 0;
        for (NSString *fileName in childFiles)
        {
            NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:filePath];
        }
        return [NSString stringWithFormat:@"%.0fMB",folderSize/1024.0/1024.0];
    }
}

@end
