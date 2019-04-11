//
//  TransitReceiveScanViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/9.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "ScanViewController.h"

@class BGWTransitCenter;
@class DeliveryManModel;

@interface TransitReceiveScanViewController : ScanViewController

- (instancetype)initWithTransitId:(BGWTransitCenter *)center orderArray:(NSArray *)orderArray;
- (instancetype)initWithDeliveryMan:(DeliveryManModel *)deliveryMan orderArray:(NSArray *)orderArray;

@end
