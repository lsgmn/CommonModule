//
//  QuickFunction.h
//  CarServe
//
//  Created by IBTC on 2019/6/19.
//  Copyright © 2019 IBTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>


@interface QuickFunction : NSObject
/**MARK: 屏幕高*/
CGFloat QF_SCREE_HEIGHT(void);

/**MARK: 屏幕宽*/
CGFloat QF_SCREE_WIDTH(void);

/**MARK: 获取rect QF_topViewController*/
CGRect QF_GET_RECT(void);

/**MARK: 去掉tableView多余的线*/
void QF_CLEAR_TABLE_LIN(UITableView *table);

/**MARK: 去掉tableView某一行的线*/
void QF_CLEAR_ARow_LIN(UITableViewCell *cell);

/**MARK: RGB 颜色值*/
UIColor* QF_RGBCOLORT(int r,int g,int b,CGFloat a);

/**MARK: 十六进制 颜色值*/
UIColor* QF_HEXColor(NSString *hexColor);
UIColor* QF_HEXColorA(NSString *hexColor,CGFloat alpha);

/**MARK: 通过控制器字符串push VC*/
void QF_PUSH_VC(NSString *vc_Name);

/**MARK: 通过控制器push VC*/
void QF_PUSH_VCV(UIViewController*vc);

/**MARK: 通过控制器PRE VC*/
void QF_PRESENT_VC(UIViewController*vc);

void QF_PRESENT_VC_A(UIViewController*vc,BOOL flag);

/**MARK: pop VC*/
void QF_POP_VC(void);

/**MARK: DIS_VC*/
void QF_DIS_VC(BOOL flag);

/**MARK: pop root VC*/
void QF_POP_ROOT_VC(void);

/**MARK: pop 到指定 VC*/
void QF_POPTO_VC(NSString *vc_Name);

/**MARK:  yes 当天  no 不是*/
BOOL QF_isSameDay(long iTime1,long iTime2);

/**MARK: 获取当前的时间*/
NSString* QF_GET_CURRENT_DATE(NSString *f);

/**MARK: 加粗字体*/
UIFont* QF_BOLD_FONT(CGFloat size);

/**MARK: 进位*/
NSInteger QF_CarryMethod(NSInteger num,CGFloat dividend);

/**MARK: 摸位*/
NSInteger QF_FloorfMethod(float num);

/**MARK: 导航加状态栏的总高度*/
CGFloat QF_statusBarHAndNavH(void);

/**MARK: 导航加状态栏加iPhone X虚拟bar的总高度 */
CGFloat QF_statusBarHAndNavHAndIphoneXBarH(void);

/**MARK: 是否是iPhone X*/
BOOL QF_iPhoneX(void);

/**MARK: 获取当前屏幕显示的viewcontroller*/
UIViewController* QF_topViewController(void);

/**MARK: 获取当前屏幕显示的viewcontroller*/
UIViewController* QF_getCurrentVC(void);

/**MARK: 去掉前后空格*/
NSString* QF_TrimBASpace(NSString * str);

/**MARK: 给定一个时间获取星期几*/
NSInteger QF_weekdayStringFromDate(NSDate*inputDate);

/**MARK: 指定一个字符串时间 返回 数字的星期几 【1 - 7】 对应 【日 - 六】*/
NSInteger QF_specifiedTime(NSString *dateStr);

/**MARK: 计算内容SIZE isWH yes 获取最大 高度，No 获取最大 宽度 */
CGSize QF_ComputingContentMAX_HORMAX_W(NSString *content,CGFloat wh,UIFont *font,bool isWH);

/**MARK: 压缩图片到AnyM以下*/
NSData* QF_jpgDataWithImage(UIImage *image,NSUInteger maxSize);

/**MARK: json转字典或数组*/
id QF_dictionaryWithJsonString(NSString *jsonString);

/**MARK: 数组转json*/
NSString * QF_ArrayORDicConversionJsonString(id data);

/**MARK: 字典转json*/
NSString * QF_DicORDicConversionJsonString(NSDictionary * dictionary);

/**MARK: 取出iOS11 table和 scroll 空隙*/
void QF_ios11Spece(id p);

/**MARK: 获取storyboard*/
id QF_getVCInBoard(NSString * bord,NSString *Id);

/**MARK: 颜色渐变*/
void QF_Gradient(UIView *viewT);

/**MARK: 颜色渐变 和圆角*/
void QF_GradientC(UIView *viewT,NSString *color1,NSString *color,CGFloat cornerRadius);

