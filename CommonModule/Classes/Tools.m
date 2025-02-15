//
//  Tools.m
//  HYDigitalDepartment
//
//  Created by Fvictory on 2021/11/3.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <AdSupport/AdSupport.h>

static NSDateFormatter *dateFormatter = nil;

@implementation Tools

+ (UIImage *)imageFromColor:(UIColor *)color alpha:(CGFloat)alpha {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[color colorWithAlphaComponent:alpha] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
        
    }
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string formate:(NSString *)format {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
    }
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:string];
}

+ (UIImage *)makeQrCodeWithString:(NSString *)string size:(CGSize)size {
    CIImage *cig = [self generateQRCodeImage:string];
    
    return [self resizeCodeImage:cig withSize:size];
}

+ (CIImage *)generateQRCodeImage:(NSString *)source
{
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"Q" forKey:@"inputCorrectionLevel"];
    
    return filter.outputImage;
}
+ (UIImage *) resizeCodeImage:(CIImage *)image withSize:(CGSize)size
{
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        CGContextRelease(contentRef);
        CGImageRelease(imageRef);
        return [UIImage imageWithCGImage:imageRefResized];
    }else{
        return nil;
    }
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue {
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
//    for (int i = 0; i < pixelNum; i++, pCurPtr++){
//        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
//        {
//            // 改成下面的代码，会将图片转成想要的颜色
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[3] = red; //0~255
//            ptr[2] = green;
//            ptr[1] = blue;
//        }
//        else
//        {
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[0] = 0;
//        }
//    }
    int allCount = 0;
    int whiteWidth = 0;
    for (int i = 0; i < imageHeight; i++) {
        for (int j = 0; j < imageWidth; j++, pCurPtr++, allCount++) {
            if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
                // 有色部分
                whiteWidth = i;
                break;
            }
        }
        if (whiteWidth != 0) {
            break;
        }
    }
    whiteWidth/=2;
    pCurPtr-=allCount;
    for (int i = 0; i < imageHeight; i++) {
        for (int j = 0; j < imageWidth; j++, pCurPtr++) {
            if (j < whiteWidth || i < whiteWidth || imageWidth-j<=whiteWidth || imageHeight-i<=whiteWidth) {
                uint8_t* ptr = (uint8_t*)pCurPtr;
                ptr[0] = 0;
                
            } else {
                if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
                {
                    // 改成下面的代码，会将图片转成想要的颜色
                    uint8_t* ptr = (uint8_t*)pCurPtr;
                    ptr[3] = red; //0~255
                    ptr[2] = green;
                    ptr[1] = blue;
                }
            }
        }
    }
    
    
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}



+ (void)hideHudForView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:false];
}

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return  output;
}

+ (bool)hasEmoji:(NSString *)string {
    NSString *mobile = @"[!-~\u4e00-\u9fa5\u3000-\u301e\ufe10-\ufe19\ufe30-\ufe44\ufe50-\ufe6b\uff01-\uffee]+";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return ![regextestmobile evaluateWithObject:string];
}
//检测字符串是否是纯数字
+ (BOOL)isNumber:(NSString *)num
{
    NSString *number = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:number] invertedSet];
    NSString *filtered = [[num componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [num isEqualToString:filtered];
    return basic;
}

//检测字符串是否是数字或字母组成
+ (BOOL)isNumberOrLetter:(NSString *)num
{
    NSString *numberOrLetter = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
//    NSString * nub = @"^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{6,16}$";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:numberOrLetter] invertedSet];
    NSString *filtered = [[num componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [num isEqualToString:filtered];
    return basic;
}

+ (BOOL)isPasswordNumber:(NSString *)passwordNum{
//    NSString * mobile = @"^1[3456789]\\d{9}$";
    NSString * nub = @"^(?![A-Z]+$)(?![a-z]+$)(?!\\d+$)(?![\\W_]+$)\\S{6,16}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nub];
    if ([regextestmobile evaluateWithObject:passwordNum] == YES) {
        return YES;
    }else {
        return NO;
    }
}


//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * mobile = @"^1[3456789]\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES) {
        return YES;
    }else {
        return NO;
    }
}

//判断字符串是否为空或者都是空格
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil){
        return YES;
    }
    if (string == NULL){
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]){
        return YES;
    }
    //判断字符串是否全部为空格（[NSCharacterSet whitespaceAndNewlineCharacterSet]去掉字符串两端的空格)
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        return YES;
    }
    return NO;
}
/**
 *  身份证号验证(粗略验证)
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
     NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
     NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
     BOOL isMatch = [pred evaluateWithObject:identityCard];

 return isMatch;
}

+ (NSString *)integerToText:(NSInteger)integer
{
    switch (integer) {
        case 1:
            return @"第一次";
            break;
        case 2:
            return @"第二次";
            break;
        case 3:
            return @"第三次";
            break;
        case 4:
            return @"第四次";
            break;
        case 5:
            return @"第五次";
            break;
        case 6:
            return @"第六次";
            break;
        case 7:
            return @"第七次";
            break;
        case 8:
            return @"第八次";
            break;
        case 9:
            return @"第九次";
            break;
        case 10:
            return @"第十次";
            break;
        case 11:
            return @"第十一次";
            break;
        case 12:
            return @"第十二次";
            break;
        default:
            break;
    }
    return @"";
}

//生成0-8的随机数不包括8
+ (int)getRandomNumber:(int)from to:(int)to{
    
    return (int)(from + (arc4random() % (to - from)));
}

/*!
 *  将字典或者数组转化为JSON串
 *
 *  @param theData theData description
 *
 *  @return <#return value description#>
 */
+ (NSString *)toJSONData:(id)theData{
    NSString * jsonString = @"";
    if (theData != nil) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
 
        if ([jsonData length] != 0){
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
//        //去除空格和回车：
//        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
//    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
//
//    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range];
    return mutStr;
}

/** 不会因为应用卸载改变
  * 但是用户在设置-隐私-广告里面限制广告跟踪后会变成@"00000000-0000-0000-0000-000000000000"
  * 重新打开后会变成另一个，还原广告标识符也会变
  */
+ (NSString *)getUUID{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

//获取版本号
+ (NSString *)getCurrentAppVersion{
    NSBundle *bundle = [NSBundle mainBundle];
    // 从 Info.plist 中获取 CFBundleShortVersionString，它对应着应用的版本号
    NSString *version = [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    return version;
}

@end
