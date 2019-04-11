//
//  OrderRequest-swift.h
//  BaoGeiWo
//
//  Created by wb on 2018/10/30.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(id error);

@interface OrderRequest_swift : NSObject

//查询所在城市柜台信息
+ (void)getCounterByProvinceId:(NSString *)provinceId cityId:(NSString *)cityId success:(SuccessBlock)success failure:(FailureBlock)failure;
//查询所在城市企业柜台信息
+ (void)getEnterpriseCounterByProvinceId:(NSString *)provinceId cityId:(NSString *)cityId success:(SuccessBlock)success failure:(FailureBlock)failure;
//柜台下单
+ (void)GTPlaceOrderWithParameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
//qr码是否可用
+ (void)queryQRCodeIsUseful:(NSString *)qrCode success:(SuccessBlock)success failure:(FailureBlock)failure;
//收件地址是否可用
+ (void)checkAddressUsable:(NSString *)coordinate province:(NSString *)provId city:(NSString *)cityId success:(SuccessBlock)success failure:(FailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