/**MARK: 颜色渐变 透明 和圆角*/
void QF_GradientCA(UIView *viewT,NSString *color1,CGFloat a1,NSString *color2,CGFloat a2,CGFloat cornerRadius);

/**MARK: UIView转换成Image*/
UIImage * QF_ConvertViewToImage(UIView *v);

/**MARK: 获取上一个控制器*/
UIViewController * QF_getOnController(void);

/**MARK: 上个控制器是否和指定的控制器相等*/
BOOL QF_aControllerIsEqualToTheSpecifiedController(NSString * className);

/**MARK:  颜色生成图片 P 图片颜色 图片高度*/
UIImage* QF_GetImageWithColor(UIColor*color,CGFloat height);

/**MARK:  设置导航透明 隐藏导航*/
void QF_settingNAVTransparentH(void);

/**MARK:  去掉导航栏底部的黑线*/
void QF_HiddenNAVBottomLine(void);

/**MARK:  显示导航栏底部的黑线*/
void QF_ShowNAVBottomLine(void);

/**MARK:  设置某个角的圆角 P1：需要的制定圆角的view P2:圆角的size P3: 枚举 设置圆角的方向*/
void QF_customCornerRad(UIView *view,CGSize size,UIRectCorner corners);
/**MARK:  设置某个角的圆角*/
void QF_customCornerRadNew(UIView *view,CGSize size,UIRectCorner corners,CGFloat lineWidth,CAShapeLayerLineCap lineCap,UIColor *lineC,UIColor *bC);
/**MARK:  设置任意的圆角*/
void QF_customCornerAny(UIView *view, CGFloat topLeftRadius, CGFloat topRightRadius, CGFloat bottomLeftRadius, CGFloat bottomRightRadius);

/**MARK: 开启左滑必须在viewDidLoad设置代理*/
void QF_POPDelegate(void);

/**MARK: 开启左滑*/
void QF_POPEnabledYES(void);

/**MARK: 关闭左滑*/
void QF_POPEnabledNO(void);

/**MARK: 传入View截屏*/
UIImage *QF_ScreenShotsWithView(UIView *view);

/**MARK: 添加退出后台的模糊效果*/
void QF_APPBlur(UIWindow *window);

/**MARK: 删除window视图*/
void QF_REMAPPBlur(void);

/**MARK: 收回键盘*/
void QF_ViewEndEditing(void);

/**MARK: 抖动View*/
void QF_ShakeView(UIView *viewToShake);

/**MARK: 有导航栏的时候，坐标从(0,64)变成从(0,0)开始*/
void QF_edgesForExtendedLayout(void);

/**MARK: 将时间戳转换为时间字符串 传入秒*/
NSString * QF_timestampToTimeStr(long long timestamp , NSString *formatStr);

/**MARK: 获取日期格式化器*/
NSDateFormatter *QF_dateFormatWith(NSString *formatStr);

/**MARK: 胃词 @param regex 正则条件 @param text 匹配对象 @return yes包含 no不包含*/
BOOL QF_Predicate(NSString *regex,NSString *text);

/**MARK: Alert*/
void QF_AlertController(NSString *title,NSString *message,NSString *CancelTitle,NSString *DefaultTitle,void(^CancelBlock)(void),void(^DefaultBlock)(void));

/**MARK: MP3转换PCM*/
void QF_convertMP3ToPCMWithAVFoundation(NSString *mp3FilePath,NSString *pcmFilePath,void(^callback)(BOOL success, NSString *outputPath));

/**MARK: 获取系统biuld*/
CGFloat QF_getSystemBundle(void);

/**MARK: 获取版本号*/
NSString *QF_getAppVersion(bool isType);

/**MARK:  获取系统版本号*/
CGFloat QF_getSystemVersion(void);

/**MARK: 处理字符串为nil*/
NSString * QF_StringNil(NSString *str);

/**MARK: 改变lable行间距*/
void QF_ChangeLineSpaceForLabel(UILabel *label,float space);

/**MARK: 改变lable字间距*/
void QF_ChangeWordSpaceForLabel(UILabel *label,float space);

/**MARK: 改变lable行间距和字间距*/
void QF_ChangeWordSpaceAndChangeLineSpaceForLabel(UILabel *label,float lineSpace,float wordSpace);

/** MARK: 打电话*/
void QF_Telprompt(NSString *telStr);

/** MARK: 获取视频第一帧*/
void QF_FirstFrameWithVideo(NSURL *url,CGSize size,UIImageView *imageT);

