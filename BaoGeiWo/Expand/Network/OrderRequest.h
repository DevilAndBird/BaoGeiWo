//
//  OrderRequest.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/8.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QPYOrderTaskListModel;
@class QPYOrderTaskGroupModel;

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(id error);

@interface OrderRequest : NSObject

//获取订单任务数量
+ (void)getOrderTaskNumber:(SuccessBlock)success failure:(FailureBlock)failure;
//获取地图信息列表
+ (void)getMapTaskList:(SuccessBlock)success failure:(FailureBlock)failure;
//获取订单任务列表
+ (void)getOrderTaskList:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

//确认发车
+ (void)confirmDriverStartedWithTaskListModel:(QPYOrderTaskListModel *)taskModel success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)confirmDriverStartedWithTaskGroup:(QPYOrderTaskGroupModel *)groupModel success:(SuccessBlock)success failure:(FailureBlock)failure;
//即将到达／确认到达
+ (void)confirmDriverStatus:(BGWOrderDriverStatus)driverStatus taskListModel:(QPYOrderTaskListModel *)taskModel success:(SuccessBlock)success failure:(FailureBlock)failure;
//通知客户
+ (void)notifyAppCusWithOrderId:(NSString *)orderId roleType:(NSString *)roleType success:(SuccessBlock)success failure:(FailureBlock)failure;

//获取订单任务详情
+ (void)getOrderTaskDetail:(QPYOrderTaskListModel *)taskModel success:(SuccessBlock)success failure:(FailureBlock)failure __deprecated_msg("已废弃，请勿使用。");
+ (void)getOrderTaskDetailWithOrderId:(NSString *)orderId detailsType:(NSArray *)detailsType success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getOrderTaskDetailWithOrderNo:(NSString *)orderNo detailsType:(NSArray *)detailsType success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getOrderTaskDetailWithFetchNo:(NSString *)fetchNo detailsType:(NSArray *)detailsType success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getOrderTaskDetailWithBaggageId:(NSString *)baggageId detailsType:(NSArray *)detailsType success:(SuccessBlock)success failure:(FailureBlock)failure;


//获取取派员订单列表
+ (void)getOrderListWithRoleActionType:(BGWRoleActionType)roleActionType actionStatus:(BGWRoleActionStatus)actionStatus destType:(BGWDestinationType)destType destId:(NSString *)destId orderStatus:(BGWOrderStatus)orderStatus success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getOrderListWithDeliveryManId:(NSString *)deliveryManId roleActionType:(BGWRoleActionType)roleActionType actionStatus:(BGWRoleActionStatus)actionStatus destType:(BGWDestinationType)destType destId:(NSString *)destId orderStatus:(BGWOrderStatus)orderStatus success:(SuccessBlock)success failure:(FailureBlock)failure;

//更新订单状态
+ (void)updateOrderStatue:(BGWOrderStatus)orderStatus orderId:(id)orderId success:(SuccessBlock)success failure:(FailureBlock)failure;
//生成订单
+ (void)generateOrderWithStatue:(BGWOrderStatus)orderStatus orderId:(id)orderId success:(SuccessBlock)success failure:(FailureBlock)failure;


//集散中心获取装车扫描qr码列表
+ (void)getDeliveryScanListWithUserId:(NSString *)userId destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure;
//装车扫描
+ (void)deliveryScanWithQRNumber:(NSString *)qrnumber success:(SuccessBlock)success failure:(FailureBlock)failure;;
//行李是否扫描成功
+ (void)baggageIsScanWithOrderId:(NSString *)orderId qrNumber:(NSString *)qrNumber success:(SuccessBlock)success failure:(FailureBlock)failure;
//集散中心装车完毕
+ (void)transitCenterLoadDoneWithIdArray:(NSArray *)orderIdArray destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure;


//获取集散中心已完成/寄存件订单列表  type 1:寄存 2:已完成
+ (void)getJSOrderListWithType:(NSInteger)type success:(SuccessBlock)success failure:(FailureBlock)failure;
//获取柜台订单列表  type 1:待收取 2:待释放 3:寄存 4:已完成
+ (void)getGTOrderListWithType:(BGWGTOrderType)type success:(SuccessBlock)success failure:(FailureBlock)failure;



//获取(机场／服务中心)行李数量
+ (void)getBaggageCountWithBagaggeId:(NSString *)baggageId roleActionType:(BGWRoleActionType)roleActionType actionStatus:(BGWRoleActionStatus)actionStatus destType:(BGWDestinationType)destType destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure;

//机场／服务中心装车完毕
+ (void)serviceCenterLoadDoneWithIdArray:(NSArray *)orderIdArray destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure;


//qr码是否可用
+ (void)queryQRCodeIsUseful:(NSString *)qrCode success:(SuccessBlock)success failure:(FailureBlock)failure;

//qr码关联订单
+ (void)saveOrderBaggageWithQRCode:(NSString *)qrCode orderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure;

//关联行李图片
+ (void)baggageImageUploadWithImageUrl:(NSString *)imageUrl baggageId:(NSString *)baggageId orderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)baggageImageUploadWithImageUrls:(NSArray *)imageUrls imageType:(NSString *)imageType baggageId:(NSString *)baggageId orderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure;

//确认取件
+ (void)confirmTakeOrderWithOrderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure;

//确认派件
+ (void)confirmSendOrderWithOrderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure;

    
//机场柜台确认交接（取派员卸车）
+ (void)serviceCenterUnloadDoneWithIdArray:(NSArray *)orderIdArray deliveryId:(NSString *)deliveryId success:(SuccessBlock)success failure:(FailureBlock)failure;
//集散中心确认交接（取派员卸车）
+ (void)transitCenterUnloadDoneWithIdArray:(NSArray *)orderIdArray deliveryId:(NSString *)deliveryId success:(SuccessBlock)success failure:(FailureBlock)failure;

//获取卸车扫描数据（判断是否可以进入扫描页）
+ (void)transitCenterUnloadScanWithDeliveryId:(NSString *)deliveryId destId:(NSString *)destId success:(SuccessBlock)success failure:(FailureBlock)failure;

//用户确认收件签名
+ (void)SaveUserSignWithOrderId:(NSString *)orderId userName:(NSString *)userName userSign:(NSString *)userSign success:(SuccessBlock)success failure:(FailureBlock)failure;


//查询柜台下单计价规则
+ (void)getPricingRuleByCityId:(NSString *)cityId success:(SuccessBlock)success failure:(FailureBlock)failure;
//删除未支付订单
+ (void)deleteUnpaidOrderByOrderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure;
//更改订单支付状态
+ (void)updatePaidOrderByOrderNo:(NSString *)orderNo success:(SuccessBlock)success failure:(FailureBlock)failure;


//订单反馈
+ (void)orderFeedbackWithOrderId:(NSString *)orderId content:(NSString *)content success:(SuccessBlock)success failure:(FailureBlock)failure;
//订单反馈列表
+ (void)GetFeedbackListWithOrderId:(NSString *)orderId success:(SuccessBlock)success failure:(FailureBlock)failure;



@end
