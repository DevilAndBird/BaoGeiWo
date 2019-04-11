//
//  GTPlaceOrderScanPersonInfoViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/10/24.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import "ScanViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GTPlaceOrderScanPersonInfoViewController : ScanViewController

@property (nonatomic, copy) void(^getPersonInfo)(NSString *name, NSString *number);

@end

NS_ASSUME_NONNULL_END