/** MARK:  获取view上面的约束*/
NSLayoutConstraint * QF_GetConstraint(NSArray<__kindof NSLayoutConstraint *> *constraints,NSString *identifier);

/** MARK: 设置view阴影*/
void QF_ViewShadow(UIView *view,UIColor *shadowColor,float shadowOpacity);

/** MARK:  log*/
void QF_L(id obj);

/** MARK:  设置字符串的删除线*/
NSMutableAttributedString* QF_StringAddUnderlineStyleSingle(NSString * obj);

/** MARK:  电话号码加星*/
NSString *QF_phoneEncryption(NSString *phoneString);

/** MARK:  base64StringFromData*/
NSString *QF_base64StringFromData(NSData *data,long length);

/** MARK: 将图片添加到 lable*/
NSMutableAttributedString *QF_lableInserImage(NSString *imageName,NSString *content,CGRect rect);

/** MARK: 设置某个TabBar角标*/
void QF_settingTabBarItemBadgeValueWitItemIndexAndBadgeValue(NSInteger index,NSString *badgeValue);

/** MARK: 获取屏幕上的某个控件相对位置*/
CGPoint QF_GetTheRelativePositionOfAControlOnTheScreen(UIView *view,UIView *superView);

/** MARK: ￥ 符号和数字的距离*/
NSMutableAttributedString* QF_dealPrince(NSString * obj);

/// 符号￥和数字的距离 扩展
/// @param obj 钱 f如100.00
/// @param arg1 ￥ 的字号
/// @param arg2 数字的字号
/// @param isBold 是否需要加粗 yes 加粗 否则不加粗
/// @param color 设置文字颜色
/// @param kern1 ￥与数字的距离 负数 表示 距离越近
/// @param kern2 数字间的距离 负数 表示 距离越近
NSMutableAttributedString* QF_dealPrinceK(NSString * obj,CGFloat arg1,CGFloat arg2,BOOL isBold,UIColor *color,CGFloat kern1,CGFloat kern2);

/// 获取UITableView 上的 UITableViewCell 的 NSIndexPath
/// @param tableViewCell  UITableViewCell
NSIndexPath* QF_getTableViewUpTableViewCellTheIndexPath(UITableViewCell *tableViewCell);


///  获取当前时间戳 yes 秒 No 毫秒
NSString* QF_getNowTimeStamp(BOOL isM);

/** MARK: 通过Model 获取是否是  iPhone X系列  NO是iPhone X系列 ； YES 非iPhone X系列*/
BOOL QF_isIPhoneX(void);

/** MARK: 添加到llabel富文本*/
void QF_AttributedStringToLabel(UILabel *label,NSString *text);

/** MARK: 复制*/
void QF_Copy(NSString *text);

/** MARK: 去除两边空格*/
NSString *QF_trimS(NSString *str);

/** MARK: 将指定View 转换成 图片 save 到本地*/
void QF_SaveThePictureLocally(UIView * aview,void(^saveBlock)(void));

//MARK: 字符串时间转换时间戳 毫秒2020-12-4
NSString* QF_getTimestampWithDate(NSString *str);

//MARK: 字符串时间转换时间戳 毫秒2020-12-4
NSString* QF_getTimestampWithDateF(NSString *str,NSString *df);

//MARK: 获取PhAsset URL
void QF_PHAssetGetURL(PHAsset *asset,void(^SuessBlock)(NSURL *url));

//MARK: MOV 转换 MP4
void QF_MOVCMP4(NSURL *URL,void(^SuessBlock)(NSData *data));

//MARK: 链接转字典  （参数）
NSDictionary * QF_dictionaryWithUrlString(NSString *urlStr);

//MARK: 修改TextField PL颜色
void QF_ChangeTP(UITextField * T,UIColor *color, UIFont *font);

//MARK: 注册通知 发送通知
void QF_NOTI_ADD(id s,SEL sel, id name);
void QF_NOTI_POST(id name);
void QF_NOTI_POST_N(id name,id object);

//MARK: 注册View XIB
id QF_BNIB(NSString *nibStr,int index);

//MARK: 注册TableView XIB
void QF_RGTableViewCELL(UITableView *tableView,NSString *nibS,NSString *Identifier);

//MARK: Base64转图片
UIImage *QF_Base64ConversionImage(NSString *base64Str);

/**
 *
 * // MARK: 1设置UILable 的字体和颜色
 @ label            :要设置的控件
 @ str                :要设置的字符串
 @ textArray      :有几个文字需要设置
 @ colorArray     :有几个颜色
 @ fontArray      :有几个字体
 */
