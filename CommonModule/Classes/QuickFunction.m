//
//  QuickFunction.m
//  CarServe
//
//  Created by IBTC on 2019/6/19.
//  Copyright © 2019 IBTC. All rights reserved.
//
#import "QuickFunction.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import <sys/utsname.h>
#import <Photos/Photos.h>
#import <ifaddrs.h>
//#import <resolv.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <netdb.h>
#import <netinet/ip.h>
#import <net/ethernet.h>
#import <net/if_dl.h>


#define MDNS_PORT       5353
#define QUERY_NAME      "_apple-mobdev2._tcp.local"
#define DUMMY_MAC_ADDR  @"02:00:00:00:00:00"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


#pragma mark - 导航的高度
CGFloat const NAVH    = 44;
#pragma mark - iphoneX 虚拟bar高度
int const iphoneXBarH = 35;

@implementation QuickFunction
CGFloat QF_SCREE_HEIGHT(void) {
    return [UIScreen mainScreen].bounds.size.height;
}

CGFloat QF_SCREE_WIDTH(void)  {
    return [UIScreen mainScreen].bounds.size.width;
}

CGRect QF_GET_RECT(void) {
    return CGRectMake(0, 0, QF_SCREE_WIDTH(), QF_SCREE_HEIGHT());
}

void QF_CLEAR_TABLE_LIN(UITableView *table) {
    [table setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

UIColor* QF_RGBCOLORT(int r,int g,int b,CGFloat a) {
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a];
}

UIColor* QF_HEXColor(NSString *hexColor) {
    hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}
UIColor* QF_HEXColorA(NSString *hexColor,CGFloat alpha) {
    hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha];
}

void QF_Gradient(UIView *viewT) {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors     = @[(__bridge id)QF_HEXColor(@"f7e0c7").CGColor,(__bridge id)QF_HEXColor(@"dcb392").CGColor];
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(1, 1);
    gradientLayer.frame      = CGRectMake(0, 0, CGRectGetWidth( viewT.frame), CGRectGetHeight(viewT.frame));
    [viewT.layer insertSublayer:gradientLayer atIndex:0];
}

void QF_GradientC(UIView *viewT,NSString *color1,NSString *color2,CGFloat cornerRadius) {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors     = @[(__bridge id)QF_HEXColor(color1).CGColor,(__bridge id)QF_HEXColor(color2).CGColor];
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(1, 1);
    gradientLayer.frame      = CGRectMake(0, 0, CGRectGetWidth( viewT.frame), CGRectGetHeight(viewT.frame));
    gradientLayer.cornerRadius = cornerRadius;

    [viewT.layer insertSublayer:gradientLayer atIndex:0];
}

void QF_GradientCA(UIView *viewT,NSString *color1,CGFloat a1,NSString *color2,CGFloat a2,CGFloat cornerRadius) {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors     = @[(__bridge id)QF_HEXColorA(color1, a1).CGColor,(__bridge id)QF_HEXColorA(color2, a2).CGColor];
    //位置x,y    自己根据需求进行设置   使其从不同位置进行渐变
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint   = CGPointMake(1, 1);
    gradientLayer.frame      = CGRectMake(0, 0, CGRectGetWidth( viewT.frame), CGRectGetHeight(viewT.frame));
    gradientLayer.cornerRadius = cornerRadius;

    [viewT.layer insertSublayer:gradientLayer atIndex:0];
}

//viewT：需要添加渐变的视图。
//color1：渐变起始颜色的十六进制字符串。
//a1：渐变起始颜色的透明度。
//color2：渐变结束颜色的十六进制字符串。
//a2：渐变结束颜色的透明度。
//cornerRadius：视图圆角半径。
//direction：渐变方向，可选值：
//"topToBottom"：从上到下。
//"leftToRight"：从左到右。
//"topLeftToBottomRight"：从左上到右下。
//"topRightToBottomLeft"：从右上到左下。
//默认值为 "leftToRight"。
void QF_GradientCAOffS(UIView *viewT, NSString *color1, CGFloat a1, NSString *color2, CGFloat a2, CGFloat cornerRadius, NSString *direction) {
    // 创建渐变层
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)QF_HEXColorA(color1, a1).CGColor,
                             (__bridge id)QF_HEXColorA(color2, a2).CGColor];

    // 根据方向设置起点和终点
    if ([direction isEqualToString:@"topToBottom"]) {
        gradientLayer.startPoint = CGPointMake(0.5, 0); // 从顶部垂直渐变到底部
        gradientLayer.endPoint = CGPointMake(0.5, 1);
    } else if ([direction isEqualToString:@"leftToRight"]) {
        gradientLayer.startPoint = CGPointMake(0, 0.5); // 从左到右水平渐变
        gradientLayer.endPoint = CGPointMake(1, 0.5);
    } else if ([direction isEqualToString:@"topLeftToBottomRight"]) {
        gradientLayer.startPoint = CGPointMake(0, 0); // 从左上到右下
        gradientLayer.endPoint = CGPointMake(1, 1);
    } else if ([direction isEqualToString:@"topRightToBottomLeft"]) {
        gradientLayer.startPoint = CGPointMake(1, 0); // 从右上到左下
        gradientLayer.endPoint = CGPointMake(0, 1);
    } else {
        // 默认左到右
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
    }

    // 设置渐变层的尺寸和圆角
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(viewT.frame), CGRectGetHeight(viewT.frame));
    gradientLayer.cornerRadius = cornerRadius;

    // 将渐变层插入到视图的图层中
    [viewT.layer insertSublayer:gradientLayer atIndex:0];
}

UIImage * QF_ConvertViewToImage(UIView *v) {
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需  要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

void QF_PRESENT_VC(UIViewController*vc) {
    vc.modalPresentationStyle = 0;
    [QF_topViewController() presentViewController:vc animated:YES completion:nil];
}

void QF_PRESENT_VC_A(UIViewController*vc,BOOL flag) {
    vc.modalPresentationStyle = 0;
    [QF_topViewController() presentViewController:vc animated:flag completion:nil];
}

void QF_DIS_VC(BOOL flag) {
    [QF_topViewController() dismissViewControllerAnimated:flag completion:nil];
}


void QF_PUSH_VC(NSString *vc_Name) {
    UIViewController * vc = [NSClassFromString(vc_Name) new];
    
    vc.hidesBottomBarWhenPushed = YES;

    [QF_topViewController().navigationController pushViewController:vc animated:YES];
}

void QF_PUSH_VCV(UIViewController*vc) {
    vc.hidesBottomBarWhenPushed = YES;
    [QF_topViewController().navigationController pushViewController:vc animated:YES];
}

void QF_POPTO_VC(NSString *vc_Name) {
    UIViewController *vc = QF_topViewController();
    [vc.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:vc_Name]) {
            [vc.navigationController popToViewController:obj animated:YES];
        }
    }];
}

