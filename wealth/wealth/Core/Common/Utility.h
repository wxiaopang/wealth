//
//  Utility.h
//  wealth
//
//  Created by wangyingjie on 14/12/17.
//  Copyright (c) 2014年 puhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSString *)getUUID;

+ (NSData *)getUUIDData;

+ (id)fromJSONData:(NSData *)data;

+ (id)fromJSONString:(NSString *)string;

+ (NSData *)toJSONData:(id)obj;

+ (NSString *)toJSONString:(id)obj;

//
+ (NSString*)numberToMathString:(double)num AndUseLast:(BOOL)use AndUseSign:(BOOL)sign;

+ (void)testFunctionTimes:(NSString *)funcNmae tast:(dispatch_block_t)block;

+ (UIButton *)configCommoButton:(CGRect)frame
                           text:(NSString *)text
                      textColor:(UIColor *)textColor
                         normal:(UIColor *)normal
                      highlight:(UIColor *)highlight
                        disable:(UIColor *)disable;

+ (UIButton *)configHollowButton:(CGRect)frame
                            text:(NSString *)text
                       textColor:(UIColor *)textColor
                     borderColor:(UIColor *)borderColor
                          normal:(UIColor *)normal
                       highlight:(UIColor *)highlight
                         disable:(UIColor *)disable;

+ (UILabel *)configLabelWithFont:(UIFont *)textFont
                      lineNumber:(NSInteger)lineNumber
                       textColor:(UIColor *)textColor
                   textAlignment:(NSTextAlignment)textAlig;

+ (NSAttributedString *)configAttributedString:(NSString *)text
                                         color:(UIColor *)color
                                          font:(UIFont *)font
                                     alignment:(NSTextAlignment)alignment;

+ (CGSize)getTextSizeWithText:(NSString *)text size:(CGSize)size font:(UIFont *)textFont;

+ (void)telephoneCall:(NSString *)mobile;

//验证身份证
//必须满足以下规则
//1. 长度必须是18位，前17位必须是数字，第十八位可以是数字或X
//2. 前两位必须是以下情形中的一种：11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91
//3. 第7到第14位出生年月日。第7到第10位为出生年份；11到12位表示月份，范围为01-12；13到14位为合法的日期
//4. 第17位表示性别，双数表示女，单数表示男
//5. 第18位为前17位的校验位
//算法如下：
//（1）校验和 = (n1 + n11) * 7 + (n2 + n12) * 9 + (n3 + n13) * 10 + (n4 + n14) * 5 + (n5 + n15) * 8 + (n6 + n16) * 4 + (n7 + n17) * 2 + n8 + n9 * 6 + n10 * 3，其中n数值，表示第几位的数字
//（2）余数 ＝ 校验和 % 11
//（3）如果余数为0，校验位应为1，余数为1到10校验位应为字符串“0X98765432”(不包括分号)的第余数位的值（比如余数等于3，校验位应为9）
//6. 出生年份的前两位必须是19或20
+ (BOOL)verifyIDCardNumber:(NSString *)value;

+ (NSString *)getIDCardBirthday:(NSString *)card;

+ (NSInteger)getIDCardSex:(NSString *)card;

+ (BOOL)verifyPhoneNumber:(NSString *)value;

+ (BOOL)verifyNumber:(NSString *)value;

+ (void)getBankCardInfo:(NSString *)card complete:(void(^)(NSDictionary *info))complete;

// 密码规则
// 1、数字，字母，特殊字符必须至少各有一个
// 2、长度6-20位
+ (NSString *)verifyPassWord:(NSString *)value;

//处理从数据库里取出的NSNumber类型的空字符串
+ (NSString *)handleNumberClassWithNumber:(NSNumber *)number;

//获取最顶层的UIViewController
+ (UIViewController *)getCurrentTopViewController;

+ (UIImage *)screenCapture;

+ (NSString *)getHtmlUrlWithController:(NSString *)controller;


+ (NSString *)getHidePhoneNumber:(NSString *)phoneNum;

@end