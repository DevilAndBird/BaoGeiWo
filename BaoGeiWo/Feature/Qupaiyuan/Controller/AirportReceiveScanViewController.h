//
//  AirportReceiveScanViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "ScanViewController.h"

@class BGWTransitCenter;
@class DeliveryManModel;

@interface AirportReceiveScanViewController : ScanViewController

//柜台 -> 取派员
- (instancetype)initWithAirportId:(BGWTransitCenter *)center orderArray:(NSArray *)orderArray;

//取派员 -> 柜台
- (instancetype)initWithDeliveryMan:(DeliveryManModel *)deliveryMan orderArray:(NSArray *)orderArray;

@end
