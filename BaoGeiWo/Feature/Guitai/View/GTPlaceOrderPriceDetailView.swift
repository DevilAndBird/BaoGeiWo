//
//  GTPlaceOrderPriceDetailView.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/25.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit

class GTPlaceOrderPriceDetailView: UIView {

    var bgView: UIView!
    var dismissView: (()->Void)?
    
    var baggagePriceLabel: UILabel!
    var safePriceLabel: UILabel!
    var extraPriceLabel: UILabel!
    
    @objc func dismissTap(_ sender: UITapGestureRecognizer) {
        if dismissView != nil {
            self.dismissView!()
        }
    }
    
    @objc init(_ distance: Int, _ baggageNumber: Int, _ safeTag: Int, _ nightNum: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        bgView = UIView.init()
        bgView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        bgView.isHidden = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissTap(_:)))
        bgView.addGestureRecognizer(tap)
        self.addSubview(bgView);
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0).offset(-60)
        }
        
        let containerView = UIView.init()
        containerView.backgroundColor = .white
        self.addSubview(containerView);
        containerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        let textColor = UIColor.init(hex: "#666666")
        let font = UIFont.systemFont(ofSize: 16)
        
        let priceColor = UIColor.init(hex: "#333333")
        
        
        let detailLabel = UILabel.init(textColor, UIFont.boldSystemFont(ofSize: 16))
        detailLabel.text = "价格明细"
        containerView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
        }
        
        let baggageLabel = UILabel.init(textColor, font)
        baggageLabel.text = "行李寄送费用"
        containerView.addSubview(baggageLabel)
        baggageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(detailLabel.snp.bottom).offset(20)
            make.left.equalTo(detailLabel)
        }
        baggagePriceLabel = UILabel.init(priceColor, font)
        containerView.addSubview(baggagePriceLabel)
        baggagePriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(baggageLabel)
            make.right.equalTo(-35)
        }
        
        let safeLabel = UILabel.init(textColor, font)
        safeLabel.text = "行李保价"
        containerView.addSubview(safeLabel)
        safeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(baggageLabel.snp.bottom).offset(20)
            make.left.equalTo(detailLabel)
        }
        safePriceLabel = UILabel.init(priceColor, font)
        containerView.addSubview(safePriceLabel)
        safePriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeLabel)
            make.right.equalTo(baggagePriceLabel)
        }
        
        let extraLabel = UILabel.init(textColor, font)
        containerView.addSubview(extraLabel)
        extraLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safeLabel.snp.bottom).offset(20)
            make.left.equalTo(detailLabel)
            make.bottom.equalTo(-20)
        }
        extraPriceLabel = UILabel.init(priceColor, font)
        containerView.addSubview(extraPriceLabel)
        extraPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(extraLabel)
            make.right.equalTo(baggagePriceLabel)
        }
        
        
        if distance > -1 {
            
            extraLabel.text = "额外行李费用"
        } else {
            
            extraLabel.text = "过夜费用"
        }

        
    }
    
    func setPriceDetail(_ distance: Int, _ baggageNumber: Int, _ safeTag: Int, _ nightNum: Int) {
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
                return
            }
            guard (BGWUser.current()?.orderPricingRule.specialPricingRule != nil) else {
                return
            }
            let rule = BGWUser.current()?.orderPricingRule.specialPricingRule
            var bagPrice = (rule?.startPrice)!
            if distance > (rule?.startDistance)! {
                bagPrice += (distance-(rule?.startDistance)!) * (rule?.perKmPrice)!
            }
            baggagePriceLabel.text = "¥ " + bagPrice.description
            
            safePriceLabel.text = "¥ " + safePrice.description
            
            var extraPrice = 0
            if baggageNumber > (rule?.extraBagNum)!-1 {
                extraPrice += (baggageNumber-((rule?.extraBagNum)!-1))*(rule?.extraBagPrice)!
            }
            extraPriceLabel.text = "¥ " + extraPrice.description
            
        } else {
            guard (BGWUser.current()?.orderPricingRule != nil) else {
                return
            }
            guard (BGWUser.current()?.orderPricingRule.goldPricingRule != nil) else {
                return
            }
            let rule = BGWUser.current()?.orderPricingRule.goldPricingRule
            baggagePriceLabel.text = "¥ " + String(Int((rule?.unitPrice)!)!*baggageNumber)
            safePriceLabel.text = "¥ " + safePrice.description
            var nightPrice = 0
            if nightNum > Int((rule?.nightNum)!)!-1 {
                nightPrice = (nightNum-(Int((rule?.nightNum)!)!-1))*Int((rule?.overnightPrice)!)!
            }
            extraPriceLabel.text = "¥ " + nightPrice.description
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
