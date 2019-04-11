//
//  GTPlaceOrderBaggageCell.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/22.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit

class WQButton: UIButton {

    override var isSelected: Bool {
        willSet {
//            print("changing from \(isSelected) to \(newValue)")
            super.isSelected = newValue
        }
        
        didSet {
//            print("changed from \(oldValue) to \(isSelected)")
        }
    }
    
}


class GTPlaceOrderBaggageCell: UITableViewCell, UITextFieldDelegate {

    var containerView: UIView!
    var selectedButton: WQButton?
    var numberTF: UITextField!
    
    var numberChange: ((_ number: Int)->Void)?
    var safeTagChange: ((_ tag: Int)->Void)?
    
    var baggageNumber: Int {
        didSet {
            numberTF.text = String(baggageNumber)
            if numberChange != nil {
                numberChange!(baggageNumber)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.baggageNumber = 1
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.init(hex: "#f3f3f3")
        self.selectionStyle = .none
        self.setupPlaceOrderBaggageCell()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCellContent(_ baggageNum: Int, _ safeTag: Int) {
        numberTF.text = String(self.baggageNumber)
        if safeTag != 0 {
            let btn = self.containerView.viewWithTag(safeTag) as! WQButton
            btn.isSelected = true
            btn.layer.borderColor = UIColor.init(hex: "#fbc400").cgColor
            self.selectedButton = btn
//            self.safePriceClick(self.containerView.viewWithTag(safeTag) as! WQButton)
        }
    }
    
    func setupPlaceOrderBaggageCell() {
        
        containerView = UIView.init()
        containerView.backgroundColor = .white
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.bottom.right.equalTo(0)
        }
        
        let numberLabel = UILabel.init(UIColor.init(hex: "#666666"), UIFont.systemFont(ofSize: 16))
        numberLabel.text = "行李数量"
        containerView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(20)
        }
        
        let plusButton = UIButton.init()
        plusButton.setImage(UIImage.init(named: "plus"), for: .normal)
        plusButton.addTarget(self, action: #selector(plus(_:)), for: .touchUpInside)
        containerView.addSubview(plusButton)
        plusButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberLabel)
            make.right.equalTo(-35)
        }
        
        numberTF = UITextField.init()
        numberTF.keyboardType = .numberPad
        numberTF.textAlignment = .center
        numberTF.textColor = UIColor.init(hex: "#333333")
        numberTF.text = String(self.baggageNumber)
        numberTF.delegate = self
        containerView.addSubview(numberTF)
        numberTF.snp.makeConstraints { (make) in
            make.right.equalTo(plusButton.snp.left).offset(-20)
            make.width.equalTo(40)
            make.height.equalTo(30)
            make.centerY.equalTo(numberLabel)
        }
        
        let minusButton = UIButton.init()
        minusButton.setImage(UIImage.init(named: "minus"), for: .normal)
        minusButton.addTarget(self, action: #selector(minus(_:)), for: .touchUpInside)
        containerView.addSubview(minusButton)
        minusButton.snp.makeConstraints { (make) in
            make.right.equalTo(numberTF.snp.left).offset(-20)
            make.centerY.equalTo(numberLabel)
        }
        
        
        let safeLabel = UILabel.init(UIColor.init(hex: "#666666"), UIFont.systemFont(ofSize: 16))
        safeLabel.text = "保价服务"
        containerView.addSubview(safeLabel)
        safeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numberLabel.snp.bottom).offset(20)
            make.left.equalTo(20)
        }
        
        
        let safePrice1 = WQButton.init()
        safePrice1.tag = 1
        self.setSafePrice(safePrice1, "0¥", "1000¥ /件", UIColor.init(hex: "#999999"), UIColor.init(hex: "#fbc400"))
        containerView.addSubview(safePrice1)
        safePrice1.snp.makeConstraints { (make) in
            make.top.equalTo(safeLabel.snp.bottom).offset(20)
            make.left.equalTo(35)
            make.bottom.equalTo(-20)
        }

        
        let safePrice2 = WQButton.init()
        safePrice2.tag = 2
        self.setSafePrice(safePrice2, "6¥", "2000¥ /件", UIColor.init(hex: "#999999"), UIColor.init(hex: "#fbc400"))
        containerView.addSubview(safePrice2)
        safePrice2.snp.makeConstraints { (make) in
            make.top.equalTo(safePrice1)
            make.left.equalTo(safePrice1.snp.right).offset(25)
            make.bottom.equalTo(safePrice1)
            make.width.equalTo(safePrice1)
        }
        
        
        let safePrice3 = WQButton.init()
        safePrice3.tag = 3
        self.setSafePrice(safePrice3, "12¥", "4000¥ /件", UIColor.init(hex: "#999999"), UIColor.init(hex: "#fbc400"))
        containerView.addSubview(safePrice3)
        safePrice3.snp.makeConstraints { (make) in
            make.top.equalTo(safePrice1)
            make.left.equalTo(safePrice2.snp.right).offset(25)
            make.bottom.equalTo(safePrice1)
            make.right.equalTo(-35)
            make.width.equalTo(safePrice2)
        }
        
    }
    
    @objc func plus(_ sender: UIButton) {
        self.baggageNumber += 1
    }
    
    @objc func minus(_ sender: UIButton) {
        self.baggageNumber = max(1, self.baggageNumber-1)
    }
    
    @objc func safePriceClick(_ sender: WQButton) {
        sender.isSelected = !sender.isSelected
        if selectedButton != sender {
            selectedButton?.isSelected = false
            selectedButton?.layer.borderColor = UIColor.init(hex: "#999999").cgColor
            selectedButton = sender;
        }
        
        if sender.isSelected {
            sender.layer.borderColor = UIColor.init(hex: "#fbc400").cgColor
            if self.safeTagChange != nil {
                self.safeTagChange!(sender.tag)
            }
        } else {
            sender.layer.borderColor = UIColor.init(hex: "#999999").cgColor
            if self.safeTagChange != nil {
                self.safeTagChange!(0)
            }
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.baggageNumber = max(1, Int(textField.text!)!)
    }
    
    
    func setSafePrice(_ button: WQButton, _ topText: String, _ bottomText: String, _ normalColor: UIColor, _ selectedColor: UIColor) {
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = NSTextAlignment.center
        
        button.layer.borderColor = UIColor.init(hex: "#999999").cgColor
        button.layer.borderWidth = 0.5
        
        let normalAttr = NSMutableAttributedString.init(string: "\(topText)\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: normalColor])
        normalAttr.append(NSAttributedString.init(string: bottomText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: normalColor]))
        let selectedAttr = NSMutableAttributedString.init(string: "\(topText)\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: selectedColor])
        selectedAttr.append(NSAttributedString.init(string: bottomText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: selectedColor]))
        button.setAttributedTitle(normalAttr, for: .normal)
        button.setAttributedTitle(selectedAttr, for: .selected)
        
        button.addTarget(self, action: #selector(safePriceClick(_:)), for: .touchUpInside)
    }
    

    
    
}


