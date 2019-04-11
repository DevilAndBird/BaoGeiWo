//
//  UIWebView+BGWExtension.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/21.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "UIWebView+BGWExtension.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@implementation UIWebView (BGWExtension)

+ (void)webViewCallWithPhoneNumber:(NSString *)phoneNumber{
    UIWebView *webView = [[UIWebView alloc]init];
    NSString * str= [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *url = [NSURL URLWithString:str];
    CTTelephonyNetworkInfo *netInfo = [CTTelephonyNetworkInfo new];
    if (netInfo.subscriberCellularProvider.carrierName.length > 0) {
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [[UIApplication sharedApplication].keyWindow addSubview:webView];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请确认SIM卡以正确安装" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [[AppDelegate sharedAppDelegate].tabBarController presentViewController:alert animated:YES completion:nil];
    }
    
    
}

@end