void QF_POP_VC(void) {
    [QF_topViewController().navigationController popViewControllerAnimated:YES];
}

void QF_POP_ROOT_VC(void) {
    [QF_getCurrentVC().navigationController popToRootViewControllerAnimated:YES];
}

// yes 当天  no 不是
BOOL QF_isSameDay(long iTime1,long iTime2) {
    //传入时间毫秒数
    NSDate *pDate1 = [NSDate dateWithTimeIntervalSince1970:iTime1];
    NSDate *pDate2 = [NSDate dateWithTimeIntervalSince1970:iTime2];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:pDate2];
    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}

NSString* QF_GET_CURRENT_DATE(NSString *f) {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd hh:mm:ss",f,f]];
    return [formatter stringFromDate:date];
}

UIFont* QF_BOLD_FONT(CGFloat size) {
    return [UIFont fontWithName:@"Helvetica-Bold" size:size];
}

NSInteger QF_CarryMethod(NSInteger num,CGFloat dividend) {
    float numberToRound;
    int result;
    numberToRound = num/dividend;
    result = (int)ceilf(numberToRound);
    NSLog(@"ceilf(%.2f) = %d", numberToRound, result);
    return result;
}

NSInteger QF_FloorfMethod(float num) {
    int result;
    result = (int)floorf(num);
    NSLog(@"floorf(%.2f) = %d",num, result);
    return result;
}



CGFloat QF_statusBarHAndNavH(void) {
    return [UIApplication sharedApplication].statusBarFrame.size.height + NAVH;
}
CGFloat QF_statusBarHAndNavHAndIphoneXBarH(void) {
    return [UIApplication sharedApplication].statusBarFrame.size.height + NAVH + iphoneXBarH;
}

BOOL QF_iPhoneX() { return [UIApplication sharedApplication].statusBarFrame.size.height == 44; }

#pragma mark -  获取当前屏幕显示的viewcontroller
//UIViewController* QF_getCurrentVC(void) {
//    UIViewController *result = nil;
//    // 获取默认的window
//    UIWindow * window = QF_getCurrentWindow13();
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    // 获取window的rootViewController
//    result = window.rootViewController;
//    
//    while (result.presentedViewController) {
//        result = result.presentedViewController;
//    }
//    if ([result isKindOfClass:[UITabBarController class]]) {
//        result = [(UITabBarController *)result selectedViewController];
//    }
//    if ([result isKindOfClass:[UINavigationController class]]) {
//        result = [(UINavigationController *)result visibleViewController];
//    }
//    return result;
//}

UIViewController* QF_getCurrentVC(void) {
    UIViewController *result = nil;

    // 获取当前的 keyWindow
    UIWindow * window = QF_getCurrentWindow13();
    

    // 如果没找到有效的 Window，遍历所有 Window
    if (!window || window.windowLevel != UIWindowLevelNormal) {
        for (UIWindow *tmpWin in [UIApplication sharedApplication].windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }

    // 获取 rootViewController
    result = window.rootViewController;

    // 获取当前显示的 viewController
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }

    // 如果是 UITabBarController，获取选中的 ViewController
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }

    // 如果是 UINavigationController，获取可见的 ViewController
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }

    return result;
}



#pragma mark -  递归找最上面的viewController (当前所在的控制器)
UIViewController* QF_topViewController(void) {
    return QF_topViewControllerWithRootViewControlle(QF_getCurrentWindow().rootViewController);
    
}

#pragma mark -  找到当前显示的window
UIWindow* QF_getCurrentWindow(void) {
    UIWindow *currentWindow = QF_getCurrentWindow13();
    if (currentWindow.windowLevel != UIWindowLevelNormal) {
        for (UIWindow * tw in UIApplication.sharedApplication.windows) {
            if (tw.windowLevel != UIWindowLevelNormal) {
                currentWindow = tw;
                break;
            }
        }
    }
    return currentWindow;
}

#pragma mark -  递归
UIViewController* QF_topViewControllerWithRootViewControlle(UIViewController * viewController) {
    if (viewController == nil)  return nil;
    if (viewController.presentedViewController != nil) {
        return QF_topViewControllerWithRootViewControlle(viewController.presentedViewController);
    }else if ([viewController isKindOfClass:[UITabBarController class]]) {
        return QF_topViewControllerWithRootViewControlle(((UITabBarController*)viewController).selectedViewController);
    }else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return QF_topViewControllerWithRootViewControlle(((UINavigationController*)viewController).visibleViewController);
    }
    return viewController;
}
 
BOOL QF_Predicate(NSString *regex,NSString *text) {
    if (regex.length == 0 || text.length == 0) return NO;
    NSPredicate *tempRegex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [tempRegex evaluateWithObject:text];
    return isMatch;
}

NSString * QF_TrimBASpace(NSString * str) {
    if (str.length == 0) return @"";
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

NSInteger QF_weekdayStringFromDate(NSDate*inputDate) {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/SuZhou"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return theComponents.weekday;
}

NSInteger QF_specifiedTime(NSString *dateStr) {
    //时间字符串 @"2019-09-08-12-00-00"
    NSString *str = [NSString stringWithFormat:@"%@-12-00-00",dateStr];
    //规定时间格式
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    //设置时区  全球标准时间CUT 必须设置 我们要设置中国的时区
    NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"CUT"];
    [formatter setTimeZone:zone];
    //变回日期格式
    NSDate *stringDate = [formatter dateFromString:str];
    return  QF_weekdayStringFromDate(stringDate);
}

CGSize QF_ComputingContentMAX_HORMAX_W(NSString *content,CGFloat wh,UIFont *font,bool isWH) {
    CGSize  DataSize;
    if (isWH)  DataSize=CGSizeMake(wh, MAXFLOAT);
    else       DataSize=CGSizeMake(MAXFLOAT, wh);
    CGSize textH = [content boundingRectWithSize:DataSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return textH;
}

NSData *QF_jpgDataWithImage(UIImage *image,NSUInteger maxSize) {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxSize) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxSize * 0.9) {
            min = compression;
        } else if (data.length > maxSize) {
            max = compression;
        } else break;
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxSize) return data;
    // Compress by size
    NSUInteger lastDataLength = 0;
    NSData *resultData;
    while (data.length > maxSize && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxSize / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        resultData = data;
    }
    return resultData;
}

