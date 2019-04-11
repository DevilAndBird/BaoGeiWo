//
//  BGWAirportCounterModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/10/26.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGWAirportCounterModel : NSObject

//@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *counterId;
@property (nonatomic, copy) NSString *counterName;
@property (nonatomic, copy) NSString *counterRemark;
@property (nonatomic, strong) NSString *counterCoordinate;

@end

NS_ASSUME_NONNULL_END
