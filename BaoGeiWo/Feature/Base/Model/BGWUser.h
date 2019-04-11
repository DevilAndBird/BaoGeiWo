//
//  BGWUser.h
//  BaoGeiWo
//
//  Created by wb on 2018/5/4.
//  Copyright © 2018年 qyqs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderPricingRuleModel;
@class BGWAirportCounterModel;
//DELIVERY_MAN("DELIVERY_MAN", "取派员"),
//TRANSIT_CENTER("TRANSIT_CENTER", "集散中心")
//REGULAR_DRIVER("REGULAR_DRIVER", "班车司机")
//AIRPORT_PICKER("AIRPORT_PICKER", "机场取件员")
//SERVICE_CENTER("SERVICE_CENTER", "柜台服务中心");


typedef NS_ENUM(NSUInteger, AppUserType) {
    AppUserTypeDeliveryMan,  //取派员
    AppUserTypeTransitCenter, //集散中心
    AppUserTypeServiceCenter, //柜台服务中心
    
    //暂时没用
    AppUserTypeRegularDriver, //班车司机
    AppUserTypeAirportPicker, //机场取件员
};




@interface BGWUserRole : NSObject

@property (nonatomic, copy) NSString *userRoleId; // 用户所属地Id
@property (nonatomic, copy) NSString *userRoleName; //用户所属地名字
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) NSString *coordinate; //"{'lng':'121.32707','lat':'31.200373'}

@end




@interface BGWUser : NSObject
/*
 roleid
 角色 id
 
 mobile
 String
 用户手机号码
 
 name
 String
 姓名
 
 type
 String
 类型: 详见枚举 APPUSER_TYPE
 
 
 roleList
 List<AppUserRole>
 用户类型列表
 
 AppUserRole
 
 
 id
 Integer
 所属地编号(机场，集散中心的 id)，取派 员为空
 
 roleName
 所属地名称(机场，集散中心的名称)，取 派员为空
 */





@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, copy) NSString *userId;   //用户id (roleid)
@property (nonatomic, copy) NSString *userName; //用户名字 (name)
@property (nonatomic, copy) NSString *mobile;  //(mobile)
@property (nonatomic, copy) NSString *userTypeString; //用户类型
@property (nonatomic, strong) BGWUserRole *userRole; //用户所属地 dic， type为取派员时为空



@property (nonatomic, assign) AppUserType userType;

@property (nonatomic, strong) OrderPricingRuleModel *orderPricingRule;
@property (nonatomic, strong) NSArray<BGWAirportCounterModel *> *airportCounters;
@property (nonatomic, strong) NSArray<BGWAirportCounterModel *> *enterpriseCounters;

+ (instancetype)currentUser;
- (void)saveUserInfo;
+ (void)removeUserInfoFromUserDefaults;

+ (NSString *)getCurrentUserId;
+ (NSString *)getCurremtUserName;
+ (AppUserType)getCurremtUserType;


@end