id QF_dictionaryWithJsonString( NSString *jsonString) {
    if (jsonString == nil) return nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

void QF_CLEAR_ARow_LIN(UITableViewCell *cell) {
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
}

void QF_ios11Spece(id p) {
    if ([p isKindOfClass:[UIScrollView class]]) {
        if (@available(iOS 11.0,*)) {
            UIScrollView *Scroll = p;
            Scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }else if ([p isKindOfClass:[UITableView class]]) {
        if (@available(iOS 11.0,*)) {
            UITableView *table = p;
            table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
        }
    }
}

id QF_getVCInBoard(NSString * bord,NSString *Id) {
    @try {
        if (!bord) {
            bord = @"Main";
        }
        UIStoryboard *story = [UIStoryboard storyboardWithName:bord bundle:[NSBundle mainBundle]];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:Id];
        
        return vc;
        
    } @catch (NSException *exception) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor whiteColor];
        return vc;
    } @finally {
        
    }
}

#pragma mark - 获取上一个控制器
UIViewController *QF_getOnController() {
    NSArray *vcsArray = QF_topViewController().navigationController.viewControllers;
    NSInteger vcCount = vcsArray.count;
    UIViewController *vc = vcCount ==1?[UIViewController  new]:(UIViewController *)vcsArray[vcCount-2];
    return vc;
}


#pragma mark - 上个控制器是否和指定的控制器相等
BOOL QF_aControllerIsEqualToTheSpecifiedController(NSString * className) {
    return [NSStringFromClass([QF_getOnController() class]) isEqualToString:className];
}


/**
 *  颜色生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
UIImage* QF_GetImageWithColor(UIColor*color,CGFloat height)
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    // 开启位图上下文
    UIGraphicsBeginImageContext(r.size);
    // 开启上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, r);
    // 从上下文中获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 设置导航透明 隐藏导航
void QF_settingNAVTransparentH(void) {
    QF_topViewController().navigationController.navigationBar.translucent = YES;
    [QF_topViewController().navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - 去掉导航栏底部的黑线
void QF_HiddenNAVBottomLine() {
    QF_topViewController().navigationController.navigationBar.shadowImage = [UIImage new];
}

#pragma mark - 显示导航栏底部的黑线
void QF_ShowNAVBottomLine(void) {
    [QF_topViewController().navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [QF_topViewController().navigationController.navigationBar setShadowImage:nil];
}

/**
 UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200, 70)];
     myLabel.text = @"Hi,小韩哥!";
     myLabel.font = [UIFont systemFontOfSize:20.0];
     myLabel.textAlignment = NSTextAlignmentCenter;
     [self.view addSubview:myLabel];
     
     CGFloat radius = 21.0f;
     
     UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:myLabel.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
     CAShapeLayer * mask  = [[CAShapeLayer alloc] init];
     mask.lineWidth = 5;
     mask.lineCap = kCALineCapSquare;
     
     // 带边框则两个颜色不要设置成一样即可
     mask.strokeColor = [UIColor redColor].CGColor;
     mask.fillColor = [UIColor yellowColor].CGColor;
     
     mask.path = path.CGPath;
     [myLabel.layer addSublayer:mask];
 
 */
#pragma mark - 设置任意的圆角
void QF_customCornerAny(UIView *view, CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius) {
    CGSize viewSize = view.bounds.size;
    
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 设置圆角路径
    // 左上角
    [path moveToPoint:CGPointMake(0, topLeftRadius)];
    [path addArcWithCenter:CGPointMake(topLeftRadius, topLeftRadius)
                    radius:topLeftRadius
                startAngle:M_PI
                  endAngle:3 * M_PI_2
                 clockwise:YES];
    
    // 右上角
    [path addLineToPoint:CGPointMake(viewSize.width - topRightRadius, 0)];
    [path addArcWithCenter:CGPointMake(viewSize.width - topRightRadius, topRightRadius)
                    radius:topRightRadius
                startAngle:3 * M_PI_2
                  endAngle:0
                 clockwise:YES];
    
    // 右下角
    [path addLineToPoint:CGPointMake(viewSize.width, viewSize.height - bottomRightRadius)];
    [path addArcWithCenter:CGPointMake(viewSize.width - bottomRightRadius, viewSize.height - bottomRightRadius)
                    radius:bottomRightRadius
                startAngle:0
                  endAngle:M_PI_2
                 clockwise:YES];
    
    // 左下角
    [path addLineToPoint:CGPointMake(bottomLeftRadius, viewSize.height)];
    [path addArcWithCenter:CGPointMake(bottomLeftRadius, viewSize.height - bottomLeftRadius)
                    radius:bottomLeftRadius
                startAngle:M_PI_2
                  endAngle:M_PI
                 clockwise:YES];
    
    [path closePath]; // 闭合路径
    
    // 创建形状图层
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = path.CGPath;
    
    // 开启抗锯齿
    maskLayer.rasterizationScale = [UIScreen mainScreen].scale;
    maskLayer.shouldRasterize = YES;
    
    // 应用遮罩
    view.layer.mask = maskLayer;
}
 


#pragma mark - 设置某个角的圆角
void QF_customCornerRad(UIView *view,CGSize size,UIRectCorner corners) {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:size];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

void QF_customCornerRadNew(UIView *view,CGSize size,UIRectCorner corners,CGFloat lineWidth,CAShapeLayerLineCap lineCap,UIColor *lineC,UIColor *bC) {
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer * mask  = [[CAShapeLayer alloc] init];
    mask.lineWidth = lineWidth;
    mask.lineCap = lineCap?:kCALineCapSquare;
    
    // 带边框则两个颜色不要设置成一样即可
    mask.strokeColor = lineC.CGColor;
    mask.fillColor = bC.CGColor;
    
    mask.path = path.CGPath;
    [view.layer addSublayer:mask];
}

#pragma mark - 开启左滑必须在viewDidLoad设置代理
void QF_POPDelegate() {
    QF_topViewController().navigationController.interactivePopGestureRecognizer.delegate=(id)QF_topViewController();
}

#pragma mark - 开启左滑
void QF_POPEnabledYES() {
    QF_topViewController().navigationController.interactivePopGestureRecognizer.enabled=YES;
}

#pragma mark - 关闭左滑
void QF_POPEnabledNO() {
    QF_topViewController().navigationController.interactivePopGestureRecognizer.enabled=NO;
}

#pragma mark - 传入View截屏
UIImage* QF_ScreenShotsWithView(UIView *view) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage*image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 添加模糊效果
void QF_APPBlur(UIWindow *window) {
    UIView* view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView*imageV = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController*vc = QF_topViewController() ;
    UIView *viewC = vc.viewIfLoaded;
    imageV.image = QF_ScreenShotsWithView(viewC);
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    effectView.frame = [UIScreen mainScreen].bounds;
    effectView.alpha=1.f;
    [imageV addSubview:effectView];
    view.tag = 999;
    [view addSubview:imageV];
    [window addSubview:view];
}

#pragma mark - 删除window视图
void QF_REMAPPBlur() {
    [[[UIApplication sharedApplication].keyWindow viewWithTag:999] removeFromSuperview];
}

