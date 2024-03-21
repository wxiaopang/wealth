//
//  Utility.m
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import "Utility.h"

static UIWebView *__callWebview__ = nil;

@implementation Utility

+ (NSString*)getUUID {
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef UUIDString = CFUUIDCreateString(kCFAllocatorDefault, UUID);
    NSString *result = [NSString stringWithFormat:@"%@", UUIDString];
    CFRelease(UUID);
    CFRelease(UUIDString);
    return result;
}

+ (NSData *)getUUIDData {
    CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    CFUUIDBytes bytes = CFUUIDGetUUIDBytes(UUID);
    NSData *result = [NSData dataWithBytes:&bytes length:sizeof(bytes)];
    CFRelease(UUID);
    return result;
}

+ (id)fromJSONData:(NSData *)data {
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    if ( error ) {
        obj = nil;
    }
    return obj;
}

+ (id)fromJSONString:(NSString *)string {
    return [Utility fromJSONData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSData *)toJSONData:(id)obj {
    NSData *ret = nil;
    if ( [NSJSONSerialization isValidJSONObject:obj] ) {
        NSError *error = nil;
        ret = [NSJSONSerialization dataWithJSONObject:obj
                                              options:NSJSONWritingPrettyPrinted
                                                error:&error];
        if ( error ) {
            ret = nil;
        }
    }
    return ret;
}

+ (NSString *)toJSONString:(id)obj {
    return [[NSString alloc] initWithData:[Utility toJSONData:obj] encoding:NSUTF8StringEncoding];
}

+ (NSString*)numberToMathString:(double)num AndUseLast:(BOOL)use AndUseSign:(BOOL)sign {
    NSArray * array = [[NSString stringWithFormat:@"%.2f",num] componentsSeparatedByString:@"."];
    
    NSUInteger len = [array.firstObject length];
    NSUInteger x = len%3;
    NSUInteger y = len/3;
    NSUInteger dotNumber = y;
    
    if (x == 0)
    {
        dotNumber -= 1;
        x = 3;
    }
    NSMutableString * rs = [@"" mutableCopy];
    if (sign) {
        [rs appendFormat:@"￥"];
    }
    
    [rs appendString:[array[0] substringWithRange:NSMakeRange(0, x)]];
    
    for (int i=0; i<dotNumber; i++) {
        [rs appendString:@","];
        [rs appendString:[array[0] substringWithRange:NSMakeRange(x + i*3, 3)]];
    }
    if (use) {
        [rs appendString:@"."];
        [rs appendString:array[1]];
    }
    return rs;
}

+ (void)testFunctionTimes:(NSString *)funcNmae tast:(dispatch_block_t)block {
    CFAbsoluteTime startime = CFAbsoluteTimeGetCurrent();
    block();
    CFAbsoluteTime endtime = CFAbsoluteTimeGetCurrent();
    NSLog(@"%@ takes %2.5f second", funcNmae, endtime - startime);
}

+ (UIButton *)configCommoButton:(CGRect)frame
                           text:(NSString *)text
                      textColor:(UIColor *)textColor
                         normal:(UIColor *)normal
                      highlight:(UIColor *)highlight
                        disable:(UIColor *)disable
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.layer.cornerRadius = 4.0f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor clearColor];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateHighlighted];
    [btn setTitle:text forState:UIControlStateDisabled];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateHighlighted];
    [btn setTitleColor:textColor forState:UIControlStateDisabled];
    if ( normal ) {
        [btn setBackgroundImage:[UIImage imageWithColor:normal size:frame.size] forState:UIControlStateNormal];
    }
    if ( highlight ) {
        [btn setBackgroundImage:[UIImage imageWithColor:highlight size:frame.size] forState:UIControlStateHighlighted];
    }
    if ( disable ) {
        [btn setBackgroundImage:[UIImage imageWithColor:disable size:frame.size] forState:UIControlStateDisabled];
    }
    return btn;
}

