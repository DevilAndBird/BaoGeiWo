//
//  BaseTabBarController.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "UITabBar+BGWExtension.h"
#import <CoreLocation/CoreLocation.h>
#import "TabBarScanViewController.h"
#import "FeedbackViewController.h"
#import "QPYTaskListContainerViewController.h"

#import "MessageRequest.h"
#import "OrderRequest.h"
#import "OrderRequest-swift.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.tabBar.tintColor = kMThemeColor;
    self.tabBar.backgroundColor = kWhiteColor;
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [self.tabBar setBGView];
    
    [self addChildViewControllerWithName:@"HomeViewController" tabBarTitle:@"首页" tabBarImage:@"tabbar_home_default" tabBarSelectImage:@"tabbar_home_selected"];
    [self addChildViewControllerWithName:@"InviteViewController" tabBarTitle:@"邀请" tabBarImage:@"tabbar_invite_default" tabBarSelectImage:@"tabbar_invite_selected"];
    [self addChildViewControllerWithName:@"BaseViewController" tabBarTitle:@"" tabBarImage:@"" tabBarSelectImage:@""];
    [self addChildViewControllerWithName:@"OrderMessageViewController" tabBarTitle:@"消息" tabBarImage:@"tabbar_msg_default" tabBarSelectImage:@"tabbar_msg_selected"];
    [self addChildViewControllerWithName:@"MineViewController" tabBarTitle:@"我的" tabBarImage:@"tabbar_mine_default" tabBarSelectImage:@"tabbar_mine_selected"];

    __weak typeof(self) ws = self;
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:self keyPaths:@[@"unreadSystemMsgCount", @"unreadOrderMsgCount"] options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [ws onUnReadMessage];
    }];
    
    NSString *provinceId = [BGWUser currentUser].userRole.provinceId;
    NSString *cityId = [BGWUser currentUser].userRole.cityId;
    [OrderRequest_swift getCounterByProvinceId:provinceId cityId:cityId success:nil failure:nil];
    [OrderRequest_swift getEnterpriseCounterByProvinceId:provinceId cityId:cityId success:nil failure:nil];
    [OrderRequest getPricingRuleByCityId:cityId success:nil failure:nil];
    
}

- (void)onUnReadMessage {
    NSInteger unRead = (self.unreadOrderMsgCount+self.unreadSystemMsgCount);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (unRead > 0) {
            [self.tabBar showBadgeOnItemIndex:3];
        } else {
            [self.tabBar hideBadgeOnItemIndex:3];
        }
    });
}


- (void)alertWithTitle:(NSString *)title message:(NSString *)message confirm:(void(^)(void))confirm {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmA = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirm) {
            confirm();
        }
    }];
    [alert addAction:confirmA];
    
    [self.selectedViewController presentViewController:alert animated:YES completion:nil];
}

- (void)addChildViewControllerWithName:(NSString *)name tabBarTitle:(NSString *)title tabBarImage:(NSString *)imageStr tabBarSelectImage:(NSString *)selectImage{
    
//    objc_allocateClassPair([UIViewController class], [name cStringUsingEncoding:NSASCIIStringEncoding], 0);
    UIViewController *vc = objc_msgSend(objc_getClass([name cStringUsingEncoding:NSASCIIStringEncoding]), sel_registerName("alloc"), sel_registerName("init"));
    BaseNavigationController *childVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    childVC.tabBarItem.title = title;
    childVC.tabBarItem.image = [[UIImage imageNamed:imageStr]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:childVC];
    
}


-(void)didScan {
    TabBarScanViewController *vc = [[TabBarScanViewController alloc] initWithScanType:2];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([tabBarController.viewControllers[2] isEqual:viewController]) {
        [self didScan];
        return NO;
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

}


- (void)skipViewController:(NSDictionary *)userInfo {
    
    __weak typeof(self) ws = self;
    if ([userInfo[@"PAGE"] isEqualToString:@"ORDERPAGE"]) { //跳转订单列表
        QPYTaskListContainerViewController *vc = [[QPYTaskListContainerViewController alloc] init];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ws.selectedViewController pushViewController:vc animated:YES];
        });
    } else if ([userInfo[@"PAGE"] isEqualToString:@"FEEDBACKPAGE"]) { //跳转反馈页面
        if (userInfo[@"PAGE_PARAMETER"]) {
            FeedbackViewController *vc = [[FeedbackViewController alloc] initWithOrderId:userInfo[@"PAGE_PARAMETER"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ws.selectedViewController pushViewController:vc animated:YES];
            });
        }

    } else if ([userInfo[@"PAGE"] isEqualToString:@"DEFAULTPAGE"]) { //跳转默认首页
        
//        if ([[MECUser currentUser] userId] == nil || [[[MECUser currentUser] userId] isEqualToString:@""]) {
//            //跳转登录
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [ws loginMaiMaiUI];
//            });
//
//        } else {
//            MECShopPreviewViewController *shop = [[MECShopPreviewViewController alloc] init];
//            [shop setValue:userInfo[@"order_id"] forKey:@"shopId"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [ws.selectedViewController pushViewController:shop animated:YES];
//            });
//
//        }
        
    }
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
