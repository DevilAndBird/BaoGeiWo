//
//  OrderPricingRuleModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/10/26.
//  Copyright © 2018 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderGoldPricingRuleModel : NSObject

@property (nonatomic, copy) NSString *unitPrice;    //单价
@property (nonatomic, copy) NSString *overnightPrice; //过夜费
@property (nonatomic, copy) NSString *nightNum; //第几夜开始计算费用

@end


@interface OrderSpecialPricingRuleModel : NSObject

@property (nonatomic, assign) NSInteger startPrice;
@property (nonatomic, assign) NSInteger startDistance;
@property (nonatomic, assign) NSInteger perKmPrice;

@property (nonatomic, assign) NSInteger extraBagNum;
@property (nonatomic, assign) NSInteger extraBagPrice;

@end




@interface OrderPricingRuleModel : NSObject

@property (nonatomic, strong) OrderGoldPricingRuleModel *goldPricingRule;
@property (nonatomic, strong) OrderSpecialPricingRuleModel *specialPricingRule;

@end

NS_ASSUME_NONNULL_END
