//
//  AliyunOSSService.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/15.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "AliyunOSSService.h"
#import <AliyunOSSiOS/OSSService.h>


#define AliyunOSSKey @"LTAIg8xwvCWb7Trj"
#define AliyunOSSSecret @"ui9Wtn1VtAZRzQqm0YGitOrPk6weMm"

@implementation AliyunOSSService

static OSSClient *client;
static AliyunOSSService *service;

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        service = [AliyunOSSService new];
        
        NSString *endpoint = @"oss-cn-hangzhou.aliyuncs.com";
        
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
        conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
        conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
        
        
        //    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:@"LTAIU4YuL2jJ0cVX" secretKeyId:@"bUJwbQXD2ryqJle1X6BkUCM5SHCN2W" securityToken:@"SecurityToken"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        OSSPlainTextAKSKPairCredentialProvider *credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliyunOSSKey secretKey:AliyunOSSSecret];
#pragma clang diagnostic pop
        
        client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
    });
    return service;
    
}


//域名：            jingpeioss.oss-cn-hangzhou.aliyuncs.com
//权限：            私有读写
//Access Key ID：        LTAIU4YuL2jJ0cVX
//Access Key Secret：    bUJwbQXD2ryqJle1X6BkUCM5SHCN2W

//新建的
//LTAIg8xwvCWb7Trj
//ui9Wtn1VtAZRzQqm0YGitOrPk6weMm

- (void)uploadObjectWithImage:(UIImage *)image success:(SuccessBlock)success failure:(FailureBlock)failure {
    //图片的方向信息去掉
    UIImage *normalizedImage;
    if (image.imageOrientation == UIImageOrientationUp) {
        normalizedImage = image;
    }else{
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        [image drawInRect:(CGRect){0, 0, image.size}];
        normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = @"jingpeioss";
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    put.objectKey = [NSString stringWithFormat:@"%@.jpg", timeSp];
    NSData *imageData = UIImageJPEGRepresentation(normalizedImage, 0.5);
    put.uploadingData = imageData;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload object success!");
            NSString *fileName = [NSString stringWithFormat:@"http://jingpeioss.oss-cn-hangzhou.aliyuncs.com/%@.jpg", timeSp];
            if (success) {
                success(fileName);
            }
        } else {
            if (failure) {
                failure(task.error);
            }
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
    
}




@end
