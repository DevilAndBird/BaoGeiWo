//
//  AppDelegate.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/2.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) BaseTabBarController *tabBarController;

+ (instancetype)sharedAppDelegate;
- (void)loginBGWUI;


@end

