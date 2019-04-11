//
//  NetworkAPI.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/3.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#ifndef NetworkAPI_h
#define NetworkAPI_h

#if BGW_ENVIRONMENT
#define HOST @"http://47.100.123.1/"
#else
#define HOST @"http://47.96.186.145/"
#endif

#define BaseUrl HOST@"jpoa/"

//用户登录
#define API_UserLogin BaseUrl@"applogin/appUserLogin"


//获取订单任务数量
#define API_GetOrderTaskNumber BaseUrl@"apporder/findAppOrderNumTaskList"
//获取订单任务列表
#define API_GetOrderTaskList BaseUrl@"apporder/findAppOrderTaskList_total"
//获取订单任务详情
#define API_GetOrderTaskDetail BaseUrl@"apporder/findAppOrderDetails"
//查询订单列表
#define API_GetOrderList BaseUrl@"apporder/findAppOrderMainList"
//更新订单状态
#define API_UpdateOrderStatus BaseUrl@"apporder/updateOrderStatus"
//生成订单
#define API_GenerateOrder BaseUrl@"apporder/generateOrder"
//机场装车扫描
#define API_GetBaggageCount BaseUrl@"apporder/countBatchBagNumByQR"
//集散获取已完成订单列表
#define API_GetJSFinishOrderList BaseUrl@"apporder/findAppOrderFinish"
//集散获取寄存件订单列表
#define API_GetJSDepositOrderList BaseUrl@"apporder/findAppOrderJicun"
//柜台获取订单列表
#define API_GetGTOrderList BaseUrl@"apporder/findAppOrderAirport"
//用户确认收件签名
#define API_SaveUserSign BaseUrl@"apporder/saveSignUrl"
//获取地图信息列表
#define API_GetMapTaskList BaseUrl@"apporder/findAppMapTaskList"
//通知客户功能
#define API_NotifyAppCus BaseUrl@"apporder/notifyAppCus"

//获取柜台下单计价规则
#define API_GetPricingRule BaseUrl@"apporder/findPricingRule"
//柜台下单验证收件地址是否可用
#define API_CheckAddressUsable BaseUrl@"apporder/checkAddressUsable"
//柜台下单
#define API_GTPlaceOrder BaseUrl@"apporder/saveorder"
//删除未支付订单
#define API_GTDeleteUnpaidOrder BaseUrl@"apporder/deleteOrder"
//订单已付款
#define API_GTUpdatePaidOrder BaseUrl@"apporder/updateprepaid"


//确认发车
#define API_ConfirmDriverStarted BaseUrl@"appdm/confirmDriverStarted"
//即将到达
#define API_ConfirmDriverArriving BaseUrl@"appdm/confirmDriverTaskArriving"
//确认到达
#define API_ConfirmDriverArrived BaseUrl@"appdm/confirmDriverTaskArrived"
//确认取件
#define API_ConfirmTakeOrder BaseUrl@"appdm/confirmTakenOrders"
//确认派件
#define API_ConfirmSendOrder BaseUrl@"appdm/confirmSentOrders"




//获取集散中心/服务中心列表
#define API_GetCityNode BaseUrl@"userdelivery/findCityNodeByUserid"
//获取取派员列表
#define API_GetDeliveryManList BaseUrl@"userdelivery/getDeliveryManListByParam"
//机场/服务中心装车完毕
#define API_ServiceCenterLoadDone BaseUrl@"userdelivery/serviceCenterLoadDone"
//集散中心装车扫描列表（是否有权限）
#define API_PreLoadingScan BaseUrl@"userdelivery/preLoadingScan"
//集散中心装车扫描
#define API_DeliveryScan BaseUrl@"userdelivery/loadingScan"
//集散中心装车完毕
#define API_TranistCenterLoadDone BaseUrl@"userdelivery/tranistLoadDone"
//取派员位置定位更新
#define API_UpdateDManCurrentGPS BaseUrl@"userdelivery/updateDmanCurrentGps"


//行李是否扫描通过
#define API_BaggageIsScan BaseUrl@"appOrderBaggage/isScan"
//qr码是否可用
#define API_ScanQRCode BaseUrl@"appOrderBaggage/scanQRCode"
//qr码关联订单
#define API_SaveOrderBaggage BaseUrl@"appOrderBaggage/saveOrderBaggage"
//图片关联行李、订单
#define API_BaggageImageUpload BaseUrl@"appOrderBaggage/baggageImgUrlUpload"


//获取所在城市柜台信息
#define API_GetCounterByCity BaseUrl@"appCounterService/findCountersByCity"
//柜台确认交接（取派员卸车）
#define API_ServiceCenterUnloadDone BaseUrl@"appCounterService/affirmConnect"
//集散中心确认交接（取派员卸车）
#define API_TransitCenterUnloadDone BaseUrl@"appTransitCenter/unloadDone"
//获取卸车扫描数据（判断是否可以进入扫描页）
#define API_TransitUnloadScan BaseUrl@"appTransitCenter/unloadScan"


//获取未读消息条数
#define API_GetUnreadMsgCount BaseUrl@"push/countIsread_N"
//获取消息列表
#define API_GetMsgList BaseUrl@"push/findPushInfoByUserid"
//更新消息为已读
#define API_UpdateMsgIsRead BaseUrl@"push/updateIsreadToY"


//订单问题反馈
#define API_OrderFeedback BaseUrl@"orderToubleInfo/orderToubleFeedback"
//订单反馈列表
#define API_GetFeedbackList BaseUrl@"orderToubleInfo/findOrderToubleList"



#endif /* NetworkAPI_h */