+ (UIButton *)configHollowButton:(CGRect)frame
                            text:(NSString *)text
                       textColor:(UIColor *)textColor
                     borderColor:(UIColor *)borderColor
                          normal:(UIColor *)normal
                       highlight:(UIColor *)highlight
                         disable:(UIColor *)disable
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.layer.cornerRadius = 4.0f;
    btn.layer.masksToBounds = YES;
    btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.backgroundColor = [UIColor clearColor];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateHighlighted];
    [btn setTitle:text forState:UIControlStateDisabled];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateHighlighted];
    [btn setTitleColor:textColor forState:UIControlStateDisabled];
    if ( normal ) {
        [btn setBackgroundImage:[UIImage imageWithColor:normal size:frame.size] forState:UIControlStateNormal];
    }
    if ( highlight ) {
        [btn setBackgroundImage:[UIImage imageWithColor:highlight size:frame.size] forState:UIControlStateHighlighted];
    }
    if ( disable ) {
        [btn setBackgroundImage:[UIImage imageWithColor:disable size:frame.size] forState:UIControlStateDisabled];
    }
    return btn;
}

+ (NSAttributedString *)configAttributedString:(NSString *)text
                                         color:(UIColor *)color
                                          font:(UIFont *)font
                                     alignment:(NSTextAlignment)alignment
{
    if ( text == nil ) {
        text = kNullStr;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = alignment;
    return [[NSAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName:font,
                                                                         NSForegroundColorAttributeName:color,
                                                                         NSParagraphStyleAttributeName:style }];
}

+ (UILabel *)configLabelWithFont:(UIFont *)textFont
                      lineNumber:(NSInteger)lineNumber
                        textColor:(UIColor *)textColor
                    textAlignment:(NSTextAlignment)textAlig
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = lineNumber < 1 ? 0 : lineNumber;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.textColor = textColor;
    label.font = textFont;
    label.textAlignment = textAlig;
    return label;
}

+ (CGSize)getTextSizeWithText:(NSString *)text size:(CGSize)size font:(UIFont *)textFont {
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textFont} context:nil].size;
}

+ (void)telephoneCall:(NSString *)mobile {
    if ( mobile && mobile.length > 0 ) {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = networkInfo.subscriberCellularProvider;
        if (carrier.mobileCountryCode==nil || carrier.mobileNetworkCode==nil ||carrier.isoCountryCode==nil) {
//            [UIBaseViewController showTextToastWithTitle:@"您的手机没有SIM卡，不能拨打电话" dismissAnimationCompletion:^{}];
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"您的手机没有SIM卡，不能拨打电话" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
            [ale show];
        } else {
            if ( __callWebview__ == nil ) {
                __callWebview__ = [[UIWebView alloc] initWithFrame:CGRectZero];
            }
            [__callWebview__ loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", mobile]]]];
        }
    }
}

+ (BOOL)verifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd , @"[0-9]{3}[0-9Xx]"];
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    NSInteger summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

+ (NSString *)getIDCardBirthday:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([card length] != 18) {
        return nil;
    }
    NSString *birthady = [NSString stringWithFormat:@"%@年%@月%@日",
                          [card substringWithRange:NSMakeRange(6,4)],
                          [card substringWithRange:NSMakeRange(10,2)],
                          [card substringWithRange:NSMakeRange(12,2)]];
    return birthady;
}

+ (NSInteger)getIDCardSex:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger defaultValue = 0;
    if ([card length] != 18) {
        return defaultValue;
    }
    NSInteger number = [[card substringWithRange:NSMakeRange(16,1)] integerValue];
    if (number % 2 == 0) { //偶数为女
        return 2;
    } else {
        return 1;
    }
}

