//
//  BGWLocationManager.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/23.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGWLocationManager : NSObject

//百度坐标
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;

+ (instancetype)shareLocationManager;
- (void)startLocation;
- (void)stopLocation;

- (void)openMap:(NSString *)string destination:(CLLocationCoordinate2D )coordinate destinationName:(NSString *)name;

@end
