//
//  GTPlaceOrderModel.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/17.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit

class GTPlaceOrderModel: NSObject {
    
    public var roleId: String = BGWUser.getCurrentUserId()
    public var sendCity: String = (BGWUser.current()?.userRole.provinceName ?? "") + " " + (BGWUser.current()?.userRole.cityName ?? "")
//    "上海 上海市"
    public var sendAddress: String = (BGWUser.current()?.userRole.userRoleName ?? "")
    //"虹桥机场T2航站楼"
    public var sendTime: String = ""
    public var sendFlightNumber: String = ""
    
    public var receiveCity: String = ""
    public var receiveType: String = ""
    public var recipientType: String = "本人"
//    public var recipientName: String = "" receiveName
//    public var recipientPhone: String = "" receivePhone
    public var receiveAddress: String = ""
    public var receiveFlightNumber: String = ""
    public var receiveHouseNumber: String = ""
    public var receiveTime: String = ""
    public var distance: String = "0"   //专车专送行驶距离, 米
    public var duration: Int = 0        //专车专送行驶时间, 秒
//    public var receiveCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    public var cusPhone: String = ""
    public var cusName: String = ""
    public var cusIDNumber: String = ""
    
    public var baggageNumber: Int = 1
    public var safeTag: Int = 2
    public var nightNumber: Int = 0
    
    //OrderMainSpec
    var totalPrice: String = ""     //总价
    var actualPrice: String = ""    //实际价格(总价-优惠)
    //var baggageNumber: Int = 1    //行李数量
    var channel: String = ""        //app_gs, app_sc
    var sendMailingWay: String = "AIRPOSTCOUNTER"     //寄件方式
    var receiveMailingWay: String = ""        //收件方式
    var sendTimeFormat: String = ""       //寄件时间: yyyy-MM-dd HH:ss:mm
    var receiveTimeFormat: String = ""    //收件时间
    
    
    //OrderAddress
    //xxx玩意儿都要我传
    var srcAddressType: String = "AIRPORTCOUNTER"
    var srcAddressId: String = BGWUser.current()?.userRole.userRoleId ?? ""
    var srcLandmark: String = BGWUser.current()?.userRole.userRoleName ?? ""
    var srcProvinceId: String = BGWUser.current()?.userRole.provinceId ?? ""
    var srcCityId: String = BGWUser.current()?.userRole.cityId ?? ""
    var srcProvinceName: String = BGWUser.current()?.userRole.provinceName ?? ""
    var srcCityName: String = BGWUser.current()?.userRole.cityName ?? ""
    var srcAddress: String = BGWUser.current()?.userRole.userRoleName ?? ""
    var srcCoordinate: String = BGWUser.current()?.userRole.coordinate ?? ""
//    var srcCoordinate: String = try! String(data: JSONSerialization.data(withJSONObject: BGWUser.current()?.userRole.coordinate as Any, options: []), encoding: String.Encoding.utf8) ?? ""
    
    var destAddressType: String = ""
    var destAddressId: String = ""      //目的地为机场时传机场id
    var destLandmark: String = ""
    var destProvinceId: String = ""
    var destCityId: String = ""
    var destProvinceName: String = ""
    var destCityName: String = ""
    var destAddress: String = ""
    var destCoordinate: String = ""
    var destDistrictName: String = ""
    var destTownshipName: String = ""

    //OrderSafeInfo
    var safeCode: String = "0002" //0001, 0002, 0003
    
    //OrderPersonInfo
    var sendName: String = ""
    var sendPhone: String = ""
    var sendIdNumber: String = ""
    var receiverName: String = ""
    var receiverPhone: String = ""
    var receiverIdNumber: String = ""
    
    //OrderNotes
    var notes: String = ""      //备注
//    var cusName: String = ""    //客户姓名
    
    //OrderFlight
//    var sendFlightNumber: String = ""
//    var receiveFlightNumber: String = ""
    
    //CusInfo
//    var cusName: String = ""        //客户姓名
//    var cusPhone: String = ""       //客户电话
//    var cusIDNumber: String = ""    //客户证件号
    
