//
//  OrderPricingRuleModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/10/26.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "OrderPricingRuleModel.h"


@implementation OrderGoldPricingRuleModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"unitPrice" : @"basemoney",
             @"overnightPrice" : @"overnight",
             @"nightNum" : @"nightnum",
             };
}

@end



@implementation OrderSpecialPricingRuleModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"startPrice" : @"startingmoney",
             @"startDistance" : @"startingkm",
             @"perKmPrice" : @"perkmmoney",
             @"extraBagNum" : @"startlugnum",
             @"extraBagPrice" : @"extralugmoney",
             };
}

@end




@implementation OrderPricingRuleModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"goldPricingRule" : @"goldPriceDetail",
             @"specialPricingRule" : @"specialPriceDetail"
             };
}

@end