#pragma mark  收回键盘
void QF_ViewEndEditing() {
    [QF_topViewController().view endEditing:YES];
}



void QF_AlertController(NSString *title,NSString *message,NSString *CancelTitle,NSString *DefaultTitle,void(^CancelBlock)(void),void(^DefaultBlock)(void)) {
    
    UIAlertController *alerC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (CancelTitle != nil) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:CancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (CancelBlock) {
                CancelBlock();
            }
        }];
        
        [alerC addAction:cancel];
    }
    
    if (DefaultTitle != nil) {
        UIAlertAction *defaut = [UIAlertAction actionWithTitle:DefaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (DefaultBlock) {
                DefaultBlock();
            }
        }];
        
        [alerC addAction:defaut];
    }
    
    [QF_topViewController() presentViewController:alerC animated:YES completion:nil];
}

void QF_convertMP3ToPCMWithAVFoundation(NSString *mp3FilePath,NSString *pcmFileS,void(^callback)(BOOL success, NSString *outputPath)) {
    NSString *pcmFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:pcmFileS];

    // 确保输入 MP3 文件存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:mp3FilePath]) {
        NSLog(@"MP3 文件不存在: %@", mp3FilePath);
        callback(NO, nil);
        return;
    }

    // 删除旧的 PCM 文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:pcmFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:pcmFilePath error:nil];
    }

    // 创建 AVAsset
    NSURL *mp3URL = [NSURL fileURLWithPath:mp3FilePath];
    AVAsset *asset = [AVAsset assetWithURL:mp3URL];

    // 创建 AVAssetReader
    NSError *error = nil;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    if (error) {
        NSLog(@"AVAssetReader 初始化失败: %@", error.localizedDescription);
        callback(NO, nil);
        return;
    }

    // 获取音频轨道
    AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    if (!audioTrack) {
        NSLog(@"无法找到音频轨道");
        callback(NO, nil);
        return;
    }

 
    // 设置输出配置（PCM 格式，采样率 16000 Hz，单声道，16 位小端序）
    NSDictionary *outputSettings = @{
        AVFormatIDKey: @(kAudioFormatLinearPCM), // 指定输出为 PCM 格式
        AVSampleRateKey: @(16000),              // 采样率：16 kHz
        AVNumberOfChannelsKey: @(1),            // 声道数：单声道
        AVLinearPCMBitDepthKey: @(16),          // 位深：16 位
        AVLinearPCMIsNonInterleaved: @NO,       // 是否非交错：否（单声道不影响）
        AVLinearPCMIsFloatKey: @NO,             // 是否浮点数据：否
        AVLinearPCMIsBigEndianKey: @NO          // 是否大端序：否（小端序）
    };

    AVAssetReaderTrackOutput *trackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:outputSettings];
    [reader addOutput:trackOutput];

    // 开始读取
    if (![reader startReading]) {
        NSLog(@"无法开始读取 AVAsset");
        callback(NO, nil);
        return;
    }

    // 打开 PCM 文件
    FILE *pcmFile = fopen([pcmFilePath UTF8String], "wb");
    if (!pcmFile) {
        NSLog(@"无法创建 PCM 文件");
        callback(NO, nil);
        return;
    }

    // 读取并写入 PCM 数据
    while (reader.status == AVAssetReaderStatusReading) {
        CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];
        if (sampleBuffer) {
            AudioBufferList audioBufferList;
            CMBlockBufferRef blockBuffer;

            // 提取音频数据
            CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
                sampleBuffer,
                NULL,
                &audioBufferList,
                sizeof(audioBufferList),
                NULL,
                NULL,
                kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,
                &blockBuffer
            );

            // 写入 PCM 数据到文件
            for (int i = 0; i < audioBufferList.mNumberBuffers; i++) {
                AudioBuffer audioBuffer = audioBufferList.mBuffers[i];
                fwrite(audioBuffer.mData, 1, audioBuffer.mDataByteSize, pcmFile);
            }

            // 释放资源
            CFRelease(blockBuffer);
            CFRelease(sampleBuffer);
        }
    }

    fclose(pcmFile);

    // 检查读取状态
    if (reader.status == AVAssetReaderStatusCompleted) {
        NSLog(@"MP3 转换为 PCM 成功");
        callback(YES, pcmFilePath);
    } else {
        NSLog(@"MP3 转换为 PCM 失败，读取中断");
        callback(NO, nil);
    }
    
}

/**MARK: 数组转json*/
NSString * QF_ArrayORDicConversionJsonString(id data) {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonString;
}

/**MARK: 字典转json*/
NSString * QF_DicORDicConversionJsonString(NSDictionary * dictionary) {
    if (![NSJSONSerialization isValidJSONObject:dictionary]) {
        NSLog(@"无法将对象转换为 JSON：对象无效");
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"字典转 JSON 失败：%@", error.localizedDescription);
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

 


/**MARK: 抖动View*/
void QF_ShakeView(UIView* viewToShake) {
    CGFloat t =4.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

/**MARK: 有导航栏的时候，坐标从(0,64)变成从(0,0)开始*/
void QF_edgesForExtendedLayout() {
    QF_topViewController().edgesForExtendedLayout=UIRectEdgeBottom;
}



/*!
 *时间戳转时间(使用当地时区)
 */
NSString * TimestampToTimeWtihString(NSString *timestamp,NSString *format)
{
    if (timestamp.length == 13) {
        timestamp = [NSString stringWithFormat:@"%ld",timestamp.integerValue/1000];
    }
    if (format.length == 0) {
        format = @"MM/dd HH:mm";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

/*!
 *时间转时间戳
 */
NSString* QF_getTimestampWithDateF(NSString *str,NSString *dataF) {
  
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dataF.length==0?@"yyyy-MM-dd HH:mm:ss":dataF];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate *datenow = [formatter dateFromString:str];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
        NSLog(@"%@",TimestampToTimeWtihString(timeSp,nil));
        return TimestampToTimeWtihString(timeSp,nil);
   
}

/*!
 *时间转时间戳
 */
NSString* QF_getTimestampWithDate(NSString *str) {
  
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [formatter setTimeZone:timeZone];
        NSDate *datenow = [formatter dateFromString:str];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
        NSLog(@"%@",TimestampToTimeWtihString(timeSp,nil));
        return TimestampToTimeWtihString(timeSp,nil);
   
}

//MARK: 将时间戳转换为时间字符串 传入秒
NSString * QF_timestampToTimeStr(long long timestamp , NSString *formatStr) {
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *timeStr = [QF_dateFormatWith(formatStr?:@"YYYY-MM-dd HH:mm:ss") stringFromDate:date];
    return timeStr;
}

//MARK: 获取日期格式化器
NSDateFormatter *QF_dateFormatWith(NSString *formatStr) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return formatter;
}

//MARK: 获取系统biuld
CGFloat QF_getSystemBundle() {
    return [[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"] floatValue];
}

//MARK: 获取版本号
NSString *QF_getAppVersion(bool isType) {
    if (isType) {
        //此获取的版本号对应version，打印出来对应为1.2.3.4.5这样的字符串
        return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];;
    }
    //此获取的版本号对应bundle，打印出来对应为12345这样的数字
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
}

//MARK: 获取系统版本号
CGFloat QF_getSystemVersion() {
    return [UIDevice currentDevice].systemVersion.floatValue;
}

//MARK: 处理字符串为nil
NSString * QF_StringNil(NSString *str) {
    if(str==nil) return  @"";
    else if ([str isEqual:[NSNull null]]) return  @"";
    return str;
}

//MARK: 改变lable行间距
void QF_ChangeLineSpaceForLabel(UILabel *label,float space) {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle     = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

//MARK: 改变lable字间距
void QF_ChangeWordSpaceForLabel(UILabel *label,float space) {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

//MARK: 改变lable行间距和字间距
void QF_ChangeWordSpaceAndChangeLineSpaceForLabel(UILabel *label,float lineSpace,float wordSpace) {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

//MARK: 打电话
void QF_Telprompt(NSString *telStr) {
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    telStr =[telStr stringByTrimmingCharactersInSet:nonDigits];
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",telStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//MARK: 获取视频第一帧
void QF_FirstFrameWithVideo(NSURL *url,CGSize size,UIImageView *imageT) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        generator.appliesPreferredTrackTransform = YES;
        generator.maximumSize = CGSizeMake(size.width, size.height);
        NSError *error = nil;
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageT.image = [UIImage imageWithCGImage:img];
                CGImageRelease(img);
            });
        }
    });
}

//MARK: 获取view上面的约束
NSLayoutConstraint * QF_GetConstraint(NSArray<__kindof NSLayoutConstraint *> *constraints,NSString *identifier) {
    __block NSLayoutConstraint * tempConstraint;
    [constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:identifier]) {
            tempConstraint = obj;
            *stop = YES;
            return;
        }
    }];
    return tempConstraint;
}


