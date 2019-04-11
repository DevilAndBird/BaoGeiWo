//
//  WQPickerViewController.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/17.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit

public enum PickerStyle {
    case date                   //时间
    case date_receive           //收件时间
    case date_send              //寄件时间
    case receive_type           //收件地点类型
    case recipient_type         //收件人类型
    case counter                //柜台列表
    case enterprise_counter     //企业柜台
    case address
    case none
}



protocol WQPickerViewDelegate {
    
    func selectReceiveType(type: String)
    func selectRecipientType(type: String)
    func selectCounter(counter: BGWAirportCounterModel)
    func selectEnterpriseCounter(counter: BGWAirportCounterModel)
    func selectDate(_ date: String, displayDate: String, hour: String, minute: String, style: PickerStyle)
    func selectAddress(_ province: String, _ provinceCode: String, _ city: String, _ cityCode: String)
    
}



class WQPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var style: PickerStyle = .none
    var delegate: WQPickerViewDelegate?
    
    var bgView: UIView!
    var modalView: SpringView!
    var titleLabel: UILabel!
    var cancelButton: UIButton!
    var confirmButton: UIButton!
    var pickerView: UIPickerView!
    
    var dataList = [[String]]()
    var yyyyMMdds = [String]() //style=date, 纪录年月日
    
    public var currentHour = 0  //当前时间, 寄件获取当前时间, 收件由寄件时间+4小时
    var currentHours = [String]() //当天时间数组
    var hours: [String] {   //通用时间数组
        var temp = [String]()
        for i in 0..<24 {
            let hourStr = i.description
            temp.append(hourStr)
        }
        return temp
    }
    
    var currentMinute = 0 //当前分钟和寄件分钟保持一致
