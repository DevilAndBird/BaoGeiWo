//
//  OrderRequest.m
//  BaoGeiWo
//
//  Created by wb on 2018/5/8.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "OrderRequest.h"

#import "QPYOrderListModel.h"
#import "QPYOrderTaskListModel.h"
#import "OrderDetailModel.h"
#import "JSOrderListModel.h"
#import "GTOrderListModel.h"
#import "OrderPricingRuleModel.h"
#import "BGWAirportCounterModel.h"
#import "FeedbackListModel.h"

@implementation OrderRequest


#pragma mark- apporder

#pragma mark 获取订单任务数量
+ (void)getOrderTaskNumber:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [BGWRequestManager POST:API_GetOrderTaskNumber parameters:@{@"roleid":[BGWUser getCurrentUserId]} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark 获取订单任务列表
+ (void)getOrderTaskList:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [BGWRequestManager POST:API_GetOrderTaskList parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {

            NSArray *arr = [QPYOrderTaskGroupModel mj_objectArrayWithKeyValuesArray:responseObject];
//            NSArray *arr = [QPYOrderTaskListModel mj_objectArrayWithKeyValuesArray:responseObject];
            if (arr.count) {
                for (QPYOrderTaskGroupModel *group in arr) {
                    [group.taskGroup makeObjectsPerformSelector:@selector(realTaskType)];
                }
            }
            success(arr);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark 获取订单任务详情
+ (void)getOrderTaskDetail:(QPYOrderTaskListModel *)taskModel success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:taskModel.orderId forKey:@"orderid"];
    [self getOrderTaskDetailWithParameters:parameters success:success failure:failure];
}

+ (void)getOrderTaskDetailWithOrderId:(NSString *)orderId detailsType:(NSArray *)detailsType success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:orderId forKey:@"orderid"];
    [parameters setObject:detailsType forKey:@"queryDetailsType"];
    [self getOrderTaskDetailWithParameters:parameters success:success failure:failure];
}

+ (void)getOrderTaskDetailWithOrderNo:(NSString *)orderNo detailsType:(NSArray *)detailsType success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:orderNo forKey:@"orderno"];
    [parameters setObject:detailsType forKey:@"queryDetailsType"];
    [self getOrderTaskDetailWithParameters:parameters success:success failure:failure];
}

+ (void)getOrderTaskDetailWithFetchNo:(NSString *)fetchNo detailsType:(NSArray *)detailsType success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:fetchNo forKey:@"fetchno"];
    [parameters setObject:detailsType forKey:@"queryDetailsType"];
    [self getOrderTaskDetailWithParameters:parameters success:success failure:failure];
}

+ (void)getOrderTaskDetailWithBaggageId:(NSString *)baggageId detailsType:(NSArray *)detailsType success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:baggageId forKey:@"baggageid"];
    [parameters setObject:detailsType forKey:@"queryDetailsType"];
    [self getOrderTaskDetailWithParameters:parameters success:success failure:failure];
}

