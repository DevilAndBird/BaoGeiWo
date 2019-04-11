//
//  GTOrderListModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/6/21.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTOrderBaggageModel : NSObject
@property (nonatomic, copy) NSString *baggageId;
@property (nonatomic, copy) NSString *baggageCode;
@end



@interface GTOrderListModel : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *baggageNumber;
@property (nonatomic, strong) NSArray *baggageList;
@property (nonatomic, copy) NSString *takeTime;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, copy) NSString *modifyTime;

@property (nonatomic, copy) NSString *channel;  //专车标志

@end
