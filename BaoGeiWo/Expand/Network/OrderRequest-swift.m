//
//  OrderRequest-swift.m
//  BaoGeiWo
//
//  Created by wb on 2018/10/30.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "OrderRequest-swift.h"
#import "BGWAirportCounterModel.h"

@implementation OrderRequest_swift

#pragma mark 获取所在城市柜台信息
+ (void)getCounterByProvinceId:(NSString *)provinceId cityId:(NSString *)cityId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameter setObject:provinceId forKey:@"provid"];
    [parameter setObject:cityId forKey:@"cityid"];
    
    [BGWRequestManager POST:API_GetCounterByCity parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *array = [BGWAirportCounterModel mj_objectArrayWithKeyValuesArray:responseObject[@"counterList"]];

        if (success) {
            success(array);
        } else {
            [BGWUser currentUser].airportCounters = array;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark 获取所在城市企业柜台信息
+ (void)getEnterpriseCounterByProvinceId:(NSString *)provinceId cityId:(NSString *)cityId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameter setObject:provinceId forKey:@"provid"];
    [parameter setObject:cityId forKey:@"cityid"];
    
    [BGWRequestManager POST:API_GetCounterByCity parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *array = [BGWAirportCounterModel mj_objectArrayWithKeyValuesArray:responseObject[@"counterList"]];
        
        if (success) {
            success(array);
        } else {
            [BGWUser currentUser].enterpriseCounters = array;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark 柜台下单
+ (void)GTPlaceOrderWithParameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [BGWRequestManager POST:API_GTPlaceOrder parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if(success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

#pragma mark qr码是否可用
+ (void)queryQRCodeIsUseful:(NSString *)qrCode success:(SuccessBlock)success failure:(FailureBlock)failure {
    [BGWRequestManager POST:API_ScanQRCode parameters:@{@"baggageid":qrCode} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(@"");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(@"");
        }
    }];
}

#pragma mark 收件地址是否可用
+ (void)checkAddressUsable:(NSString *)coordinate province:(NSString *)provId city:(NSString *)cityId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:provId forKey:@"provid"];
    [parameters setObject:cityId forKey:@"cityid"];
    [parameters setObject:coordinate forKey:@"byCheckgps"];
    [parameters setObject:@"false" forKey:@"istransitgps"];
    
    [BGWRequestManager POST:API_CheckAddressUsable parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success(responseObject[@"checkAddrIsuse"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(@"");
        }
    }];
}




@end