+ (void)getOrderTaskDetailWithParameters:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    [BGWRequestManager POST:API_GetOrderTaskDetail parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"%@", responseObject);
        if (success) {
            OrderDetailModel *orderDetail = [OrderDetailModel mj_objectWithKeyValues:responseObject];
            success(orderDetail);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark 查询订单列表
+ (void)getOrderListWithRoleActionType:(BGWRoleActionType)roleActionType actionStatus:(BGWRoleActionStatus)actionStatus destType:(BGWDestinationType)destType destId:(NSString *)destId orderStatus:(BGWOrderStatus)orderStatus success:(SuccessBlock)success failure:(FailureBlock)failure {
    [self getOrderListWithDeliveryManId:[BGWUser getCurrentUserId] roleActionType:roleActionType actionStatus:actionStatus destType:destType destId:destId orderStatus:orderStatus success:success failure:failure];
}

+ (void)getOrderListWithDeliveryManId:(NSString *)deliveryManId roleActionType:(BGWRoleActionType)roleActionType actionStatus:(BGWRoleActionStatus)actionStatus destType:(BGWDestinationType)destType destId:(NSString *)destId orderStatus:(BGWOrderStatus)orderStatus success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:deliveryManId forKey:@"roleid"];
    [parameters setObject:[self roleActionWithType:roleActionType] forKey:@"roletype"];
    [parameters setObject:[self destTypeWithType:destType] forKey:@"desttype"];
    [parameters setObject:destId forKey:@"destaddress"];
    [parameters setObject:[self roleActionStatusWithStatus:actionStatus] forKey:@"isfinish"];
    //    [parameters setObject:[self orderStatusWithStatus:orderStatus] forKey:@"status"];
    
    [BGWRequestManager POST:API_GetOrderList parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSArray *array = [QPYOrderListModel mj_objectArrayWithKeyValuesArray:responseObject];
            success(array);
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark 更新订单状态
+ (void)updateOrderStatue:(BGWOrderStatus)orderStatus orderId:(id)orderId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [parameters setObject:[self orderStatusWithStatus:orderStatus] forKey:@"status"];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];

    if ([orderId isKindOfClass:[NSArray class]]) {
        [parameters setObject:@"ORDERIDLIST" forKey:@"updateType"];
        [parameters setObject:orderId forKey:@"orderidList"];
        
    } else if ([orderId isKindOfClass:[NSString class]]) {
        [parameters setObject:@"ORDERID" forKey:@"updateType"];
        [parameters setObject:orderId forKey:@"id"];
        
    }
    
    [BGWRequestManager POST:API_UpdateOrderStatus parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if (success) {
            success(nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark 生成订单
+ (void)generateOrderWithStatue:(BGWOrderStatus)orderStatus orderId:(id)orderId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [parameters setObject:[self orderStatusWithStatus:orderStatus] forKey:@"status"];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];
    
    if ([orderId isKindOfClass:[NSArray class]]) {
        [parameters setObject:@"ORDERIDLIST" forKey:@"updateType"];
        [parameters setObject:orderId forKey:@"orderidList"];
        
    } else if ([orderId isKindOfClass:[NSString class]]) {
        [parameters setObject:@"ORDERID" forKey:@"updateType"];
        [parameters setObject:orderId forKey:@"id"];
        
    }
    
    [BGWRequestManager POST:API_GenerateOrder parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if (success) {
            success(nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        if (failure) {
            failure(error);
        }
    }];
    
}


#pragma mark 机场装车扫描
+ (void)getBaggageCountWithBagaggeId:(NSString *)baggageId roleActionType:(BGWRoleActionType)roleActionType actionStatus:(BGWRoleActionStatus)actionStatus destType:(BGWDestinationType)destType destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [parameters setObject:baggageId forKey:@"baggageid"];
    [parameters setObject:[self roleActionWithType:roleActionType] forKey:@"roletype"];
    [parameters setObject:[self destTypeWithType:destType] forKey:@"desttype"];
    [parameters setObject:destId forKey:@"destaddress"];
    [parameters setObject:[self roleActionStatusWithStatus:actionStatus] forKey:@"isfinish"];
    
    [BGWRequestManager POST:API_GetBaggageCount parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        NSLog(@"%@", responseObject);
        if (success) {
            success(responseObject[@"baggageNum"]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        if (failure) {
            failure(nil);
        }
    }];
    
}

#pragma mark 集散获取订单列表
+ (void)getJSOrderListWithType:(NSInteger)type success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSString *url;
    if (type == 1) {
        url = API_GetJSDepositOrderList;
    } else if (type == 2) {
        url = API_GetJSFinishOrderList;
    } else {
        return;
    }
    
    [BGWRequestManager POST:url parameters:@{@"destaddress":[BGWUser currentUser].userRole.userRoleId} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSArray *arr = [JSOrderListModel mj_objectArrayWithKeyValuesArray:responseObject];
            success(arr);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark 获取柜台订单列表
+ (void)getGTOrderListWithType:(BGWGTOrderType)type success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser currentUser].userRole.userRoleId forKey:@"airportid"];
    [parameters setObject:[NSString GTOrderType:type] forKey:@"ordertype"];

    [BGWRequestManager POST:API_GetGTOrderList parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSArray *arr = [GTOrderListModel mj_objectArrayWithKeyValuesArray:responseObject];
            success(arr);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark 用户确认收件签名
+ (void)SaveUserSignWithOrderId:(NSString *)orderId userName:(NSString *)userName userSign:(NSString *)userSign success:(SuccessBlock)success failure:(FailureBlock)failure {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:orderId forKey:@"id"];
    [parameters setObject:userName forKey:@"signname"];
    [parameters setObject:userSign forKey:@"signurl"];

    [BGWRequestManager POST:API_SaveUserSign parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark 获取地图信息列表
+ (void)getMapTaskList:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [BGWRequestManager POST:API_GetMapTaskList parameters:@{@"roleid":[BGWUser getCurrentUserId]} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            NSLog(@"%@", responseObject);
            NSArray *arr = [QPYOrderTaskListModel mj_objectArrayWithKeyValuesArray:responseObject];
            if (arr.count) {
                [arr makeObjectsPerformSelector:@selector(realTaskType)];
            }
            success(arr);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark 查询柜台下单计价规则
+ (void)getPricingRuleByCityId:(NSString *)cityId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameter setObject:cityId forKey:@"cityid"];
    [BGWRequestManager POST:API_GetPricingRule parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);

        OrderPricingRuleModel *pricingRule = [OrderPricingRuleModel mj_objectWithKeyValues:responseObject];
        [BGWUser currentUser].orderPricingRule = pricingRule;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark 删除未支付订单
+ (void)deleteUnpaidOrderByOrderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [BGWRequestManager POST:API_GTDeleteUnpaidOrder parameters:@{@"orderid" : orderId} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
#pragma mark 更改订单支付状态
+ (void)updatePaidOrderByOrderNo:(NSString *)orderNo success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    [BGWRequestManager POST:API_GTUpdatePaidOrder parameters:@{@"orderno":orderNo} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}




#pragma mark - appdm
#pragma mark 确认发车
+ (void)confirmDriverStartedWithTaskListModel:(QPYOrderTaskListModel *)taskModel success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSArray *taskIdArr = @[taskModel.orderId];
    NSString *roleType = taskModel.roleType;
    
    [self confirmDriverStartedWithTaskIdArr:taskIdArr roleType:roleType success:success failure:failure];
}

+ (void)confirmDriverStartedWithTaskGroup:(QPYOrderTaskGroupModel *)groupModel success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableArray *taskIdArr = [NSMutableArray arrayWithCapacity:0];
    for (QPYOrderTaskListModel *taskModel in groupModel.taskGroup) {
        [taskIdArr addObject:taskModel.orderId];
    }
    NSString *roleType = ((QPYOrderTaskListModel *)[groupModel.taskGroup firstObject]).roleType;
    
    [self confirmDriverStartedWithTaskIdArr:taskIdArr roleType:roleType success:success failure:failure];
}

+ (void)confirmDriverStartedWithTaskIdArr:(NSArray *)taskIdArr roleType:(NSString *)roleType success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:taskIdArr forKey:@"orderidList"];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];
    [parameters setObject:roleType forKey:@"roletype"];
    
    [BGWRequestManager POST:API_ConfirmDriverStarted parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark 即将到达
#pragma mark 确认到达
+ (void)confirmDriverStatus:(BGWOrderDriverStatus)driverStatus taskListModel:(QPYOrderTaskListModel *)taskModel success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];
    [parameters setObject:taskModel.roleType forKey:@"roletype"];
    [parameters setObject:taskModel.isFinish forKey:@"isfinish"];
    [parameters setObject:taskModel.destAddressType forKey:@"desttype"];
    [parameters setObject:taskModel.destAddressId forKey:@"destaddress"];
    
    NSString *api;
    if (driverStatus == BGWOrderDriverStatusArriving) {
        api = API_ConfirmDriverArriving;
    } else if (driverStatus == BGWOrderDriverStatusArrived) {
        api = API_ConfirmDriverArrived;
    }
    
    [BGWRequestManager POST:api parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark 通知客户
+ (void)notifyAppCusWithOrderId:(NSString *)orderId roleType:(NSString *)roleType success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];
    [parameters setObject:orderId forKey:@"id"];
    [parameters setObject:roleType forKey:@"roletype"];
    
    [BGWRequestManager POST:API_NotifyAppCus parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark 确认取件
+ (void)confirmTakeOrderWithOrderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];
    [parameters setObject:orderId forKey:@"orderid"];
    
    [BGWRequestManager POST:API_ConfirmTakeOrder parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
}

