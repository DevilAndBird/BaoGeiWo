//
//  QPYOrderListModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/8.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPYQRNumerModel : NSObject

@property (nonatomic, copy) NSString *QRNumberId;
@property (nonatomic, copy) NSString *QRNumber;

@end



@interface QPYOrderListModel : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *personName;
@property (nonatomic, copy) NSString *baggageNumber;
@property (nonatomic, strong) NSArray *QRNumbers;

@end
