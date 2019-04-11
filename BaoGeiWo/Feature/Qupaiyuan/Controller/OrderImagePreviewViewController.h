//
//  OrderImagePreviewViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/8/23.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderImagePreviewViewController : BaseViewController

@property (nonatomic, assign, getter=isTake) BOOL take;
@property (nonatomic, assign, getter=isSend) BOOL send;
@property (nonatomic, assign, getter=isPreview) BOOL preview;
@property (nonatomic, copy) void(^uploadSuccess)(NSArray *imageUrls);

- (instancetype)initWithImageUrls:(NSArray *)imageUrls;
- (instancetype)initWithImageUrls:(NSArray *)imageUrls baggageId:(NSString *)baggageId orderId:(NSString *)orderId;

@end
