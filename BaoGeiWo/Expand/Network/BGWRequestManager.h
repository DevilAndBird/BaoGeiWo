//
//  BGWRequestManager.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^RequestSuccessCallBack)(NSURLSessionDataTask *task, id responseObject);
typedef void(^RequestFailureCallBack)(NSURLSessionDataTask *task, NSError *error);


@interface BGWRequestManager : NSObject




+ (void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters success:(RequestSuccessCallBack)success failure:(RequestFailureCallBack)failure;

+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(RequestSuccessCallBack)success failure:(RequestFailureCallBack)failure;

+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters image:(id)images success:(RequestSuccessCallBack)success failure:(RequestFailureCallBack)failure;




@end