void QF_ViewShadow(UIView *view,UIColor *shadowColor,float shadowOpacity) {
    view.layer.shadowColor   = shadowColor!=nil?shadowColor.CGColor:[UIColor grayColor].CGColor;
    view.layer.shadowOffset  = CGSizeMake(0, 0);
    view.layer.shadowOpacity = (shadowOpacity!=0)?shadowOpacity:0.3;
}

void QF_L(id obj) {
    NSLog(@"%@",obj);
}

NSMutableAttributedString* QF_StringAddUnderlineStyleSingle(NSString * obj) {
    return  [[NSMutableAttributedString alloc] initWithString:obj attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle),
    }];
}

NSMutableAttributedString* QF_dealPrince(NSString * obj) {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:11],
        NSKernAttributeName:@-2,
        NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0 green:107/255.0 blue:26/255.0 alpha:1.0]}
                                         ];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:obj attributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
        NSKernAttributeName:@-1,
        NSForegroundColorAttributeName: [UIColor colorWithRed:242/255.0 green:107/255.0 blue:26/255.0 alpha:1.0]}];
    
    [string appendAttributedString:string2];
    
    return string;
}

NSMutableAttributedString* QF_dealPrinceK(NSString * obj,CGFloat arg1,CGFloat arg2,BOOL isBold,UIColor *color,CGFloat kern1,CGFloat kern2) {
    UIFont *tem1;
    UIFont *tem2;
    
    if (isBold) {
        tem1 = [UIFont boldSystemFontOfSize:arg1];
        tem2 = [UIFont boldSystemFontOfSize:arg2];
    }else {
        tem1 = [UIFont systemFontOfSize:arg1];
        tem2 = [UIFont systemFontOfSize:arg2];
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{
        NSFontAttributeName: tem1,
        NSKernAttributeName:kern1==0?@-2:@(kern1),
        NSForegroundColorAttributeName: color
        
    }];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:obj attributes:@{
        NSFontAttributeName: tem2,
        NSKernAttributeName:kern2==0?@-1:@(kern2),
        NSForegroundColorAttributeName: color
        
    }];
    
    [string appendAttributedString:string2];
    
    return string;
}


NSString *QF_phoneEncryption(NSString *phoneString) {
    
    if (phoneString.length == 11) {
        NSString *result ;
        NSString * toIndex = [phoneString substringToIndex:3];
        NSString * midStr = @"****";
        NSString * fromIndex = [phoneString substringFromIndex:7];
        result = [NSString stringWithFormat:@"%@%@%@",toIndex,midStr,fromIndex];
        phoneString = [NSString stringWithFormat:@"%@%@%@",toIndex,midStr,fromIndex];
        return phoneString;
    }
    return phoneString;
}
NSString *QF_base64StringFromData(NSData *data,long length) {
    
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

NSMutableAttributedString *QF_lableInserImage(NSString *imageName,NSString *content,CGRect rect) {
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:content];
    
    /** 添加图片到指定的位置*/
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    
    // 表情图片
    attchImage.image = [UIImage imageNamed:imageName];
    
    // 设置图片大小
    attchImage.bounds = rect;
    
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    
    [attriStr insertAttributedString:stringImage atIndex:0];
    
    return attriStr;
}

void QF_settingTabBarItemBadgeValueWitItemIndexAndBadgeValue(NSInteger index,NSString *badgeValue) {
    NSArray *tabBarItems = QF_getCurrentVC().navigationController.tabBarController.tabBar.items;
    
    UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:index];
    
    personCenterTabBarItem.badgeValue = [badgeValue isEqualToString:@"0"]?nil:badgeValue;
}

CGPoint QF_GetTheRelativePositionOfAControlOnTheScreen(UIView *view,UIView *superView) {
    CGPoint viewC = CGPointMake(view.bounds.origin.x + view.bounds.size.width/2,view.bounds.origin.y + view.bounds.size.height/2);
    return [view convertPoint:viewC toView:superView];
}

#pragma mark - 获取UITableView 上的 UITableViewCell 的 NSIndexPath
NSIndexPath* QF_getTableViewUpTableViewCellTheIndexPath(UITableViewCell *tableViewCell) {
    UITableView *tableView = (UITableView *)[tableViewCell superview];
    
    NSIndexPath * path = [tableView indexPathForCell:tableViewCell];
    
    return path;
}


#pragma mark - 获取当前时间戳 yes 秒 No 毫秒
NSString* QF_getNowTimeStamp(BOOL isM) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    if (isM) {
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    }else {
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    }
    
    //设置时区,这一点对时间的处理很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *dateNow = [NSDate date];
    NSString *timeStamp;
    if (isM) {
        timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    }else {
        timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]*1000];
    }
    
    return timeStamp;
}

