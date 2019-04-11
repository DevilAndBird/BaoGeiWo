//
//  BaseTabBarController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController


@property (nonatomic, assign) NSInteger unreadSystemMsgCount;
@property (nonatomic, assign) NSInteger unreadOrderMsgCount;

- (void)alertWithTitle:(NSString *)title message:(NSString *)message confirm:(void(^)(void))confirm;

- (void)skipViewController:(NSDictionary *)userInfo;

@end