//    var currentMinutes = [String]() //当前小时分钟数组
//    var minutes = ["00", "30"]      //通用分钟数组
    
    var provinces = [String]()
    var provinceCodes = [String]()
    var citys = [[String]]()
    var cityCodes = [[String]]()
    var currentCitys = [String]()
    var currentCityCodes = [String]()
    
    var airportCounters: [BGWAirportCounterModel]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if style == .date_send || style == .date_receive {
            titleLabel.text = "请选择时间"

            var days = [String]()
            let currentDate = Date()
            
            for i in 0..<15 {
                var newDateComp = DateComponents()
                newDateComp.day = i
                let newDate = Calendar.current.date(byAdding: newDateComp, to: currentDate)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "zh-Hans")
                var formatStr = "MM月d日EEE"
                let yearFormatStr = "yyyy-MM-dd"
                if i == 0  {
                    if style == .date_send {
                        formatStr = "H"
                        dateFormatter.dateFormat = formatStr
                        let dateString = dateFormatter.string(from: newDate!)
                        if !dateString.isEmpty {
                            currentHour = Int(dateString)!
                        }
                        
                        formatStr = "mm"
                        dateFormatter.dateFormat = formatStr
                        let minuteString = dateFormatter.string(from: newDate!)
                        if !minuteString.isEmpty {
                            currentMinute = Int(minuteString)!
                        }
                        if currentMinute > 30 {
                            //不能选当前小时, hour+1
                            currentHour += 1
//                            currentMinutes = ["00", "30"]
                        }
//                        if currentMinute > 0 {
//                            currentMinutes = ["30"]
//                        } else if currentMinute == 0 {
//                            currentMinutes = ["00", "30"]
//                        }

                    }
                    
                    if style == .date_receive {
//                        if currentMinute == 0 {
//                            currentMinutes = ["00", "30"]
//                        } else if currentMinute == 30 {
//                            currentMinutes = ["30"]
//                        }
                        
                        if currentHour > 23 {
                            currentHour -= 24
                            continue
                        }
                    }
                    
                    formatStr = "MM月d日今天"
                } else if i == 1 {
                    formatStr = "MM月d日明天"
                } else if i == 2 {
                    formatStr = "MM月d日后天"
                }
                
                dateFormatter.dateFormat = formatStr
                let dateString = dateFormatter.string(from: newDate!)
                days.append(dateString)
                
                //保存年份
                dateFormatter.dateFormat = yearFormatStr
                let yearString = dateFormatter.string(from: newDate!)
                yyyyMMdds.append(yearString)
            }
            dataList.append(days)
            
            
            for i in currentHour..<24 {
                let hourStr = i.description
                currentHours.append(hourStr)
            }
            dataList.append(currentHours)
            
            let minutes = ["00", "30"]
            dataList.append(minutes)

        } else if style == .receive_type {
            titleLabel.text = "请选择收件类型"

            let types = ["机场", "酒店", "住宅"]
            dataList.append(types)
        } else if style == .recipient_type {
            titleLabel.text = "请选择收件人类型"

            let types = ["本人", "他人"]
            dataList.append(types)
        } else if style == .counter {
            titleLabel.text = "请选择机场"

            var counters: [String] = []
            if airportCounters == nil {
                for counter in (BGWUser.current()?.airportCounters)! {
                    counters.append(counter.counterName + "-" + counter.counterRemark)
                }
            } else {
                for counter in airportCounters! {
                    counters.append(counter.counterName + "-" + counter.counterRemark)
                }
            }
            dataList.append(counters)
        } else if style == .enterprise_counter {
            titleLabel.text = "请选择柜台"
            
            var counters: [String] = []
            for counter in (BGWUser.current()?.enterpriseCounters)! {
                counters.append(counter.counterName + "-" + counter.counterRemark)
            }
            dataList.append(counters)
        } else if style == .address {
            titleLabel.text = "请选择城市"

            let arr: NSArray = NSArray(contentsOfFile: Bundle.main.path(forResource: "address", ofType: "plist")!)!

            for i in 0..<arr.count {
                let prov: NSDictionary = arr[i] as! NSDictionary
                
                provinces.append(prov.object(forKey: "name") as! String) //省
                provinceCodes.append(prov.object(forKey: "id") as! String)
                
                let cityArray: NSArray = prov.object(forKey: "sub") as! NSArray
                var tempCitys = [String]()
                var tempCityCodes = [String]()
                for j in 0..<cityArray.count {
                    let city: NSDictionary = cityArray[j] as! NSDictionary
                    tempCitys.append(city.object(forKey: "name") as! String)
                    tempCityCodes.append(city.object(forKey: "id") as! String)
                }
                citys.append(tempCitys)
                cityCodes.append(tempCityCodes)
                
                if i == 0 {
                    currentCitys = tempCitys
                    currentCityCodes = tempCityCodes
                }
            }
            dataList.append(provinces)
            dataList.append(currentCitys)
            
//            print(arr)
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modalView.animation = "squeezeUp"
        modalView.damping = 0.8
        modalView.animate()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        var width = 0.0
        let height = 40.0
        if component == 0 {
            
        }
        let width = UIScreen.main.bounds.size.width/CGFloat(self.pickerView.numberOfComponents)
        
        let myView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: Double(width), height: height))
        myView.backgroundColor = .clear
        
        let myLabel = UILabel.init(frame: CGRect(x: 0.0, y: 0.0, width: Double(width), height: height))
        myLabel.textAlignment = .center
        if row >= dataList[component].count {
            myLabel.text = dataList[component].last
        } else {
            myLabel.text = dataList[component][min(row, dataList[component].count)]
        }
        
        myView.addSubview(myLabel)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if style == .date_send || style == .date_receive {
            if component == 0 {
                if row == 0 {
                    if dataList[1] != currentHours {
                        dataList[1] = currentHours
                        pickerView.reloadComponent(1)
                    }
                } else {
                    if dataList[1] != hours {
                        dataList[1] = hours
                        pickerView.reloadComponent(1)
                    }
                }
            
            }
            
//            if component == 1 {
//                if row == 0 {
//                    if dataList[2] != currentMinutes {
//                        dataList[2] = currentMinutes
//                        pickerView.reloadComponent(2)
//                    }
//                } else {
//                    if dataList[2] != minutes {
//                        dataList[2] = minutes
//                        pickerView.reloadComponent(2)
//                    }
//                }
//            }
            
        } else if style == .address {
            
            if component == 0 {
                currentCitys = citys[row]
                currentCityCodes = cityCodes[row]
                dataList.remove(at: 1)
                dataList.append(currentCitys)
                pickerView.reloadComponent(1)
            }
            
        }

        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bgView = UIView.init()
        bgView.backgroundColor = UIColor.init(hex: "#000000")
        bgView.alpha = 0.4
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        let dismissTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissTap(_:)))
        bgView.addGestureRecognizer(dismissTap)
        
        let modalHeight = UIScreen.main.bounds.size.height/20*9
        modalView = SpringView.init()
        modalView.backgroundColor = .white
        self.view.addSubview(modalView)
        modalView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(modalHeight)