#pragma mark - 通过Model 获取是否是NO  iPhone X系列  YES 非iPhone X系列
BOOL QF_isIPhoneX(void) {
    static BOOL isiPhoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
#if TARGET_IPHONE_SIMULATOR
        // 获取模拟器所对应的 device model
        NSString *model = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else
        // 获取真机设备的 device model
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
#endif
        // 判断 device model 以下 开头 都是非 iPhone X 系列的
        isiPhoneX = [model isEqualToString:@"iPhone4,1"] || [model isEqualToString:@"iPhone5,1"] || [model hasPrefix:@"iPhone5,2"] || [model hasPrefix:@"iPhone5,3"] || [model hasPrefix:@"iPhone5,4"] || [model hasPrefix:@"iPhone6,1"] || [model hasPrefix:@"iPhone6,2"] || [model hasPrefix:@"iPhone7,2"] || [model hasPrefix:@"iPhone7,1"] || [model hasPrefix:@"iPhone8,1"] || [model hasPrefix:@"iPhone8,2"] || [model hasPrefix:@"iPhone8,4"] || [model hasPrefix:@"iPhone9,1"] || [model hasPrefix:@"iPhone9,3"] || [model hasPrefix:@"iPhone9,2"] || [model hasPrefix:@"iPhone9,4"] || [model hasPrefix:@"iPhone10,1"] || [model hasPrefix:@"iPhone10,4"] || [model hasPrefix:@"iPhone10,2"] || [model hasPrefix:@"iPhone10,5"];
    });
    
    return isiPhoneX;
}
 

void QF_AttributedStringToLabel(UILabel *label,NSString *text) {
   

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC" size: 22],NSForegroundColorAttributeName: [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1.0]}];

    label.attributedText = string;
    label.textAlignment = NSTextAlignmentLeft;
    label.alpha = 1.0;
    
}

#pragma mark - 复制文字
/// 复制文字
/// @param text 文字
void QF_Copy(NSString *text) {
    if (text.length != 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
    }
   
}

#pragma mark - 去除两边空格
NSString *QF_trimS(NSString *str){
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//空格和换行
//    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//只能去除空格
}

/** MARK: 将指定View 转换成 图片 save 到本地*/
void QF_SaveThePictureLocally(UIView * aview,void(^saveBlock)(void)){
    UIGraphicsBeginImageContextWithOptions(aview.frame.size, NO, 0.0);
    [aview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //保存到相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:viewImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //保存之后需要做的事情
        dispatch_async(dispatch_get_main_queue(), ^{
            if (saveBlock){
                saveBlock();
            }
        });
    }];
}



void QF_PHAssetGetURL(PHAsset *asset,void(^SuessBlock)(NSURL *url)) {
    PHAsset *phAsset = asset;
    if (phAsset.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            NSURL *url = urlAsset.URL;
            if (SuessBlock) {
                SuessBlock(url);
            }
        }];
    }
}
void QF_MOVCMP4(NSURL *URL,void(^SuessBlock)(NSData *data)) {
 
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:URL options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];

        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        NSLog(@"resultPath = %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
            
            switch (exportSession.status) {
                    
                case AVAssetExportSessionStatusUnknown:
                    
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                    
                    break;
                    
                case AVAssetExportSessionStatusWaiting:
                    
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                    
                    break;
                    
                case AVAssetExportSessionStatusExporting:
                    
                    NSLog(@"AVAssetExportSessionStatusExporting");
                    
                    break;
                    
                case AVAssetExportSessionStatusCompleted:
                    
                {
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    NSData *data = [NSData dataWithContentsOfFile:resultPath];
                    [[NSFileManager defaultManager]removeItemAtPath:resultPath error:nil];

                    if (SuessBlock) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            SuessBlock(data);
                        });
                    }
                   
                }
                    break;
                    
                case AVAssetExportSessionStatusFailed:
                    
                    NSLog(@"AVAssetExportSessionStatusFailed");
                    
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    
                    break;
            }
            
        }];
        
    }
    

}

//链接转字典  （参数）
NSDictionary * QF_dictionaryWithUrlString(NSString *urlStr)
{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

// 修改TextField PL颜色
void QF_ChangeTP(UITextField * T,UIColor *color, UIFont *font) {
    NSString *placeHolderStr = T.placeholder;
    if (T.placeholder == nil) {
        return;
    }
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:T.placeholder];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:color
                            range:NSMakeRange(0, placeHolderStr.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:font
                            range:NSMakeRange(0, placeHolderStr.length)];
    T.attributedPlaceholder = placeholder;
}


void QF_NOTI_ADD(id s,SEL sel, id name)
{
 [[NSNotificationCenter defaultCenter]addObserver:s selector:sel name:name object:nil];
}

void QF_NOTI_POST(id name)
{
    [[NSNotificationCenter defaultCenter]postNotificationName:name object:nil];
}

void QF_NOTI_POST_N(id name,id object)
{
    [[NSNotificationCenter defaultCenter]postNotificationName:name object:object];
}

id QF_BNIB(NSString *nibStr,int index) {
    return [[NSBundle mainBundle]loadNibNamed:nibStr owner:nil options:nil][index];
}

void QF_RGTableViewCELL(UITableView *tableView,NSString *nibS,NSString *Identifier) {
    [tableView registerNib:[UINib nibWithNibName:nibS bundle:nil] forCellReuseIdentifier:Identifier];
}


//MARK:Base64转图片
UIImage *QF_Base64ConversionImage(NSString *base64Str) {
    if (base64Str.length == 0) {
        NSLog(@"字符串为空");
        return nil;
    }
    NSData * showData = [[NSData alloc]initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:showData];
}

/**
 * 设置UILable 的字体和颜色
 @ label            :要设置的控件
 @ str                :要设置的字符串
 @ textArray      :有几个文字需要设置
 @ colorArray     :有几个颜色
 @ fontArray      :有几个字体
 */
void QF_LAS(UILabel*label,NSString * string,NSArray *textArray,NSArray*colorArray,NSArray *fontArray){
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    for (int i = 0 ; i < [textArray count]; i++ )
    {
        NSRange range1 = [[str string] rangeOfString:textArray[i]];
        [str addAttribute:NSForegroundColorAttributeName value:colorArray[i] range:range1];
        [str addAttribute:NSFontAttributeName value:fontArray[i] range:range1];
    }
   label.attributedText = str;
}

/**
 * 设置UILable 的字体和颜色
 @ theLab            :要设置的控件
 @ change                :要设置的字符串
 @ allColor      :有几个文字需要设置
 @ markColor     :有几个颜色
 @ fontSize      :有几个字体
 */
