//
//  OrderBaggageModel.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderBaggageModel.h"

//@implementation OrderBaggageModel
//
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"baggageQRCode" : @"baggageid",
//             @"baggageId" : @"id",
//             @"baggageImageUrl" : @"imgurl",
//             };
//}
//
//@end

@implementation OrderBaggageImageModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"takeImageUrls" : @"COOLECT",
             @"sendImageUrls" : @"RELEASE",
             };
}
@end

@implementation OrderBaggageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"baggageQRCode" : @"baggageid",
             @"baggageId" : @"id",
             @"baggageImage" : @"imgurl",
             };
}

- (OrderBaggageImageModel *)baggageImage {
    if (!_baggageImage) {
        _baggageImage = [OrderBaggageImageModel new];
    }
    return _baggageImage;
}

@end
