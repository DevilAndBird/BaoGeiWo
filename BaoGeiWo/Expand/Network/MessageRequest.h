//
//  MessageRequest.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(id error);

@interface MessageRequest : NSObject

+ (void)getUnreadMsgCountSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getMessageListWithType:(BGWMessageType)msgType success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)updateMsgIsReadWithMsgId:(NSString *)msgId msgType:(BGWMessageType)msgType success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
