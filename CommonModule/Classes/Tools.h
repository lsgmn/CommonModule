//
//  Tools.h
//  HYDigitalDepartment
//
//  Created by Fvictory on 2021/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

/**
 生成纯色图片

 @param color 图片颜色
 @param alpha 透明度
 @return 该颜色的图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color alpha:(CGFloat)alpha;

/**
 将NSDate转化为某格式的NSString
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

/**
 NSDate转化为NSString
 */
+ (NSDate *)dateFromString:(NSString *)string formate:(NSString *)format;

+ (UIImage *)makeQrCodeWithString:(NSString *)string size:(CGSize)size;

+ (void)showHudForView:(UIView *)view;

+ (void)hideHudForView:(UIView *)view;

/** 将图片白色部分变成透明 */
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

+ (NSString *) md5:(NSString *) input;

+ (bool)hasEmoji:(NSString *)string;
//检测字符串是否是纯数字
+ (BOOL)isNumber:(NSString *)num;
//检测字符串是否是数字或字母组成
+ (BOOL)isNumberOrLetter:(NSString *)num;
//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//判断字符串是否为空或者都是空格
+ (BOOL)isBlankString:(NSString *)string;
+ (BOOL)isPasswordNumber:(NSString *)passwordNum;
//身份证校验
+ (BOOL)validateIdentityCard:(NSString *)identityCard;
//次数数字转字符串
+ (NSString *)integerToText:(NSInteger)integer;

//生成0-8的随机数不包括8
+ (int)getRandomNumber:(int)from to:(int)to;

/*!
 *  将字典或者数组转化为JSON串
 *
 *  @param theData theData description
 *
 *  @return <#return value description#>
 */
+ (NSString *)toJSONData:(id)theData;

/** 不会因为应用卸载改变
  * 但是用户在设置-隐私-广告里面限制广告跟踪后会变成@"00000000-0000-0000-0000-000000000000"
  * 重新打开后会变成另一个，还原广告标识符也会变
  */
+ (NSString *)getUUID;

//获取版本号
+ (NSString *)getCurrentAppVersion;

@end

NS_ASSUME_NONNULL_END
