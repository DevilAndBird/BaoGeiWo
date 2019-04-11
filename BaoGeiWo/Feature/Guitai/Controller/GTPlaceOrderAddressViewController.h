//
//  GTPlaceOrderAddressViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/10/23.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GTPlaceOrderAddressDelegate <NSObject>

@optional
- (void)selectAddress:(NSString *)address landmark:(NSString *)landmark coordinate:(NSString *)coordinate district:(NSString *)district township:(NSString *)township;

@end



@interface GTPlaceOrderAddressViewController : BaseViewController

@property (nonatomic, weak) id<GTPlaceOrderAddressDelegate> delegate;

- (instancetype)initWithCityName:(NSString *)city;

@property (nonatomic, copy) void(^addressInfo)(NSString *address, NSString *landmark, NSString *coordinate, NSString *district, NSString *township);

@end

NS_ASSUME_NONNULL_END