#pragma mark 确认派件
+ (void)confirmSendOrderWithOrderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];
    [parameters setObject:orderId forKey:@"orderid"];
    
    [BGWRequestManager POST:API_ConfirmSendOrder parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
}




#pragma mark- userdelivery

#pragma mark 集散中心获取装车扫描qr码列表
+ (void)getDeliveryScanListWithUserId:(NSString *)userId destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:userId forKey:@"roleid"];
    [parameters setObject:@"ROLE_TRANSIT_TASK" forKey:@"roletype"];
    [parameters setObject:@"ONGOING" forKey:@"isfinish"];
    [parameters setObject:@"TRANSITCERTER" forKey:@"desttype"];
    [parameters setObject:destId forKey:@"destaddress"];
    
    [BGWRequestManager POST:API_PreLoadingScan parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark 机场/服务中心装车完毕
+ (void)serviceCenterLoadDoneWithIdArray:(NSArray *)orderIdArray destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];
    [parameters setObject:orderIdArray forKey:@"orderidList"];
    [parameters setObject:destId forKey:@"destaddress"];
    
    [BGWRequestManager POST:API_ServiceCenterLoadDone parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if (success) {
            success(nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        if (failure) {
            failure(nil);
        }
    }];
    
}

#pragma mark 集散中心装车扫描
+ (void)deliveryScanWithQRNumber:(NSString *)qrNumber success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:qrNumber forKey:@"baggageid"];
    
    [BGWRequestManager POST:API_DeliveryScan parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
}

