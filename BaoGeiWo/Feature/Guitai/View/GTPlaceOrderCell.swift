//
//  GTPlaceOrderCell.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/16.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit

protocol GTPlaceOrderCellDelegate {
    func itemTextFieldEndEditing(_ textField: UITextField)
    func itemScanClick()
}

class GTPlaceOrderCell: UITableViewCell, UITextFieldDelegate {

    var delegate: GTPlaceOrderCellDelegate?
    
    public var containerView: UIView!
    var itemTextLabel: UILabel!
    var itemTextField: UITextField!
    var itemImage: UIButton!
//    var itemScanClick: (()->Void)?
//    var itemTextFieldEndEditing: ((_ textField: UITextField)->Void)?
    
//    let itemTexts = [["寄件城市", "寄件地址", "寄件时间", "航班号    "],
//                     ["收件城市", "收件类型", "收件地址", "航班号    ", "门牌号    ", "收件时间"],
//                     ["手机号码", "客户姓名", "证件编号"],
//                     ["行李数量"]]
    let itemArrows = ["寄件时间", "收件城市", "收件类型", "收件人", "收件地址", "收件时间"]
    let itemKeyboardTypeNumbers = ["联系方式", "手机号码"]
    let warningKeys = ["预计时间", "预计里程"]
    public var itemText: String {
        didSet {
            let textString = itemText.replacingOccurrences(of: " ", with: "")
            if textString == "客户姓名" {
//                itemImage.isHidden = false
                itemImage.setImage(UIImage.init(named: "place_order_scan"), for: .normal)
                itemImage.isEnabled = true
            } else if itemArrows.contains(textString) {
                itemImage.setImage(UIImage.init(named: "place_order_arrow"), for: .normal)
                itemImage.isEnabled = false
            } else {
//                itemImage.isHidden = true
                itemImage.setImage(UIImage.init(named: "place_order_blank2"), for: .normal)
                itemImage.isEnabled = false
            }
            
            if itemKeyboardTypeNumbers.contains(textString) {
                itemTextField.keyboardType = .numberPad
            } else {
                itemTextField.keyboardType = .default
            }
            
            if warningKeys.contains(textString) {
                itemTextField.textColor = UIColor.init(hex: "#fd0303")
            } else {
                itemTextField.textColor = UIColor.init(hex: "#333333")
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.itemText = ""
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.init(hex: "#f3f3f3")
        self.selectionStyle = .none
        self.setupPlaceOrderCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlaceOrderCell() {
        containerView = UIView.init()
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        itemTextLabel = UILabel.init()
        itemTextLabel.textColor = UIColor.init(hex: "#666666")
        itemTextLabel.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(itemTextLabel)
        itemTextLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.bottom.equalTo(-10)
        }
        
        itemTextField = UITextField.init()
        itemTextField.delegate = self
        itemTextField.font = UIFont.systemFont(ofSize: 16)
        itemTextField.textColor = UIColor.init(hex: "#333333")
        itemTextField.placeholder = "请选择"
        itemTextField.setValue(UIFont.systemFont(ofSize: 16), forKeyPath: "_placeholderLabel.font")
        containerView.addSubview(itemTextField)
        itemTextField.snp.makeConstraints { (make) in
            make.left.equalTo(itemTextLabel.snp.right).offset(20)
            make.centerY.equalTo(itemTextLabel)
        }
        
        itemImage = UIButton.init()
        itemImage.addTarget(self, action: #selector(itemImageClick(_:)), for: .touchUpInside)
        containerView.addSubview(itemImage)
        itemImage.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(containerView.snp.centerY)
        }
        
        itemTextField.snp.makeConstraints { (make) in
            make.right.equalTo(itemImage.snp.left).offset(-20)
        }
        itemTextField.setContentHuggingPriority(UILayoutPriority.defaultLow-1, for: .horizontal)
        itemTextField.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh-1, for: .horizontal)
    }
    
    
    @objc func itemImageClick(_ sender: UIButton) {
        
        self.delegate?.itemScanClick()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.delegate?.itemTextFieldEndEditing(textField)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
