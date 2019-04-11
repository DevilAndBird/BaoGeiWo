//
//  OrderPriceDetailViewController.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/10.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit

class OrderPriceDetailViewController: UIViewController {

    var priceDetail: OrderDetailPriceDetailModel
    var modalView: SpringView!
    
    
    
    @objc init(priceModel: OrderDetailPriceDetailModel) {
        self.priceDetail = priceModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear

        // Do any additional setup after loading the view.
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        self.view.addSubview(bgView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissTap(_ :)))
        bgView.addGestureRecognizer(tap)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        let textFont = UIFont.systemFont(ofSize: 16)
        let textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        
        modalView = SpringView.init()
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 5.0
        modalView.layer.masksToBounds = true
        self.view.addSubview(modalView)
        modalView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.left.equalTo(40)
        }
        
        let baggageTitleLabel = self.customLabel("行李规格:", textFont, textColor)
        modalView.addSubview(baggageTitleLabel)
        baggageTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        let baggageListView = UIView.init()
        modalView.addSubview(baggageListView)
        baggageListView.snp.makeConstraints { (make) in
            make.top.equalTo(baggageTitleLabel.snp.bottom)
            make.left.right.equalTo(baggageTitleLabel)
        }
        
//        let bagCount = priceDetail.priceList.keys.count
//        let index = 1
        var temp: UILabel?
        for (key, value) in priceDetail.priceList {
            let baggage = self.customLabel(key as! String, textFont, textColor)
            baggageListView.addSubview(baggage)
            baggage.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.left.equalTo(25)
            }
            
            let price = self.customLabel(value as! String, textFont, textColor)
            baggageListView.addSubview(price)
            price.snp.makeConstraints { (make) in
                make.top.equalTo(baggage)
                make.right.equalTo(0)
            }
            
            temp = baggage
//            if index == bagCount {
//                baggage.snp.makeConstraints { (make) in
//                    make.bottom.equalTo(baggageListView)
//                }
//            }
        }
        temp?.snp.makeConstraints { (make) in
            make.bottom.equalTo(baggageListView)
        }

        
        let safetyLabel = self.customLabel("保价费用:", textFont, textColor)
        modalView.addSubview(safetyLabel)
        safetyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(baggageListView.snp.bottom).offset(10)
            make.left.equalTo(baggageTitleLabel)
        }
        let safetyPrice = self.customLabel(priceDetail.safetyPrice, textFont, textColor)
        modalView.addSubview(safetyPrice)
        safetyPrice.snp.makeConstraints { (make) in
            make.top.equalTo(safetyLabel)
            make.right.equalTo(baggageTitleLabel)
        }
        
        let extraLabel = self.customLabel("增值费用:", textFont, textColor)
        modalView.addSubview(extraLabel)
        extraLabel.snp.makeConstraints { (make) in
            make.top.equalTo(safetyLabel.snp.bottom).offset(10)
            make.left.equalTo(baggageTitleLabel)
        }
        let extraPrice = self.customLabel(priceDetail.extraPrice, textFont, textColor)
        modalView.addSubview(extraPrice)
        extraPrice.snp.makeConstraints { (make) in
            make.top.equalTo(extraLabel)
            make.right.equalTo(baggageTitleLabel)
        }
        
        let separateLine = UIView.init()
        separateLine.backgroundColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
        modalView.addSubview(separateLine)
        separateLine.snp.makeConstraints { (make) in
            make.top.equalTo(extraLabel.snp.bottom).offset(10)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        let totalLabel = self.customLabel("总计:", textFont, textColor)
        modalView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(separateLine.snp.bottom).offset(10)
            make.left.equalTo(baggageTitleLabel)
            make.bottom.equalTo(modalView.snp.bottom).offset(-15)
        }
        let totalPrice = self.customLabel(priceDetail.totalPrice, textFont, textColor)
        modalView.addSubview(totalPrice)
        totalPrice.snp.makeConstraints { (make) in
            make.top.equalTo(totalLabel)
            make.right.equalTo(baggageTitleLabel)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        modalView.animation = "slideUp"
        modalView.animation = "fadeInUp"
        modalView.animate()
    }
    
    
    @objc func dismissTap(_ sender: UITapGestureRecognizer) {
        modalView.animation = "fadeInUp"
        modalView.animateFrom = false
        modalView.duration = 0.5
        modalView.animateToNext(completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func customLabel(_ text: String, _ textFont: UIFont, _ textColor: UIColor) -> UILabel {
        let label = UILabel.init()
        label.text = text
        label.font = textFont
        label.textColor = textColor
        return label
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