#pragma mark 集散中心装车完毕
+ (void)transitCenterLoadDoneWithIdArray:(NSArray *)orderIdArray destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"roleid"];
    [parameters setObject:orderIdArray forKey:@"orderidList"];
    [parameters setObject:destId forKey:@"destaddress"];
    
    [BGWRequestManager POST:API_TranistCenterLoadDone parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}


#pragma mark- appOrderBaggage
#pragma mark 行李是否扫描通过
+ (void)baggageIsScanWithOrderId:(NSString *)orderId qrNumber:(NSString *)qrNumber success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:orderId forKey:@"orderid"];
    [parameters setObject:qrNumber forKey:@"baggageid"];
    [parameters setObject:@"1" forKey:@"isscan"];
    
    [BGWRequestManager POST:API_BaggageIsScan parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
        
    }];
}

#pragma mark qr码是否可用
+ (void)queryQRCodeIsUseful:(NSString *)qrCode success:(SuccessBlock)success failure:(FailureBlock)failure {
    [BGWRequestManager POST:API_ScanQRCode parameters:@{@"baggageid":qrCode} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark qr码关联订单
+ (void)saveOrderBaggageWithQRCode:(NSString *)qrCode orderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:qrCode forKey:@"baggageid"];
    [parameters setObject:orderId forKey:@"orderid"];
    
    [BGWRequestManager POST:API_SaveOrderBaggage parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark 图片关联行李、订单
+ (void)baggageImageUploadWithImageUrl:(NSString *)imageUrl baggageId:(NSString *)baggageId orderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:orderId forKey:@"orderid"];
    [parameters setObject:baggageId forKey:@"baggageid"];
    [parameters setObject:imageUrl forKey:@"imgurl"];
    
    [BGWRequestManager POST:API_BaggageImageUpload parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

+ (void)baggageImageUploadWithImageUrls:(NSArray *)imageUrls imageType:(NSString *)imageType baggageId:(NSString *)baggageId orderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:orderId forKey:@"orderid"];
    [parameters setObject:baggageId forKey:@"baggageid"];
    [parameters setObject:imageType forKey:@"imgtype"];
    [parameters setObject:imageUrls forKey:@"imgurlList"];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"uploadUserid"];
    
    [BGWRequestManager POST:API_BaggageImageUpload parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}


