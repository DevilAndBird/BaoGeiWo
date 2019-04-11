//
//  AppDelegate.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/2.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "LoginViewController.h"
#import "BGWLocationManager.h"

#import "AliyunOSSService.h"
#import "MessageRequest.h"

#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AipOcrSdk/AipOcrSdk.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#define JPush_app_key @"63c67b6484dc98965390759a"
#define JPush_channel @"app store"

#define AMapKey @"1831b82ac3e1f6bb1e023b29628dd94b"

@interface AppDelegate ()<JPUSHRegisterDelegate, BMKGeneralDelegate>

@property (nonatomic, strong) BGWLocationManager *locationManager;
@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


- (void)loginBGWUI {
    [BGWUser removeUserInfoFromUserDefaults];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBGWLogoutSuccessNotification object:nil];
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.dismissBlock = ^{
        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    };
    [self.tabBarController presentViewController:vc animated:YES completion:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    
    // Required
    // init Push
#if BGW_ENVIRONMENT
    [JPUSHService setupWithOption:launchOptions appKey:JPush_app_key
                          channel:JPush_channel
                 apsForProduction:YES
            advertisingIdentifier:nil];
#else
    [JPUSHService setupWithOption:launchOptions appKey:JPush_app_key
                          channel:JPush_channel
                 apsForProduction:NO
            advertisingIdentifier:nil];
#endif
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    //    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:RGBA(0, 0, 0, 0.2)];
    [SVProgressHUD setForegroundColor:kMBlackColor];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumSize:CGSizeMake(70, 70)];
    
    // aip-ocr
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    BOOL ret = [_mapManager start:@"wSSX7Tv6H02T7trQx6U3aW57PHoB21jq" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    [[AMapServices sharedServices] setApiKey:AMapKey];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountLoginSuccess:) name:kBGWLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountLogoutSuccess:) name:kBGWLogoutSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserPushTag:) name:kBGWNotificationSettingChangeNotification object:nil];
    
    
    [self setupRootUI];
    
    
    return YES;
}


- (void)setupRootUI {
    if ([[BGWUser currentUser] userId]) {
        BaseTabBarController *vc = [[BaseTabBarController alloc] init];
        self.window.rootViewController = vc;
        self.tabBarController = vc;
        
        [self setUserPushTag:nil];
        [self getUnreadMsgCount];
        [self startLocation];
    } else {
        LoginViewController *vc = [[LoginViewController alloc] init];
        self.window.rootViewController = vc;
    }
    
    [self.window makeKeyWindow];
}


- (void)getUnreadMsgCount {
    [MessageRequest getUnreadMsgCountSuccess:^(id responseObject) {
        
        self.tabBarController.unreadSystemMsgCount = [responseObject[@"unreadSystemCount"] integerValue];
        self.tabBarController.unreadOrderMsgCount = [responseObject[@"unreadOrderCount"] integerValue];
    } failure:^(id error) {
        //
    }];
}

- (void)accountLoginSuccess:(NSNotification *)sender {
    [self setUserPushTag:sender];
    [self getUnreadMsgCount];
    [self startLocation];
}

- (void)accountLogoutSuccess:(NSNotification *)sender {
    [self resetsetUserPushTag:sender];
    self.tabBarController.unreadOrderMsgCount = self.tabBarController.unreadSystemMsgCount = 0;
    [[BGWLocationManager shareLocationManager] stopLocation];
}


#pragma mark- JPUSH
- (void)setUserPushTag:(NSNotification *)notification {
    NSString *aliaPrefix;
#if BGW_ENVIRONMENT
    aliaPrefix = @"prd_userid@";
#else
    aliaPrefix = @"test_userid@";
#endif
    [JPUSHService setAlias:[aliaPrefix stringByAppendingString:[BGWUser getCurrentUserId]] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (!iResCode) {
            NSLog(@"set alias success: %@", iAlias);
        }
    } seq:0];
}
- (void)resetsetUserPushTag:(NSNotification *)notification {
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        if (!iResCode) {
            NSLog(@"delete alias success");
        }
    } seq:0];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
}


- (void)startLocation {
    
#if DEBUG
//    if ([BGWUser getCurremtUserType] == AppUserTypeDeliveryMan) {
//        [[BGWLocationManager shareLocationManager] startLocation];
//    }
#else
    if ([BGWUser getCurremtUserType] == AppUserTypeDeliveryMan) {
        [[BGWLocationManager shareLocationManager] startLocation];
    }
#endif

        //判断定位权限
//        if([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusDenied) {
//            POPUPINFO(@"应用不可以定位，需要在设置中开启");
//        } else if ([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusRestricted) {
//            POPUPINFO(@"设备不可以定位");
//        } else {
//            [[BGWLocationManager shareLocationManager] startLocation];
//        }
//    CLLocationManager *location = [[CLLocationManager alloc]init];
//    location.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//导航级别的精确度
//    location.allowsBackgroundLocationUpdates = YES; //允许后台刷新
//    location.pausesLocationUpdatesAutomatically = NO; //不允许自动暂停刷新
//    location.distanceFilter = kCLDistanceFilterNone;  //不需要移动都可以刷新
//    location.delegate = self;
//    [location startUpdatingLocation];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [JPUSHService resetBadge];
    if ([BGWUser getCurrentUserId]) {
        [self getUnreadMsgCount];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [JPUSHService resetBadge];
    [self getUnreadMsgCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBGWNewOrderNotification object:nil];
    
    completionHandler(UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [self getUnreadMsgCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBGWNewOrderNotification object:nil];
//    NSLog(@"userinfo---%@", userInfo);
    [self.tabBarController skipViewController:userInfo];

    completionHandler();  // 系统要求执行这个方法
}
#pragma clang diagnostic pop

//static SystemSoundID soundID = 0;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    if (application.applicationState == UIApplicationStateActive) {
        //
        [JPUSHService resetBadge];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//        NSDictionary *aps = [userInfo valueForKey:@"aps"];
//        NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//        NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//        NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
        // 取得Extras字段内容
//        NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
//        NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
        
//        NSArray *arr = [sound componentsSeparatedByString:@"."];
//        NSString *str = [[NSBundle mainBundle] pathForResource:[arr firstObject] ofType:[arr lastObject]];
//        NSURL *url = [NSURL fileURLWithPath:str];
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
//        AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
//            NSLog(@"播放完成");
//        });
    } else {
        [self.tabBarController skipViewController:userInfo];
    }

    [self getUnreadMsgCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBGWNewOrderNotification object:nil];

    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}





@end
