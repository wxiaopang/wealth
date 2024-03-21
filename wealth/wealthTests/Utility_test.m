//
//  Utility_test.m
//  wealth
//
//  Created by wangyingjie on 16/5/4.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utility.h"


@interface Utility_test : XCTestCase

@end

@implementation Utility_test

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    
    
}
- (void)testNumberToMathStringLAndS{
    NSString *result = [Utility numberToMathString:88.88888 AndUseLast:YES AndUseSign:YES];
    XCTAssertEqualObjects(result,@"￥88.89",@"带符号保留两位");
}
- (void)testNumberToMathStringS{
    NSString *result = [Utility numberToMathString:88.88888 AndUseLast:NO AndUseSign:YES];
    XCTAssertEqualObjects(result,@"￥88",@"带符号整数");
}
- (void)testNumberToMathStringL{
    NSString *result = [Utility numberToMathString:88.88888 AndUseLast:YES AndUseSign:NO];
    XCTAssertEqualObjects(result,@"88.89",@"不带符号保留两位");
}
- (void)testNumberToMathString{
    NSString *result = [Utility numberToMathString:88.88888 AndUseLast:NO AndUseSign:NO];
    XCTAssertEqualObjects(result,@"88",@"不带符号整数");
}
- (void)testVerifyIDCardNumberNoLenth{
    BOOL isIdCard = [Utility verifyIDCardNumber:@"11111111111111"];
    XCTAssertFalse(isIdCard,@"身份证位数不正确");
}
- (void)testVerifyIDCardNumberFalse{
    BOOL isIdCard = [Utility verifyIDCardNumber:@"140823198506064022"];
    XCTAssertFalse(isIdCard,@"身份证不正确");
}
- (void)testVerifyIDCardNumberTrue{
    BOOL isIdCard = [Utility verifyIDCardNumber:@"362326198306270039"];
    XCTAssertTrue(isIdCard,@"身份证正确不带x");
}
- (void)testVerifyIDCardNumberTrue_x{
    BOOL isIdCard = [Utility verifyIDCardNumber:@"37060219830224041X"];
    XCTAssertTrue(isIdCard,@"身份证正确带x");
}

- (void)testGetIDCardBirthday{
    NSString *birthday = [Utility getIDCardBirthday:@"37060219830224041X"];
    XCTAssertEqualObjects(birthday,@"1983年02月24日",@"身份证生日");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