+ (BOOL)verifyPhoneNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    value = [value stringByReplacingOccurrencesOfString:@" " withString:kNullStr];
    if ([value length] != 11) {
        return NO;
    }
    NSString *regex = @"^(1[1-9])[0-9]{9}$";
    NSPredicate *phoneNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phoneNumberPredicate evaluateWithObject:value];
}

+ (BOOL)verifyNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *regex = @"^[0-9]*$";
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [numberPredicate evaluateWithObject:value];
}

+ (void)getBankCardInfo:(NSString *)card complete:(void(^)(NSDictionary *info))complete {
    [GET_HTTP_API get:@"http://apis.baidu.com/datatiny/cardinfo/cardinfo"
              headers:@{ @"apikey":@"4a92958a28dde873ecd9fb6ba6a04767" }
               params:@{ @"cardnum":card }
             complete:^(id JSONResponse, NSError *error) {
                 NSDictionary *ret = nil;
                 if ( JSONResponse && JSONResponse[@"status"] && [JSONResponse[@"status"] integerValue] == 1 ) {
                     ret = JSONResponse[@"data"];
                 }
                 if ( complete ) {
                     complete(ret);
                 }
             }];
}

+ (NSString *)verifyPassWord:(NSString *)value {
    if ( value == nil || value.length == 0 ) {
        return @"密码不能为空";
    }
    
    if ( value.length < 6 || value.length > 20 ) {
        return @"密码长度为6-20位";
    }
    
    NSString *pattern = @"^\\d{6,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:value];
    if ( isMatch ) {
        return @"密码不能全为数字";
    }
    
    pattern = @"^[a-zA-Z]{6,20}";
    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    isMatch = [pred evaluateWithObject:value];
    if ( isMatch ) {
        return @"密码不能全为字母";
    }
    
    pattern = @"^[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]{6,20}";
    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    isMatch = [pred evaluateWithObject:value];
    if ( isMatch ) {
        return @"密码不能全为特殊符号";
    }
    
    // 特殊字符包含`、-、=、\、[、]、;、'、,、.、/、~、!、@、#、$、%、^、&、*、(、)、_、+、|、?、>、<、"、:、{、}
    // 必须包含数字和字母，可以包含上述特殊字符。
    // 依次为（如果包含特殊字符）
    // 数字 字母 特殊
    // 字母 数字 特殊
    // 数字 特殊 字母
    // 字母 特殊 数字
    // 特殊 数字 字母
    // 特殊 字母 数字
    pattern = @"(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}";
    pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    isMatch = [pred evaluateWithObject:value];
    if ( isMatch ) {
        return nil;
    } else {
        return @"6-20位数字字母组合";
    }
}

//(model属性中double改为Number后)处理从数据库里取出的NSNumber类型的空字符串
+ (NSString *)handleNumberClassWithNumber:(NSNumber *)number {
    if (number && [number isKindOfClass:[NSNumber class]] && number.doubleValue >= 0) {
        return [number stringCommonFormatter];
    } else {
        return kNullStr;
    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentTopViewController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }

    UIView *frontView = [window subviews].firstObject;
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}

// get the current view screen shot
+ (UIImage *)screenCapture {
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.bounds.size, NO, [[UIScreen mainScreen]scale]);//这句可以让截图更清晰
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}


+ (NSString *)getHtmlUrlWithController:(NSString *)controller{
    return [NSString stringWithFormat:@"%@%@?token=%@&type=2",HTML5_URL,controller,[UserDefaultsWrapper userDefaultsObject:kPublicToken]];
}

+ (NSString *)getHidePhoneNumber:(NSString *)phoneNum{
    NSInteger lenth = phoneNum.length;
    NSString *result = @"";
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:phoneNum];
    if (lenth > 10) {
        for (NSInteger i = 3; i<lenth-4; i++) {
            [String1 replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }else{
        for (NSInteger i = 0; i<lenth-4; i++) {
            [String1 replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    result = [NSString stringWithFormat:@"%@",String1];
    return result;
}


@end
