//
//  BGWEnumType.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#ifndef BGWEnumType_h
#define BGWEnumType_h

//接口状态码
typedef NS_ENUM(NSUInteger, BGWResponseCode) {
    BGWResponseCodeSuccess = 0,
    BGWResponseCodeFailure = 1,
    BGWResponseCodeLoginError = 3,
};

//查询服务中心（机场／柜台）／集散中心类型
typedef NS_ENUM(NSUInteger, BGWCityNodeType) {
    BGWCityNodeTypeCounterCenter = 0,
    BGWCityNodeTypeTransitCenter,
};
//目的地类型 (😳好像和⬆️这个一样？)
typedef NS_ENUM(NSUInteger, BGWDestinationType) {
    BGWDestinationTypeServiceCenter = 0,    //服务中心
    BGWDestinationTypeTransitCenter,        //集散中心
    BGWDestinationTypeHouse,                //住宅
    BGWDestinationTypeHotel,                //酒店
    BGWDestinationTypeOther,                //其他
};


typedef NS_ENUM(NSUInteger, BGWMessageType) {
    BGWMessageTypeSystem,
    BGWMessageTypeOrder,
    BGWMessageTypeAll,
};

///** 机场到酒店(柜台到酒店) */ AIRPORTCOUNTER_TO_HOTEL("AIRPORTCOUNTERTOHOTEL", "机场柜台到酒 店"),
/** 机场到酒店(轮盘到酒店) */ //AIRPORTTURNTABLE_TO_HOTEL("AIRPORTTURNTABLETOHOTEL", "机场转盘到 酒店"),
/** 酒店到机场 */
//HOTEL_TO_AIRPORT("HOTELTOAIRPORT", "酒店到机场");
//typedef NS_ENUM(NSUInteger, BGWOrderType) {
//    BGWOrderTypeAirportToHotel,
//    BGWOrderType,
//    BGWOrderType,
//};



//角色动作
typedef NS_ENUM(NSUInteger, BGWRoleActionType) {
    BGWRoleActionTypeHotelTask = 0,       //"ROLE_HOTEL_TASK", "去酒店(去取件)"
    BGWRoleActionTypeHotelSend,           //"ROLE_HOTEL_SEND", "去酒店(去送件)
    BGWRoleActionTypeTransitTask,         //"ROLE_TRANSIT_TASK", "去集散中心(取件)" 装车
    BGWRoleActionTypeTransitSend,         //"ROLE_TRANSIT_SEND", "去集散中心(送件)" 卸车
    BGWRoleActionTypeAirportTask,         //"ROLE_AIRPORT_TASK", "去机场(取件)"
    BGWRoleActionTypeAirportSend,         //"ROLE_AIRPORT_SEND", "去机场(送件)"
    BGWRoleActionTypeArriveHotel,         //"ROLE_ARRIVE_HOTEL", "抵达酒店"
    BGWRoleActionTypeArriveTransit,       //"ROLE_ARRIVE_TRANSIT", "抵达集散中心"
    BGWRoleActionTypeArriveAirport,       //"ROLE_ARRIVE_AIRPORT", "抵达机场柜台"
    BGWRoleActionTypeOther,
};

//角色动作状态
typedef NS_ENUM(NSUInteger, BGWRoleActionStatus) {
    BGWRoleActionStatusNotBegin = 0,    //"UNFINISHED", "未开始"
    BGWRoleActionStatusOnGoing,         //"ONGOING", "进行中"
    BGWRoleActionStatusFinished,        //"FINISHED", "完成"
};


//订单状态
typedef NS_ENUM(NSUInteger, BGWOrderStatus) {
    BGWOrderStatusWaitPay = 0,          //"WAITPAY", "待支付"
    BGWOrderStatusPrepaid,              //"PREPAID", "已支付的"
    BGWOrderStatusWaitPick,             //"WAITPICK", "待取件"
    BGWOrderStatusTakeGoodsing,         //"TAKEGOOGSING", "取件中"
    BGWOrderStatusTakeGoodsOver,        //"TAKEGOOGSOVER", "已取件"
    BGWOrderStatusWaitOrderReceiving9,   //"WAITORDERRECEIVING", "待接单"
    BGWOrderStatusOrderRecevingOver,    //"ORDERRECEIVINGOVER", " 已接单"
    BGWOrderStatusWaitTruceLoading,     //"WAITTRUCELOADING", "待装车"
    BGWOrderStatusTruceLoadingOver,     //"TRUCELOADINGOVER", "已装车"
    BGWOrderStatusTransferOver,         //"TRANSFEROVER", "已中转"
    BGWOrderStatusArriveAirport,        //"ARRIVEAIRPORT", "已达机场"
    BGWOrderStatusReleaseOver,          //"RELEASEOVER", "已释放"
    BGWOrderStatusAllotDelivery,        //"ALLOTDELIVERY", "已派单"
    BGWOrderStatusDeliverying,          //"DELIVERYING", "派送中"
    BGWOrderStatusDeliveryOver,         //"DELIVERYOVER", "已送达"
    BGWOrderStatusWaitingUnload,        //"WAITINGUNLOAD", "待卸车"
    BGWOrderStatusUnload,               //"UNLOAD", "已卸车"
    BGWOrderStatusTroubleDeal,          //"TROUBLE_DEAL", "问题件处理"

};

//订单任务类型
typedef NS_ENUM(NSUInteger, BGWOrderTaskType) {
    BGWOrderTaskTypePrepareReceive = 0, //待取件
    BGWOrderTaskTypePrepareSend,        //待派
    BGWOrderTaskTypeOnGoing,            //进行中
    BGWOrderTaskTypeFinished,           //已完成
    BGWOrderTaskTypeAll,                //今日（除已完成外的全部）
    BGWOrderTaskTypeOther,              //其他
};

//柜台订单类型
typedef NS_ENUM(NSUInteger, BGWGTOrderType) {
    BGWGTOrderTypeWaitPay = 0, //待支付
    BGWGTOrderTypeTake,     //待取件
    BGWGTOrderTypeSend,     //待释放
    BGWGTOrderTypeDeposit,  //寄存件
    BGWGTOrderTypeFinish,   //已释放
};


//寄件方式
typedef NS_ENUM(NSUInteger, BGWOrderMailingWay) {
    BGWOrderMailingWayAirportCounter = 0,     //"AIRPOSTCOUNTER", "柜台"
    BGWOrderMailingWayOneSelf,                //"ONESELF", "本人"
    BGWOrderMailingWayFrontDesk,              //"FRONTDESK", "酒店前台"
    BGWOrderMailingWayOtherSend,              //"OTHER", "他人待寄"
    BGWOrderMailingWayUnknown,                
};


//订单行驶状态
typedef NS_ENUM(NSUInteger, BGWOrderDriverStatus) {
    BGWOrderDriverStatusArriving,   //"ARRIVING", "即将到达"
    BGWOrderDriverStatusArrived,    //"ARRIVED", "确认到达"
};



#endif /* BGWEnumType_h */
