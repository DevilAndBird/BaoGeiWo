//
//  BGWRequestManager.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BGWRequestManager.h"
#import "AFNetworking.h"


@implementation BGWRequestManager




+ (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(RequestSuccessCallBack)success failure:(RequestFailureCallBack)failure {
    
    
    [[AFHTTPSessionManager manager] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(task, responseObject);
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            failure(task, error);
            
        }
        
    }];
}


+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(RequestSuccessCallBack)success failure:(RequestFailureCallBack)failure {
    
    [self POST:URLString parameters:parameters image:nil success:success failure:failure];
}

+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters image:(id)images success:(RequestSuccessCallBack)success failure:(RequestFailureCallBack)failure {
    
    AFNetworkReachabilityManager *reachabilityManger = [AFNetworkReachabilityManager sharedManager];
    if (reachabilityManger.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (failure) {
            failure(nil, nil);
        }
        POPUPINFO(NSLocalizedString(@"NotReachable", @"无网络"));
        return;
    }
    
    
    if (!parameters) {
        parameters = [NSDictionary dictionary];
    }
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithCapacity:0];
    
    BGWUser *user = [BGWUser currentUser];
    NSString *account, *password, *sign;
    if (user) {
        account = user.account;
        password = user.password;
        sign = user.token;
    } else if ([parameters[@"source"] isEqualToString:@"app"]) {
        account = parameters[@"mobile"];
        password = parameters[@"password"];
        sign = @"";
    } else {
        return;
    }
    
    NSString *timeStamp = [NSString getCurrentTimestamp];
//    NSString *sign = [[NSString stringWithFormat:@"jingpei%@%@%@", account, password, timeStamp] MD5];
    
    [mutableParameters setObject:account?:@"" forKey:@"user"];
    [mutableParameters setObject:password?:@"" forKey:@"key"];
    [mutableParameters setObject:sign?:@"" forKey:@"sign"];
    [mutableParameters setObject:timeStamp?:@"" forKey:@"timestamp"];
    [mutableParameters setObject:[parameters mj_JSONString]?:@"" forKey:@"data"];

    
//    if (mutableParameters) {
//        parameters = @{@"jsondata":[NSJSONSerialization dataWithJSONObject:mutableParameters options:NSJSONWritingPrettyPrinted error:nil]};
//    }
    
    
    NSMutableString *mutableString = [NSMutableString stringWithString:URLString];
    NSRange range;
    if ([URLString containsString:HOST]) {
        range = [URLString rangeOfString:HOST];
        [mutableString deleteCharactersInRange:range];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HOST]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSLog(@"---URL:%@\n---Parameters:%@", mutableString, mutableParameters);
    
    if (!images) {
        [manager POST:mutableString parameters:mutableParameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                
                if ([responseObject[@"code"] integerValue] == BGWResponseCodeSuccess) {
                    if (success) {
                        success(task, [responseObject[@"jsonData"] mj_JSONObject]);
                    }
                } else {
            
                    if ([responseObject[@"code"] integerValue] == BGWResponseCodeLoginError) {
//                        POPUPINFO(@"此账号已在别处登录");
                        [SVProgressHUD dismiss];
                        [[AppDelegate sharedAppDelegate].tabBarController alertWithTitle:@"提示" message:@"此账号已在别处登录" confirm:^{
                            [[AppDelegate sharedAppDelegate] loginBGWUI];
                        }];
                    } else {
                        POPUPINFO(responseObject[@"msg"]);
                        if (failure) {
                            failure(nil, [NSError new]);
                        }
                    }

                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            if (failure) {
                
                POPUPINFO(@"请求超时");
                failure(task, error);
                
            }
        }];
    } else {
        
        
        
        [manager POST:URLString parameters:mutableParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            if (images) {
                
                if ([images isKindOfClass:[UIImage class]]) {
                    
                    
                    NSData *data = UIImagePNGRepresentation(images);
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *str = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                    
                    if (data) {
                        [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/png"];
                    }
                    
                    
                } else if ([images isKindOfClass:[NSArray class]]) {
                    
                    for (UIImage *image in images) {
                        NSData *data = UIImageJPEGRepresentation(image, 0.5);
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyyMMddHHmmss";
                        NSString *str = [formatter stringFromDate:[NSDate date]];
                        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                        
                        if (data) {
                            [formData appendPartWithFileData:data name:@"image[]" fileName:fileName mimeType:@"image/png"];
                        }
                    }
                    
                }
                
                
            }
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                
                success(task, responseObject);
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            if (failure) {
                
                POPUPINFO(@"请求超时");
                failure(task, error);
                
            }
            
            
        }];
    }
    
    
}






@end
