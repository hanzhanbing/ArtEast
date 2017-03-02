//
//  AEFilePath.h
//  ArtEast
//
//  Created by yibao on 16/10/19.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTempPath NSTemporaryDirectory()
#define kDocmentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define kIconPath [kTempPath stringByAppendingPathComponent:@"Image"]
#define kJsonPath [kDocmentPath stringByAppendingPathComponent:@"Json"]
#define kCCVideoPath [kDocmentPath stringByAppendingPathComponent:@"Video"]

enum AEFilePathType
{
    AEFilePathType_IconPath,
    AEFilePathType_TypeListJson,
    AEFilePathType_CCVideo,
    AEFilePathType_CCVideoLengthString,
};

@interface AEFilePath : NSObject

+(void)createDirPath;

+(NSString *)filePathWithType:(enum AEFilePathType)type withFileName:(NSString *)fileName;

+(long long)fileSizeAtPath:(NSString *)filePath;

+(NSString *)folderSizeAtPath:(NSString *)folderPath;

@end
