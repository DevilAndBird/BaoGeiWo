//
//  BGWLocationManager.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/23.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BGWLocationManager.h"
#import <CoreLocation/CLLocationManager.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "CommonRequest.h"

@interface BGWLocationManager()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) NSTimeInterval lastUpdateTime;


@end

@implementation BGWLocationManager

static BGWLocationManager *instance = nil;
static NSTimeInterval interval = 60;


+ (instancetype)shareLocationManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BGWLocationManager alloc] init];
    });
    return instance;
}


//开启服务
- (void)startLocation {
    NSLog(@"开启定位");
    
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"用户尚未进行选择");
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
                break;
            case kCLAuthorizationStatusRestricted:
                NSLog(@"定位权限被限制");
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"用户允许定位");
                if ([self.locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
                    self.locationManager.allowsBackgroundLocationUpdates = YES;
                }
                [self.locationManager startUpdatingLocation];

                break;
            case kCLAuthorizationStatusDenied:
                NSLog(@"用户不允许定位");
                break;
                
            default:
                break;
        }
    }
}

- (void)stopLocation
{
//    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
}

- (void)openMap:(NSString *)string destination:(CLLocationCoordinate2D )coordinate destinationName:(NSString *)name {
    NSString *urlString;
    
    //baidu坐标
    CLLocationCoordinate2D saddr = self.currentCoordinate;
    CLLocationCoordinate2D daddr = coordinate;
    
    NSLog(@"baidu coor----%f,%f\n%f,%f", saddr.latitude, saddr.longitude, daddr.latitude, daddr.longitude);

    
    if ([string isEqualToString:@"百度地图"]) {
        urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=name:当前位置|latlng:%f,%f&destination=name:%@|latlng:%f,%f&mode=driving", saddr.latitude, saddr.longitude, name, daddr.latitude, daddr.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
    } else if ([string isEqualToString:@"高德地图"]) {
        
        CLLocationCoordinate2D scoor = BMKCoordTrans(saddr, BMK_COORDTYPE_BD09LL, BMK_COORDTYPE_COMMON);
        CLLocationCoordinate2D dcoor = BMKCoordTrans(daddr, BMK_COORDTYPE_BD09LL, BMK_COORDTYPE_COMMON);
//        NSLog(@"gaode coor----%f,%f\n%f,%f", scoor.latitude, scoor.longitude, dcoor.latitude, dcoor.longitude);

        urlString = [[NSString stringWithFormat:@"http://uri.amap.com/navigation?from=%f,%f,当前位置&to=%f,%f,%@&mode=car&policy=1&callnative=1", scoor.longitude, scoor.latitude, dcoor.longitude, dcoor.latitude, name] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
    } else if ([string isEqualToString:@"苹果地图"]) {
        
        CLLocationCoordinate2D scoor = BMKCoordTrans(saddr, BMK_COORDTYPE_BD09LL, BMK_COORDTYPE_COMMON);
        CLLocationCoordinate2D dcoor = BMKCoordTrans(daddr, BMK_COORDTYPE_BD09LL, BMK_COORDTYPE_COMMON);
//        NSLog(@"apple coor----%f,%f\n%f,%f", scoor.latitude, scoor.longitude, dcoor.latitude, dcoor.longitude);
        
        urlString = [[NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f", scoor.latitude, scoor.longitude, dcoor.latitude, dcoor.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}





- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户尚未进行选择");
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"定位权限被限制");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"用户允许定位");
            [self startLocation];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"用户不允许定位");
            break;
            
        default:
            break;
    }
}

static int i = 0;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (![self canUpload]) return;
    
    CLLocation *loc = locations.firstObject;
    
    NSLog(@"----- i = %d, 维度: %f, 经度: %f", i++, loc.coordinate.latitude, loc.coordinate.longitude);
    
    [self uploadLocation:loc.coordinate];
}


- (BOOL)canUpload
{
    CFTimeInterval t = CACurrentMediaTime();
    if (t - self.lastUpdateTime > interval) {
        self.lastUpdateTime = t;
        return YES;
    }
    return NO;
}

- (void)uploadLocation:(CLLocationCoordinate2D)coor
{
 
//    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(39.90868, 116.3956);//原始坐标
    
    //转换国测局坐标（google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标）至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
    //转换WGS84坐标至百度坐标(加密后的坐标)
    testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_GPS);
    
    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
    //解密加密后的坐标字典
    
    CLLocationCoordinate2D baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标
    self.currentCoordinate = baiduCoor;
    
    NSDictionary *parameters = @{@"lng" : @(baiduCoor.longitude),
                                 @"lat" : @(baiduCoor.latitude),
                                 };
    [CommonRequest updateDeliveryManCurrentLocation:[parameters mj_JSONString]];
    
//    BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc] init];
//    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
//    option.reverseGeoPoint = baiduCoor;
//    search.delegate = self;
//    [search reverseGeoCode:option];
    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //上传定位
//    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (!error) {
//            NSLog(@"请求百度成功 %d", i);
//        } else {
//            NSLog(@"请求百度失败 %d", i);
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadSuc" object:nil userInfo:@{@"message": !error?[NSString stringWithFormat:@"请求百度成功 %d", i]:[NSString stringWithFormat:@"请求百度失败 %d", i]}];
//    }];
//    [task resume];
}


//- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
//
//
//    NSLog(@"cityCode:%@, %@, %@, %@", result.addressDetail.province, result.addressDetail.adCode, result.addressDetail.district, result.addressDetail.streetName);
//}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];

        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        
        _locationManager.delegate = self;

    }
    return _locationManager;
}


@end
