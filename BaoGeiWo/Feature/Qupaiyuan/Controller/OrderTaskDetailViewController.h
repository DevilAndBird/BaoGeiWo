//
//  OrderTaskDetailViewController.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/14.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import "BaseViewController.h"

@class QPYOrderTaskListModel;

typedef void(^ComfirmBlock)(void);

@interface OrderTaskDetailViewController : BaseViewController

@property (nonatomic, assign) BOOL isArrived;

@property (nonatomic, copy) ComfirmBlock confirmBlock;

//- (instancetype)initWithOrderTaskType:(BGWOrderTaskType)taskType taskModel:(QPYOrderTaskListModel *)taskModel;
//- (instancetype)initWithOrderNo:(NSString *)orderNo roleType:(BGWRoleActionType)roleType;
////集散中心-订单列表进入详情，默认不可操作，传BGWOrderTaskTypeFinished（只用来判断operateButton是否显示）
//- (instancetype)initWithTaskType:(BGWOrderTaskType)taskType orderNo:(NSString *)orderNo roleType:(BGWRoleActionType)roleType;


- (instancetype)initWithOrderId:(NSString *)orderId taskType:(BGWOrderTaskType)taskType roleType:(BGWRoleActionType )roleType;
- (instancetype)initWithOrderNo:(NSString *)orderNo taskType:(BGWOrderTaskType)taskType roleType:(BGWRoleActionType)roleType;
- (instancetype)initWithBaggageId:(NSString *)baggageId taskType:(BGWOrderTaskType)taskType roleType:(BGWRoleActionType)roleType;

@end
