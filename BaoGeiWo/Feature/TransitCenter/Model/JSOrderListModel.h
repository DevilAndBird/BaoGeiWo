//
//  JSOrderListModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/28.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSOrderBaggageModel : NSObject
@property (nonatomic, copy) NSString *baggageId;
@property (nonatomic, copy) NSString *baggageCode;
@end


@interface JSOrderListModel : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *baggageNumber;
@property (nonatomic, strong) NSArray *baggageList;
@property (nonatomic, copy) NSString *roleType;
@property (nonatomic, copy) NSString *arrivedTime;

@end