void QF_LAS(UILabel*label,NSString * string,NSArray *textArray,NSArray*colorArray,NSArray *fontArray);

/**
 * //MARK:2设置UILable 的字体和颜色
 @ theLab            :要设置的控件
 @ change                :要设置的字符串
 @ allColor      :有几个文字需要设置
 @ markColor     :有几个颜色
 @ fontSize      :有几个字体
 */
void QF_LAS2(UILabel*theLab,NSString * change,UIColor *allColor,UIColor*markColor,UIFont *font,int baselineOffset);


/**
 * 正则密码必须是6-16字母数字
 @ password            :密码
 @ return            :yes 输入正确 NO输入错误
 */
BOOL QF_CheckPassword(NSString *password);

/**
 * 关闭左滑
 @ UIViewController :vc
 @ enable            :NO 关闭 YES开启
 
 */
void QF_popGestureChange(UIViewController *vc, BOOL enable);

/// 判断空 null
/// @param aValue string
BOOL QF_setNoNull(id aValue);

/// view转圈圈
/// @param view view
void QF_ViewZQQS(UIView *view);
/// 结束转圈圈
/// @param view view
void QF_ViewZQQEnd(UIView *view);

//MARK: 得到当前时间相对1970时间的字符串，精度到秒，返回10位长度字符串
NSString * QF_getCurrentTimeBySecond(void);

//MARK: 得到当前时间相对1970时间的字符串，精度到毫秒，返回13位长度字符串
NSString * QF_getCurrentTimeStringToMilliSecond(void);

//MARK: 获取当前日期前一个月日期
NSString * QF_GetPreviousMonth(NSString *Format);
//MARK: 当前的年月日等时间信息
NSDateComponents * QF_GetComponents(void);
/*! *时间戳转时间(使用当地时区)*/
NSString * TimestampToTimeWtihString(NSString *timestamp,NSString *format);

//MARK: 设置view属性
void QF_Layer(UIView *l,CGFloat cornerRadius,CGFloat borderWidth,UIColor *borderColor);

//MARK: 列出所有字体的名称
void QF_AllFamilyNames(void);

/// 设置 UILabel 的文字样式，并返回计算的高度
/// @param text 文本内容
/// @param font 字体
/// @param textColor 文字颜色
/// @param lineSpacing 行间距
/// @param wordSpacing 字间距
/// @param numL 几行
void QF_setLabelATN(UILabel *label,NSString *text,UIFont *font,UIColor *textColor,CGFloat lineSpacing,CGFloat wordSpacing,NSInteger numL);


/// 设置 UILabel 的文字样式，并返回计算的高度
/// @param text 文本内容
/// @param font 字体
/// @param textColor 文字颜色
/// @param lineSpacing 行间距
/// @param wordSpacing 字间距
/// @param maxWidth 最大宽度
/// @return 根据设置完成的 UILabel 高度
CGFloat QF_setLabelAT(UILabel *label,NSString *text,UIFont *font,UIColor *textColor,CGFloat lineSpacing,CGFloat wordSpacing,CGFloat maxWidth);

CGFloat QF_setLabelATT(UILabel *label,NSAttributedString *text,UIFont *font,UIColor *textColor,CGFloat lineSpacing,CGFloat wordSpacing,CGFloat maxWidth);

//MARK: 时间戳转时间
NSString * QF_convertTimestampToDate(NSTimeInterval timestamp,NSString *format);

//MARK: 秒转00:00:00
NSString * QF_convertSecondsToTimeFormat(NSInteger seconds);

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
void QF_GradientCAOffS(UIView *viewT, NSString *color1, CGFloat a1, NSString *color2, CGFloat a2, CGFloat cornerRadius, NSString *direction);

//MARK: 国际化
NSString * QF_LocalozedS(NSString *str);

//MARK: 判断是否是中文YES 就是NO其他
bool QF_checkSystemLanguage(void);

//MARK: 判断是否是中文或者英文YES NO其他语言
bool QF_checkSystemLanguageISZHEN(void);

//MARK: 获取window
UIWindow * QF_getCurrentWindow13(void);

//MARK: 添加长按手势
void QFLongPressGesture(id s,SEL sel,id v);

//MARK: 通过手势点击的点转换为当前window 上面的点（x,y）
CGPoint QF_gesTRCFrameWithgestureRecognizer(UILongPressGestureRecognizer *gestureRecognizer,CGFloat viewW,CGFloat viewH);

@end