void QF_LAS2(UILabel*theLab,NSString * change,UIColor *allColor,UIColor*markColor,UIFont *font,int baselineOffset) {
    NSString *tempStr = theLab.text;
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [strAtt addAttribute:NSForegroundColorAttributeName value:allColor range:NSMakeRange(0, [strAtt length])];
    NSRange markRange = [tempStr rangeOfString:change];
    [strAtt addAttribute:NSForegroundColorAttributeName value:markColor range:markRange];
    [strAtt addAttribute:NSFontAttributeName value:font==nil?[UIFont fontWithName:@"HelveticaNeue" size:16]:font range:markRange];
    [strAtt addAttribute:NSBaselineOffsetAttributeName value:@(baselineOffset) range:markRange];

   
    
    theLab.attributedText = strAtt;
}
 
/**
 * 正则密码必须是6-16字母数字
 @ password            :密码
 @ return            :yes 输入正确 NO输入错误

 */
BOOL QF_CheckPassword(NSString *password) {
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}
 
/**
 * 遍历所有手势 关闭 或者 打开   关闭vc左滑
 @ UIViewController :vc
 @ enable            :NO 关闭 YES开启

 */
void QF_popGestureChange(UIViewController *vc, BOOL enable) {
    if ([vc.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //遍历所有的手势
        for (UIGestureRecognizer *popGesture in vc.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = enable;
        }
    }
}


/// 判断空 null
/// @param aValue string
BOOL QF_setNoNull(id aValue) {
    if (aValue == nil) {
        return YES;
    } else if ((NSNull *)aValue == [NSNull null]) {
        if ([aValue isEqual:nil]) {
            aValue = @"";
        }
        return YES;
    }
    return NO;
}


/// view转圈圈
/// @param view view
void QF_ViewZQQS(UIView *view) {
    [view.layer removeAllAnimations];
      CABasicAnimation *rotationAnimation;
      rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
      rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
      rotationAnimation.duration = 2;
      rotationAnimation.repeatCount = HUGE_VALF;
     [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/// 结束转圈圈
/// @param view view
void QF_ViewZQQEnd(UIView *view) {
    [view.layer removeAllAnimations];
}


NSString *currentIPAddressOf( NSString *device) {
    struct ifaddrs *addrs;
    NSString *ipAddress = nil;
    
    if(getifaddrs(&addrs) != 0) {
        return nil;
    }//end if
    
    //get ipv4 address
    for(struct ifaddrs *addr = addrs ; addr ; addr = addr->ifa_next) {
        if(!strcmp(addr->ifa_name, [device UTF8String])) {
            if(addr->ifa_addr) {
                struct sockaddr_in *in_addr = (struct sockaddr_in *)addr->ifa_addr;
                if(in_addr->sin_family == AF_INET) {
                    ipAddress = IPv4Ntop(in_addr->sin_addr.s_addr);
                    break;
                }//end if
            }//end if
        }//end if
    }//end for
    
    freeifaddrs(addrs);
    return ipAddress;
}//end currentIPAddressOf:

 NSString *IPv4Ntop(in_addr_t addr) {
    char buffer[INET_ADDRSTRLEN] = {0};
    return inet_ntop(AF_INET, &addr, buffer, sizeof(buffer)) ?
    [NSString stringWithUTF8String:buffer] : nil;
}//end IPv4Ntop:

in_addr_t IPv4Pton( NSString *IPAddr) {
    in_addr_t network = INADDR_NONE;
    return inet_pton(AF_INET, [IPAddr UTF8String], &network) == 1 ?
    network : INADDR_NONE;
}//end IPv4Pton:
#pragma mark  获取设备物理地址 E

#pragma mark - 获取设备当前网络IP地址 s
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddr];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        address = addresses[key];
        //筛选出IP地址格式
        if([self isValidatIP:address]) *stop = YES;
    }];
    return address ? address : @"0.0.0.0";
}

- (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        return firstMatch;
    }
    return NO;
}

- (NSDictionary *)getIPAddr
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
#pragma mark  获取设备当前网络IP地址 E
 
#pragma mark - 得到当前时间相对1970时间的字符串，精度到秒，返回10位长度字符串
NSString * QF_getCurrentTimeBySecond(){
    double currentTime =  [[NSDate date] timeIntervalSince1970];
    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];
    return strTime;
}

#pragma mark - 得到当前时间相对1970时间的字符串，精度到毫秒，返回13位长度字符串
NSString * QF_getCurrentTimeStringToMilliSecond() {
    double currentTime =  [[NSDate date] timeIntervalSince1970]*1000;
    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];
    return strTime;
}
 
#pragma mark - 获取当前日期前一个月日期
NSDate * QF_getPriousorLaterDateFromDate(NSDate *date,int month){
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate*mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

NSString * QF_GetPreviousMonth(NSString *Format) {
    NSDate*currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:Format?:@"YYYY/MM/dd"];
    NSString*currentDateString = [dateFormatter stringFromDate:currentDate];
     //获取前一个月的时间
    NSDate*monthagoData =QF_getPriousorLaterDateFromDate(currentDate, -1) ;
    NSString*agoString = [dateFormatter stringFromDate:monthagoData];
    return agoString;
}
#pragma mark - 当前的年月日等时间信息
NSDateComponents * QF_GetComponents(void) {
    // 获取代表公历的NSCalendar对象
      NSCalendar *gregorian = [[NSCalendar alloc]
       initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
      // 获取当前日期
      NSDate* dt = [NSDate date];
      // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
      unsigned unitFlags = NSCalendarUnitYear |
       NSCalendarUnitMonth |  NSCalendarUnitDay |
       NSCalendarUnitHour |  NSCalendarUnitMinute |
       NSCalendarUnitSecond | NSCalendarUnitWeekday;
      // 获取不同时间字段的信息
      NSDateComponents* comp = [gregorian components: unitFlags
       fromDate:dt];
      // 获取各时间字段的数值
      NSLog(@"现在是%ld年" , comp.year);
      NSLog(@"现在是%ld月 " , comp.month);
      NSLog(@"现在是%ld日" , comp.day);
      NSLog(@"现在是%ld时" , comp.hour);
      NSLog(@"现在是%ld分" , comp.minute);
      NSLog(@"现在是%ld秒" , comp.second);
      NSLog(@"现在是星期%ld" , comp.weekday);
    return comp;
}

void QF_Layer(UIView *l,CGFloat cornerRadius,CGFloat borderWidth,UIColor *borderColor) {
    
    if (l == nil) return;
     
    if (cornerRadius != 0) {l.layer.cornerRadius = cornerRadius; l.layer.masksToBounds = YES;}
    
    if (borderWidth !=0 ) l.layer.borderWidth = borderWidth;
    
    if (borderWidth !=0 ) l.layer.borderColor = borderColor.CGColor;

}

// 列出所有字体的名称
void QF_AllFamilyNames(void) {
    
    for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"Available font: %@", fontName);
        }
    }

}

 
/// 设置 UILabel 的文字样式，并返回计算的高度
/// @param text 文本内容
/// @param font 字体
/// @param textColor 文字颜色
/// @param lineSpacing 行间距
/// @param wordSpacing 字间距
/// @param maxWidth 最大宽度
/// @return 根据设置完成的 UILabel 高度
CGFloat QF_setLabelAT(UILabel *label,NSString *text,UIFont *font,UIColor *textColor,CGFloat lineSpacing,CGFloat wordSpacing,CGFloat maxWidth) {
    
    if (text.length == 0) {
        text = @"";
    }
    
    // 设置基本属性
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 0; // 支持多行显示

    // 创建 NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];

    // 设置段落样式（行间距）
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 行间距
    paragraphStyle.alignment = label.textAlignment; // 保持对齐方式一致

    // 添加段落样式和字间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0, text.length)];

    // 赋值给 UILabel
    label.attributedText = attributedString;

    // 动态计算 UILabel 的高度
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    CGRect textRect = [attributedString boundingRectWithSize:maxSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     context:nil];
    return ceil(textRect.size.height); // 返回计算的高度，向上取整
    
    
    
}

