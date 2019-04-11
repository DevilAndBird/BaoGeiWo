//
//  QPYDeliverViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/7.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaseViewController.h"
#import "BGWTransitCenter.h"

@interface QPYOrderListViewController : BaseViewController


- (instancetype)initWithTransitCenter:(BGWTransitCenter *)transitCenter cityNodeType:(BGWCityNodeType)cityNodeType;


@end
