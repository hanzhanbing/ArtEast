//
//  Utils.h
//  ArtEast
//
//  Created by yibao on 16/9/21.
//  Copyright © 2016年 北京艺宝网络文化有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

/*!
 *  @brief 判断网络状态
 */
+ (BOOL)getNetStatus;

/*!
 *  @brief 仿安卓消息提示
 */
+ (void)showToast:(NSString *)message;

/*!
 *  @brief 判断字符串是否为空
 */
+ (BOOL)isBlankString:(id)string;

/*!
 *  @brief 根据文字内容、字体大小、行高获取文本宽度
 */
+ (CGFloat)getTextWidth:(NSString *)text fontSize:(float)fontSize forHeight:(CGFloat)height;

/*!
 *  @brief 根据文字内容、字体大小、行宽获取文本高度
 */
+ (CGFloat)getTextHeight:(NSString *)text font:(UIFont *)font forWidth:(CGFloat)width;

/*!
 *  @brief 根据bundleName、resourceName获取Pods资源路径
 */
+ (NSString *)getPodsResourcePathWithBundleName:(NSString *)bundleName andResourceName:(NSString *)resourceName;

/*!
 *  @brief 获取当前视图控制器
 */
+ (UIViewController *)getCurrentVC;

/*!
 *  @brief 判断系统相机权限
 */
+ (BOOL)isCameraPermissionOn;

/*!
 *  @brief 判断系统照片权限
 */
+ (BOOL)isPhotoPermissionOn;

/*!
 *  @brief 判断系统通讯录权限
 */
+ (void)checkAddressBookAuthorization:(void (^)(bool isAuthorized))block;

/*!
 *  @brief 判断系统麦克风权限
 */
+ (void)checkMicrophoneAuthorization:(void (^)(bool isAuthorized))block;

/*!
 *  @brief 根据文字转化为MD5
 */
+ (NSString *)md5HexDigest:(NSString *)input;

/*!
 *  @brief 获得当前时间
 */
+ (NSString *)getCurrentTime;

/*!
 *  @brief 字典转换为字符串
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

/*!
 *  @brief 字符串转换为字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*!
 *  @brief 判断用户是否登录
 */
+ (BOOL)isUserLogin;

/*!
 *  @brief 正则判断手机号码地址格式
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/*!
 *  @brief 根据文字计算文字所占的位置
 */
+ (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font;

/*!
 *  @brief 打电话
 */
+ (UIWebView *)call:(NSString *)phoneAccount;

/*!
 *  @brief 清除缓存
 */
+ (void)clearCache;

/*!
 *  @brief 清除HTML类型文件缓存
 */
+ (void)clearHTMLCache;

/*!
 *  @brief 清除WKWebView缓存
 */
+ (void)clearWebViewCache;

/*!
 *  @brief 给UILable添加删除线
 */
+ (void)addDeleteLine:(UILabel *)view andContent:(NSString *)content andRang:(NSRange )range;

/*!
 *  @brief url编码
 */
+ (NSString *)urlEncoding:(NSString *)urlString;

/*!
 *  @brief url解码
 */
+ (NSString *)urlDecoding:(NSString *)str;

/*!
 *  @brief 将获得的key进性urlencode操作
 */
+ (NSString *)stringByEncodingURLFormat:(NSString*)_key;

/*!
 *  @brief 截取网页附带的参数转换成字典
 */
+ (NSMutableDictionary *)subWebUrlParChangeDic:(NSString *)urlStr;

/*!
 *  @brief 屏幕快照
 */
+ (UIImage *)snapshotSingleView:(UIView *)view;

/*!
 *  @brief 根据时间戳获取星期几
 */
+ (NSString *)getWeekDayFordate:(long long)data;

/*!
 *  @brief 根据NSString类型时间戳转换为日期格式
 */
+ (NSString *)getDateAccordingTime:(NSString *)aTime formatStyle:(NSString *)formate;

@end