//            make.height.equalTo(216+40+20)
        }
        
        let titleView = UIView.init()
        titleView.backgroundColor = .white
        modalView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(50)
        }
        let seperatorLine = UIView.init()
        seperatorLine.backgroundColor = UIColor.init(hex: "#f3f3f3")
        titleView.addSubview(seperatorLine)
        seperatorLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        titleLabel = UILabel.init()
        titleLabel.textColor = UIColor.init(hex: "#333333")
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(titleView)
        }
        
        cancelButton = UIButton.init()
        let cancelAttr = NSAttributedString.init(string: "取消", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(hex: "#666666"), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        cancelButton.setAttributedTitle(cancelAttr, for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(cancelClick(_:)), for: UIControlEvents.touchUpInside)
        titleView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(80)
        }
        
        confirmButton = UIButton.init()
        let confirmAttr = NSAttributedString.init(string: "确认", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(hex: "#fbc400"), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        confirmButton.setAttributedTitle(confirmAttr, for: UIControlState.normal)
        confirmButton.addTarget(self, action: #selector(confirmClick(_:)), for: UIControlEvents.touchUpInside)
        titleView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.width.equalTo(80)
        }
        
        
        pickerView = UIPickerView.init()
        pickerView.delegate = self
//        pickerView.autoresizingMask = .flexibleHeight
        modalView.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalTo(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(0).inset(self.view.safeAreaInsets).offset(0)
            } else {
                make.bottom.equalTo(0)
            }
        }
    
        
        self.cleanSpearatorLine()
        
    }
    

    @objc func dismissTap(_ sender: UITapGestureRecognizer) {
        self.dismissVC()
    }
    @objc func cancelClick(_ sender: UIButton) {
        self.dismissVC()
    }
    @objc func confirmClick(_ sender: UIButton) {
        
        if style == .receive_type {
            delegate?.selectReceiveType(type: dataList[0][pickerView.selectedRow(inComponent: 0)])
        }
        if style == .recipient_type {
            delegate?.selectRecipientType(type: dataList[0][pickerView.selectedRow(inComponent: 0)])
        }
        if style == .date_send || style == .date_receive {
            delegate?.selectDate(yyyyMMdds[pickerView.selectedRow(inComponent: 0)], displayDate: dataList[0][pickerView.selectedRow(inComponent: 0)], hour: dataList[1][pickerView.selectedRow(inComponent: 1)], minute: dataList[2][pickerView.selectedRow(inComponent: 2)], style: style)
//            delegate?.selectDate(dataList[0][pickerView.selectedRow(inComponent: 0)], hour: dataList[1][pickerView.selectedRow(inComponent: 1)], minute: dataList[2][pickerView.selectedRow(inComponent: 2)], style: style)
        }
        if style == .counter {
            if airportCounters == nil {
                delegate?.selectCounter(counter: (BGWUser.current()?.airportCounters[pickerView.selectedRow(inComponent: 0)])!)
            } else {
                delegate?.selectCounter(counter: airportCounters![pickerView.selectedRow(inComponent: 0)])
            }
        }
        if style == .enterprise_counter {
            delegate?.selectEnterpriseCounter(counter: (BGWUser.current()?.enterpriseCounters[pickerView.selectedRow(inComponent: 0)])!)
        }
        
        if style == .address {
            let provRow = pickerView.selectedRow(inComponent: 0)
            let cityRow = pickerView.selectedRow(inComponent: 1)
            delegate?.selectAddress(provinces[provRow], provinceCodes[provRow], currentCitys[cityRow], currentCityCodes[cityRow])
        }
        
        
        self.dismissVC()
    }
    
    func dismissVC() {
        bgView.backgroundColor = .clear
        modalView.animation = "squeezeUp"
        modalView.animateFrom = false
        modalView.duration = 0.5
        modalView.animateToNext(completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func cleanSpearatorLine() {
        for obj in self.pickerView.subviews {
            if obj.frame.size.height < 1.0 {
                obj.backgroundColor = .clear
            }
        }
    }
    

}
