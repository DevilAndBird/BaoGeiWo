//
//  MessageRequest.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/25.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "MessageRequest.h"
#import "MessageModel.h"


@implementation MessageRequest


#pragma mark 获取未读消息条数
+ (void)getUnreadMsgCountSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [BGWRequestManager POST:API_GetUnreadMsgCount parameters:@{@"userid":[BGWUser getCurrentUserId]} success:^(NSURLSessionDataTask *task, id responseObject) {
        /*
         appPushNumlist =     (
         {
         count = 15;
         type = SYSTEMMSG;
         }
         );
         */
        NSLog(@"%@", responseObject);
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:0];
        for (NSDictionary *dic in responseObject[@"appPushNumlist"]) {
            if ([dic[@"type"] isEqualToString:@"SYSTEMMSG"]) {
                [result setObject:dic[@"count"] forKey:@"unreadSystemCount"];
            } else if ([dic[@"type"] isEqualToString:@"ORDERMSG"]) {
                [result setObject:dic[@"count"] forKey:@"unreadOrderCount"];
            }
        }
        if (success) {
            success(result);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}

#pragma mark 获取消息列表
+ (void)getMessageListWithType:(BGWMessageType)msgType success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"userid"];
    [parameters setObject:[NSString msgType:msgType] forKey:@"type"];
    
    [BGWRequestManager POST:API_GetMsgList parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSArray *arr = [MessageModel mj_objectArrayWithKeyValuesArray:responseObject[@"pushInfoList"]];
            success(arr);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark 更新消息为已读
+ (void)updateMsgIsReadWithMsgId:(NSString *)msgId msgType:(BGWMessageType)msgType success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"userid"];
    [parameters setObject:@"1" forKey:@"isread"];
    if (msgId) {
        [parameters setObject:msgId forKey:@"id"];
    }
    if (msgType != BGWMessageTypeAll) {
        [parameters setObject:[NSString msgType:msgType] forKey:@"type"];
    }
    
    [BGWRequestManager POST:API_UpdateMsgIsRead parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
    }];
    
}



@end
