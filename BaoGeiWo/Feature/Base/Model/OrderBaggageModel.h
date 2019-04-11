//
//  OrderBaggageModel.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/17.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderBaggageImageModel : NSObject

@property (nonatomic, strong) NSArray *takeImageUrls;
@property (nonatomic, strong) NSArray *sendImageUrls;

@end

@interface OrderBaggageModel : NSObject

@property (nonatomic, copy) NSString *baggageId;
@property (nonatomic, copy) NSString *baggageQRCode;
@property (nonatomic, strong) OrderBaggageImageModel *baggageImage;
@property (nonatomic, strong) UIImage *image;

@end

//@interface OrderBaggageModel : NSObject
//
//@property (nonatomic, copy) NSString *baggageId;
//@property (nonatomic, copy) NSString *baggageQRCode;
//@property (nonatomic, copy) NSString *baggageImageUrl;
//@property (nonatomic, strong) UIImage *image;
//
//
//@end
