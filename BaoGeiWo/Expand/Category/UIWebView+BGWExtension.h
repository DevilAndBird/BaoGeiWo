//
//  UIWebView+BGWExtension.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/21.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (BGWExtension)

/**
 * 打电话功能 推荐使用，弹框由系统决定
 
 @param phoneNumber 电话号码
 */
+ (void)webViewCallWithPhoneNumber:(NSString *)phoneNumber;

@end
