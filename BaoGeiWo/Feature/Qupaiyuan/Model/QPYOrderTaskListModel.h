//
//  QPYOrderTaskListModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/11.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTaskBaggageModel : NSObject

@property (nonatomic, copy) NSString *baggageQRNumber;
@property (nonatomic, copy) NSString *baggageId;
@property (nonatomic, copy) NSString *baggageImageUrl;
@property (nonatomic, strong) UIImage *image;

@end

@interface OrderTaskNextBindAction : NSObject

@property (nonatomic, copy) NSString *arrivedTime;

//@property (nonatomic, copy) NSString *srcAddress;
//@property (nonatomic, copy) NSString *srcAddressDesc;

@property (nonatomic, copy) NSString *destAddressId;
@property (nonatomic, copy) NSString *destAddressType;
@property (nonatomic, copy) NSString *destAddress;
@property (nonatomic, copy) NSString *destAddressDesc;

@end

@interface OrderTaskDestAddressCoordinate : NSObject

@property (nonatomic, copy) NSString *latitudeStr;
@property (nonatomic, copy) NSString *longitudeStr;

@end


@interface QPYOrderTaskListModel : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *channel;  //是否专车  weixin_sc:zhuanche  weixin_gs:putong
@property (nonatomic, copy) NSString *isToday;  //是否隔夜件  Y:否  N:是

@property (nonatomic, copy) NSString *srcMailingWay;
@property (nonatomic, copy) NSString *destMailingWay;
@property (nonatomic, copy) NSString *srcPhone;
@property (nonatomic, copy) NSString *destPhone;

@property (nonatomic, copy) NSString *destAddressId;
@property (nonatomic, copy) NSString *destAddressType;
@property (nonatomic, copy) NSString *destAddress;
@property (nonatomic, copy) NSString *destAddressDesc;
@property (nonatomic, strong) OrderTaskNextBindAction *nextBindAction;

@property (nonatomic, copy) NSString *takeTime;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, copy) NSString *currentTime;
@property (nonatomic, copy) NSString *arrivedTime;
@property (nonatomic, copy) NSString *isArrived; //是否抵达
@property (nonatomic, copy) NSString *isTake;   //柜台是否取件

@property (nonatomic, strong) OrderTaskDestAddressCoordinate *addressCoordinate;

@property (nonatomic, copy) NSString *baggageNumber;

@property (nonatomic, copy) NSString *travelStatus;

@property (nonatomic, strong) NSArray *orderBaggageArray;


@property (nonatomic, copy) NSString *roleType;
@property (nonatomic, copy) NSString *isFinish;

@property (nonatomic, assign) BGWOrderTaskType taskType; //全部列表里每一项具体分类(根据roletype和isfinish设置)


- (void)realTaskType;

@end


@interface QPYOrderTaskGroupModel : NSObject

@property (nonatomic, strong) NSArray *taskGroup;

@end