#pragma mark- appCounterService
#pragma mark 柜台确认交接（取派员卸车)
//机场柜台确认交接（卸车）
+ (void)serviceCenterUnloadDoneWithIdArray:(NSArray *)orderIdArray deliveryId:(NSString *)deliveryId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:deliveryId forKey:@"unloadBeforeRoleid"];
    [parameters setObject:orderIdArray forKey:@"orderidList"];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"unloadLaterRoleid"];
    [parameters setObject:[BGWUser currentUser].userRole.userRoleId forKey:@"destaddress"];
    
    [BGWRequestManager POST:API_ServiceCenterUnloadDone parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark 集散中心确认交接（取派员卸车）
//集散中心确认交接（取派员卸车）
+ (void)transitCenterUnloadDoneWithIdArray:(NSArray *)orderIdArray deliveryId:(NSString *)deliveryId success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:deliveryId forKey:@"unloadBeforeRoleid"];
    [parameters setObject:orderIdArray forKey:@"orderidList"];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"unloadLaterRoleid"];
    [parameters setObject:[BGWUser currentUser].userRole.userRoleId forKey:@"destaddress"];
    
    [BGWRequestManager POST:API_TransitCenterUnloadDone parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
        
    }];
    
}

#pragma mark 获取卸车扫描数据（判断是否可以进入扫描页）
+ (void)transitCenterUnloadScanWithDeliveryId:(NSString *)deliveryId destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:deliveryId forKey:@"roleid"];
    [parameters setObject:@"ROLE_TRANSIT_SEND" forKey:@"roletype"];
    [parameters setObject:@"ONGOING" forKey:@"isfinish"];
    [parameters setObject:@"TRANSITCERTER" forKey:@"desttype"];
    [parameters setObject:destId forKey:@"destaddress"];

    [BGWRequestManager POST:API_TransitUnloadScan parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}




#pragma mark- orderFeedback
#pragma mark 订单反馈
+ (void)orderFeedbackWithOrderId:(NSString *)orderId content:(NSString *)content success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:orderId forKey:@"orderid"];
    [parameters setObject:content forKey:@"feedbackdesc"];
    [parameters setObject:[BGWUser getCurremtUserName] forKey:@"feedbackusername"];
    [parameters setObject:[BGWUser currentUser].mobile forKey:@"feedbackusermobile"];
    [parameters setObject:[BGWUser getCurrentUserId] forKey:@"feedbackuserid"];
    
    [BGWRequestManager POST:API_OrderFeedback parameters:@{@"problemOrder":parameters} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@", responseObject);
        if (success) {
            success(@"问题成功反馈!");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
}


#pragma mark 反馈列表
+ (void)GetFeedbackListWithOrderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:orderId forKey:@"orderid"];
    //orderid 3541  JPWX20180817151221619
    [BGWRequestManager POST:API_GetFeedbackList parameters:@{@"problemOrder":parameters} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@", responseObject);
        if (success) {
            NSArray *list = [FeedbackListModel mj_objectArrayWithKeyValuesArray:responseObject[@"problemOrderList"]];
            success(list);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(nil);
        }
    }];
    
}




#pragma mark-

+ (NSString *)roleActionWithType:(BGWRoleActionType)type {
    NSArray *roleActionTypes = @[@"ROLE_HOTEL_TASK", @"ROLE_HOTEL_SEND", @"ROLE_TRANSIT_TASK", @"ROLE_TRANSIT_SEND", @"ROLE_AIRPORT_TASK", @"ROLE_AIRPORT_SEND", @"ROLE_ARRIVE_HOTEL", @"ROLE_ARRIVE_TRANSIT", @"ROLE_ARRIVE_AIRPORT"];
    return roleActionTypes[type];
}

+ (NSString *)roleActionStatusWithStatus:(BGWRoleActionStatus)status {
    NSArray *roleActionStatus = @[@"UNFINISHED", @"ONGOING", @"FINISHED"];
    return roleActionStatus[status];
}

+ (NSString *)destTypeWithType:(BGWDestinationType)type {
    NSArray *destTypes = @[@"SERVICECERTER", @"TRANSITCERTER", @"HOTELOROTHER"];
    return destTypes[type];
}

+ (NSString *)orderStatusWithStatus:(BGWOrderStatus)status {
    NSArray *temp = @[@"WAITPAY", @"PREPAID", @"WAITPICK", @"TAKEGOOGSING", @"TAKEGOOGSOVER", @"WAITORDERRECEIVING", @"ORDERRECEIVINGOVER", @"WAITTRUCELOADING", @"TRUCELOADINGOVER", @"TRANSFEROVER", @"ARRIVEAIRPORT", @"RELEASEOVER", @"ALLOTDELIVERY", @"DELIVERYING", @"DELIVERYOVER", @"WAITINGUNLOAD", @"UNLOAD", @"TROUBLE_DEAL",];
    return temp[status];
}


@end
