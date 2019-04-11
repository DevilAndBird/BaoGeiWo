//
//  BGWUtil.m
//  BaoGeiWo
//
//  Created by wb on 2018/7/6.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BGWUtil.h"

@implementation BGWUtil

+ (void)cameraAuth:(void(^)(void))authorized fail:(void(^)(void))fail {
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
//        POPUPINFO(@"应用相机权限受限,请在设置中启用");
        if (fail) {
            fail();
        }
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (authorized) {
                        authorized();
                    }
                });
            }
        }];
    }else{
        if (authorized) {
            authorized();
        }
        
    }
    
}

@end