    var payType: String = "" //支付类型 weixin/month月付
    
    
    func placeModelIsEmpty() -> (Bool, String) {
        
        if self.sendTimeFormat == "" {
            return (true, "请选择寄件时间")
        }
        if self.receiveCity == "" {
            return (true, "请选择收件城市")
        }
        if self.receiveType == "" {
            return (true, "请选择收件类型")
        }
        if self.destAddress == "" || self.destAddress == "-" {
            return (true, "请选择收件地址")
        }
        if self.receiveTimeFormat == "" {
            return (true, "请选择收件时间")
        }
        if self.cusPhone == "" {
            return (true, "请输入手机号码")
        }
        if self.cusName == "" {
            return (true, "请输入客户姓名")
        }
        if self.cusIDNumber == "" {
            if payType != "MONTH" {
                return (true, "请输入证件编号")
            }
        }
        if self.receiverName == "" || self.receiverPhone == "" {
            return (true, "请填写收件人信息")
        }
        
        return (false, "")
    }
    
    func placeModelParameter(_ isPay: String) -> [AnyHashable : Any] {
        
        return self.placeModelParameter(nil, isPay)
        
    }
    
    
    func placeModelParameter(_ baggages: Array<OrderBaggageModel>? , _ isPay: String) -> [AnyHashable : Any] {
        
        var parameters = [AnyHashable : Any]()
        
        let mainSpec = ["totalmoney": self.totalPrice, "actualmoney": self.actualPrice, "num": self.baggageNumber.description, "channel": self.channel, "mailingway": self.sendMailingWay, "backway": self.receiveMailingWay, "taketime": self.sendTimeFormat, "sendtime": self.receiveTimeFormat, "status": isPay]
        parameters["orderMainSpec"] = mainSpec
        
        let address = ["srcaddrtype": self.srcAddressType, "srcaddressid": self.srcAddressId, "scrlandmark": self.srcLandmark, "srcprovid": self.srcProvinceId, "srccityid": self.srcCityId, "srcprovname": self.srcProvinceName, "srccityname": self.srcCityName, "srcaddress": self.srcAddress, "srcgps": self.srcCoordinate,
                       "destaddrtype": self.destAddressType, "destaddressid": self.destAddressId, "destlandmark": self.destLandmark, "destprovid": self.destProvinceId, "destcityid": self.destCityId, "destprovname": self.destProvinceName, "destcityname": self.destCityName, "destaddress": self.destAddress, "destgps": self.destCoordinate, "destdistrictname": self.destDistrictName, "deststreetname": self.destTownshipName]
        parameters["orderAddress"] = address
        
        let safeInfo = ["insurecode": self.safeCode]
        parameters["orderInsureInfo"] = safeInfo
        
        let personInfo = ["sendername": self.sendName, "senderphone": self.sendPhone, "senderidno": self.sendIdNumber,
                          "receivername": self.receiverName, "receiverphone": self.receiverPhone, "receiveridno": self.receiverIdNumber]
        parameters["orderSenderReceiver"] = personInfo
        
        let notes = ["notes": self.notes, "addusername": self.cusName]
        parameters["orderNotesInfo"] = notes
        
        let flight = ["sendflightno": self.sendFlightNumber, "takeflightno": self.receiveFlightNumber]
        parameters["orderFlight"] = flight
        
        let cusInfo = ["name": self.cusName, "mobile": self.cusPhone, "idno":self.cusIDNumber]
        parameters["cusInfo"] = cusInfo
        
        let payInfo = ["type": self.payType, "status": isPay]
        parameters["orderPayInfo"] = payInfo
        
        let orderRole = ["roleid": self.roleId]
        parameters["orderRole"] = orderRole
        
        if  baggages != nil {
            var list = [[String : Any]]()
            let imgType = "COOLECT"
            let userId = BGWUser.getCurrentUserId()
            for baggage in baggages! {
        
                let baggageInfo = ["baggageid": baggage.baggageQRCode, "imgtype": imgType, "imgurlList": baggage.baggageImage.takeImageUrls, "uploadUserid": userId!] as [String : Any]
                list.append(baggageInfo)
            }
            parameters["orderBaggageReqDataList"] = list

        }
        
        return parameters
        
    }
    
    
    
    
    func judgeBaggages(_ baggages: Array<OrderBaggageModel>) -> Bool {
        
        var result = true
        for baggage in baggages {
            
            // qrcode和images有一项为空
            if (baggage.baggageQRCode == nil) || (baggage.baggageImage.takeImageUrls == nil) {
                // 两项都为空不校验
                if !(baggage.baggageQRCode == nil && baggage.baggageImage.takeImageUrls == nil) {
                    result = false
                    break
                }
            }
        }
        return result
        
    }
    
    
    
}



