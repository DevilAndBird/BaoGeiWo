//
//  GTPlaceOrderSectionHeaderCell.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/16.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit

class GTPlaceOrderSectionHeaderCell: GTPlaceOrderCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupPlaceOrderSectionHeaderCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlaceOrderSectionHeaderCell() {
        containerView.snp.remakeConstraints { (make) in
            make.top.equalTo(8)
            make.left.bottom.right.equalTo(0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
