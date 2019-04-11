//
//  AliyunOSSService.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/15.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(id error);

@interface AliyunOSSService : NSObject

+ (instancetype)shareInstance;

- (void)uploadObjectWithImage:(UIImage *)image success:(SuccessBlock)success failure:(FailureBlock)failure;



@end