/// 设置 UILabel 的文字样式，并返回计算的高度
/// @param text 文本内容
/// @param font 字体
/// @param textColor 文字颜色
/// @param lineSpacing 行间距
/// @param wordSpacing 字间距
/// @param numL 几行
void QF_setLabelATN(UILabel *label,NSString *text,UIFont *font,UIColor *textColor,CGFloat lineSpacing,CGFloat wordSpacing,NSInteger numL) {
    
    if (text.length == 0) {
        text = @"";
    }
    
    // 设置基本属性
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = numL; // 支持多行显示

    // 创建 NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];

    // 设置段落样式（行间距）
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 行间距
    paragraphStyle.alignment = label.textAlignment; // 保持对齐方式一致

    // 添加段落样式和字间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0, text.length)];

    // 赋值给 UILabel
    label.attributedText = attributedString;
 
    label.lineBreakMode = NSLineBreakByTruncatingTail; // 设置超出部分显示省略号

}

/// 设置 UILabel 的文字样式，并返回计算的高度
/// @param text 文本内容
/// @param font 字体
/// @param textColor 文字颜色
/// @param lineSpacing 行间距
/// @param wordSpacing 字间距
/// @param maxWidth 最大宽度
/// @return 根据设置完成的 UILabel 高度
CGFloat QF_setLabelATT(UILabel *label,NSAttributedString *text,UIFont *font,UIColor *textColor,CGFloat lineSpacing,CGFloat wordSpacing,CGFloat maxWidth) {
    
    if (text.length == 0) {
        return 0;
    }
    
    // 设置基本属性
    label.attributedText = text;
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 0; // 支持多行显示

    // 创建 NSMutableAttributedString
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text];

    // 设置段落样式（行间距）
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 行间距
    paragraphStyle.alignment = label.textAlignment; // 保持对齐方式一致

    // 添加段落样式和字间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0, text.length)];

    // 赋值给 UILabel
    label.attributedText = attributedString;

    // 动态计算 UILabel 的高度
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    CGRect textRect = [attributedString boundingRectWithSize:maxSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     context:nil];
    return ceil(textRect.size.height); // 返回计算的高度，向上取整
    
    
    
}
    
NSString * QF_convertTimestampToDate(NSTimeInterval timestamp,NSString *format) {
    // 1. 将时间戳转换为 NSDate 对象
       NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
       
       // 2. 创建日期格式化对象
       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       [dateFormatter setDateFormat:format];
       
       // 3. 设置时区（可选）
       [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
       
       // 4. 将 NSDate 转换为格式化日期字符串
       NSString *dateString = [dateFormatter stringFromDate:date];
       return dateString;
}

NSString * QF_convertSecondsToTimeFormat(NSInteger seconds) {
    // 计算小时、分钟、秒
    NSInteger hours = seconds / 3600; // 每小时有 3600 秒
    NSInteger minutes = (seconds % 3600) / 60; // 剩余秒数转为分钟
    NSInteger secs = seconds % 60; // 剩余秒数

    // 格式化为 00:00:00 格式
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)secs];
}

NSString * QF_LocalozedS(NSString *str) {
    return NSLocalizedString(str, @"");
}


bool QF_checkSystemLanguage(void){
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    
    if ([language hasPrefix:@"zh"]) {
        return  YES;
    } else if ([language hasPrefix:@"en"]) {
        return NO;
    } else {
        return NO;
    }
}

bool QF_checkSystemLanguageISZHEN(void){
    NSString *language = [[NSLocale preferredLanguages] firstObject];
    
    if ([language hasPrefix:@"zh"]) {
        return  YES;
    } else if ([language hasPrefix:@"en"]) {
        return YES;
    } else {
        return NO;
    }
}


UIWindow * QF_getCurrentWindow13(void){
    UIWindow *window = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            window = scene.windows.firstObject;
            break;
        }
    }
    return window;
}

 
void QFLongPressGesture(id s,SEL sel,id v)
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:s action:sel];
    [v addGestureRecognizer:longPressGesture];
}


CGPoint QF_gesTRCFrameWithgestureRecognizer(UILongPressGestureRecognizer *gestureRecognizer,CGFloat viewW,CGFloat viewH) {
    UINotificationFeedbackGenerator *feedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
    [feedbackGenerator prepare];
    [feedbackGenerator notificationOccurred:UINotificationFeedbackTypeSuccess];
    
    CGPoint locationInView = [gestureRecognizer locationInView:QF_getCurrentWindow13()];

    
    // 获取屏幕的宽高
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    // 计算弹出视图的初步位置
    CGFloat xPos = locationInView.x - viewW / 2;
    CGFloat yPos = locationInView.y + 15;  // 默认显示在点击位置下方
    
    // 确保弹出视图不会超出屏幕边缘
    CGFloat topEdge = 0;
    CGFloat bottomEdge = screenHeight - viewH;
    if (yPos < topEdge) {
        yPos = topEdge;
    } else if (yPos > bottomEdge) {
        yPos = bottomEdge;
    }

    if (xPos < 0) {
        xPos = 10;
    } else if (xPos + viewW > screenWidth) {
        xPos = screenWidth - viewW-10;
    }
    
    
    return CGPointMake(xPos, yPos);
}

@end

/**
 //     AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
 //    AudioServicesPlaySystemSound(1520);
 //    AudioServicesPlaySystemSound(1519);
 //    AudioServicesPlaySystemSound(1521);
 //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 
 UIImpactFeedbackStyleLight,
 
 UIImpactFeedbackStyleMedium,
 
 UIImpactFeedbackStyleHeavy
 
 UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleHeavy];
 [impactLight impactOccurred];
 */
