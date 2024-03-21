//
//  ProductionBuyDetailModel.m
//  wealth
//
//  Created by wangyingjie on 16/4/6.
//  Copyright © 2016年 puhui. All rights reserved.
//

#import "ProductionBuyDetailModel.h"

@implementation ProductionBuyDetailModel


-(void)dealloc{
    self.contractUrl = nil;
    self.sellerName = nil;
    self.sellerPicUrl = nil;
    self.sellerPosition = nil;
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (dictionary && dictionary.count > 0) {
            self.seller = [[dictionary objectForKey:@"seller"] longLongValue];
            self.startAmount = [[dictionary objectForKey:@"startAmount"] doubleValue];
            self.minAmount = [[dictionary objectForKey:@"minAmount"] doubleValue];
            self.maxAmount = [[dictionary objectForKey:@"maxAmount"] doubleValue];
            self.sellerTotalSales = [[dictionary objectForKey:@"sellerTotalSales"] doubleValue];
            self.expectedEarnings = [[dictionary objectForKey:@"expectedEarnings"] doubleValue];
            self.theAccountBalance = [[dictionary objectForKey:@"theAccountBalance"] doubleValue];
            self.haveSales = [[dictionary objectForKey:@"haveSales"] boolValue];
            self.contractUrl = [dictionary objectForKey:@"contractUrl"];
            self.sellerPicUrl = [dictionary objectForKey:@"sellerPicUrl"];
            self.sellerName = [dictionary objectForKey:@"sellerName"];
            self.sellerPosition = [dictionary objectForKey:@"sellerPosition"];
            
        }
    }
    return self;
}



@end
