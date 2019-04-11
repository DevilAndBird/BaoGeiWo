//
//  GTPlaceOrderPriceView.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/22.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit

class GTPlaceOrderPriceView: UIView {

    var totalLabel: UILabel!
    var priceLabel: UILabel!
    var extraPromptLabel: UILabel!
    var priceDetail: UIButton!
    var flag = false {
        didSet {
            if flag {
                priceDetail.imageView?.transform = CGAffineTransform(rotationAngle: .pi/2)
            } else {
                priceDetail.imageView?.transform = CGAffineTransform(rotationAngle: .pi/2*3)
            }
        }
    }
    var priceIsShow = true {
        didSet {
            totalLabel.isHidden = !priceIsShow
            priceLabel.isHidden = !priceIsShow
            extraPromptLabel.isHidden = !priceIsShow
            priceDetail.isHidden = !priceIsShow
        }
    }
    
    var showPriceDetail: ((_ flag: Bool)->Void)?
    var commitOrder: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
        self.layer.shadowOpacity = 0.1
        
        totalLabel = UILabel.init(UIColor.init(hex: "#333333"), UIFont.systemFont(ofSize: 16))
        totalLabel.text = "费用合计:"
        self.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(20)
        }
        
        
        priceLabel = UILabel.init()
//        priceLabel.text = "68.00"
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(totalLabel)
            make.left.equalTo(totalLabel.snp.right).offset(10)
        }
        
        extraPromptLabel = UILabel.init(UIColor.init(hex: "#999999"), UIFont.systemFont(ofSize: 12))
        extraPromptLabel.text = "    "
        self.addSubview(extraPromptLabel)
        extraPromptLabel.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.left.equalTo(priceLabel)
            make.bottom.equalTo(-10)
        }
        
        let commitOrder = UIButton.init()
        let commitAttr = NSAttributedString.init(string: "确认", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.white])
        commitOrder.setAttributedTitle(commitAttr, for: .normal)
        commitOrder.backgroundColor = UIColor.init(hex: "#fbc400")
        commitOrder.addTarget(self, action: #selector(commitOrderClick(_:)), for: .touchUpInside)
        self.addSubview(commitOrder)
        commitOrder.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(0)
            make.width.equalTo(100)
        }

        priceDetail = UIButton.init()
        let detailAttr = NSAttributedString.init(string: "明细", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(hex: "#999999"), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        priceDetail.setAttributedTitle(detailAttr, for: .normal)
        priceDetail.setImage(UIImage.init(named: "place_order_arrow"), for: .normal)
        priceDetail.imageView?.transform = CGAffineTransform(rotationAngle: .pi/2*3)
        priceDetail.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0)
        priceDetail.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
        priceDetail.addTarget(self, action: #selector(priceDetailClick(_:)), for: .touchUpInside)
        self.addSubview(priceDetail)
        priceDetail.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(commitOrder.snp.left).offset(-10)
        }
//        let priceDetail = UILabel.init(UIColor.init(hex: "#999999"), UIFont.systemFont(ofSize: 14), .right)
//        priceDetail.text = "明细 "
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func commitOrderClick(_ sender: UIButton) {
        if self.commitOrder != nil {
            self.commitOrder!()
        }
    }
    
    @objc func priceDetailClick(_ sender: UIButton) {
        self.flag = !self.flag
        if self.showPriceDetail != nil {
            self.showPriceDetail!(self.flag)
        }
    }
    
    
    func setSpecOrderPrice(_ distance: Int, _ bagNum: Int, _ safeTag: Int) -> String {
        return self.setTotalPrice(distance, bagNum, safeTag, 0)
    }
    
    func setOrdiOrderPrice(_ bagNum: Int, _ safeTag: Int, _ nightNum: Int) -> String {
        return self.setTotalPrice(-1, bagNum, safeTag, nightNum)
    }
    
    func setTotalPrice(_ distance: Int , _ baggageNumber: Int, _ safeTag: Int, _ nightNum: Int) -> String {
        
        var safePrice = 0
        switch safeTag {
        case 1:
            safePrice = 0
            break
        case 2:
            safePrice = 6
            break
        case 3:
            safePrice = 12
            break
        default:
            safePrice = 0
            break
        }
        
        if distance > -1 {
            guard (BGWUser.current()?.orderPricingRule != nil) else {
                return "0"
            }
            guard (BGWUser.current()?.orderPricingRule.specialPricingRule != nil) else {
                return "0"
            }
            let specRule = BGWUser.current()?.orderPricingRule.specialPricingRule
            var price = (specRule?.startPrice)! + safePrice
            if distance > (specRule?.startDistance)! {
                price += (distance-(specRule?.startDistance)!) * (specRule?.perKmPrice)!
            }
            if baggageNumber > (specRule?.extraBagNum)!-1 {
                price += (baggageNumber-((specRule?.extraBagNum)!-1))*(specRule?.extraBagPrice)!
            }
            
            let priceAttr = NSMutableAttributedString.init(string: "¥ ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.init(hex: "#333333")])
            priceAttr.append(NSAttributedString.init(string: price.description, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.init(hex: "#fd0303")]))
            self.priceLabel.attributedText = priceAttr
            
            return price.description
            
        } else {
            guard (BGWUser.current()?.orderPricingRule != nil) else {
                return "0"
            }
            guard (BGWUser.current()?.orderPricingRule.goldPricingRule != nil) else {
                return "0"
            }
            let rule = BGWUser.current()?.orderPricingRule.goldPricingRule
            var nightPrice = 0 //过夜费
            if nightNum > Int((rule?.nightNum)!)!-1 { //减去减免天数
                nightPrice = (nightNum-(Int((rule?.nightNum)!)!-1))*Int((rule?.overnightPrice)!)!
            }
            let price: Int = Int((rule?.unitPrice)!)!*baggageNumber+safePrice+nightPrice
            let priceAttr = NSMutableAttributedString.init(string: "¥ ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.init(hex: "#333333")])
            priceAttr.append(NSAttributedString.init(string: price.description, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.init(hex: "#fd0303")]))
            self.priceLabel.attributedText = priceAttr
            
            extraPromptLabel.text = "行李过夜费" + (rule?.overnightPrice)! + "元/件"
            
            return price.description
        }
        
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
