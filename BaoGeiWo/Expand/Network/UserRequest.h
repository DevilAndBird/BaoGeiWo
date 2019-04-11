//
//  UserRequest.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(id error);

@interface UserRequest : NSObject

+ (void)userLoginWithAccount:(NSString *)account password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
