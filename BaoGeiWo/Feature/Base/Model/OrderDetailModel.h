//
//  OrderDetailModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderBaggageModel.h"

@interface OrderDetailAddressModel : NSObject
@property (nonatomic, copy) NSString *srcAddressMark;
@property (nonatomic, copy) NSString *srcAddress;
@property (nonatomic, copy) NSString *destAddressMark;
@property (nonatomic, copy) NSString *destAddress;
@end

@interface OrderDetailBaggageModel : NSObject
@property (nonatomic, copy) NSString *baggageId;
@property (nonatomic, copy) NSString *baggageQRCode;
@property (nonatomic, copy) NSString *baggageImageUrl;
@property (nonatomic, strong) UIImage *image;
@end

@interface OrderDetailNotesModel : NSObject
@property (nonatomic, copy) NSString *notes;
@end


@interface OrderDetailCusInfoModel : NSObject
@property (nonatomic, copy) NSString *IDNumber;
@end


@interface OrderDetailFlightModel : NSObject
@property (nonatomic, copy) NSString *flightNo;
@end

@interface OrderDetailPriceDetailModel : NSObject
@property (nonatomic, strong) NSDictionary *priceList;
@property (nonatomic, copy) NSString *safetyPrice;
@property (nonatomic, copy) NSString *extraPrice;
@property (nonatomic, copy) NSString *totalPrice;
@end



@interface OrderDetailModel : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *orderStatus; //状态
@property (nonatomic, copy) NSString *orderType; //类型

@property (nonatomic, copy) NSString *srcMailingWay;
@property (nonatomic, copy) NSString *destMailingWay;
@property (nonatomic, copy) NSString *srcPhone;
@property (nonatomic, copy) NSString *destPhone;
@property (nonatomic, copy) NSString *srcName;
@property (nonatomic, copy) NSString *destName;

@property (nonatomic, copy) NSString *takeTime;
@property (nonatomic, copy) NSString *sendTime;

@property (nonatomic, copy) NSString *baggageNumber;

@property (nonatomic, copy) NSString *flightNo; //航班号

@property (nonatomic, strong) OrderDetailCusInfoModel *cusInfo;
@property (nonatomic, strong) OrderDetailAddressModel *orderAddress;
@property (nonatomic, strong) NSArray *orderBaggages;
@property (nonatomic, strong) NSArray *orderNotes;
@property (nonatomic, strong) OrderDetailPriceDetailModel *priceDetail;
//@property (nonatomic, strong) OrderDetailFlightModel *orderFlight;

@end
