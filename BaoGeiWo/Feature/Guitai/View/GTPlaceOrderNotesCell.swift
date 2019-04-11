//
//  GTPlaceOrderNotesCell.swift
//  BaoGeiWo
//
//  Created by wb on 2018/10/30.
//  Copyright © 2018 qyqs. All rights reserved.
//

import UIKit


protocol GTPlaceOrderNotesCellDelegate {
    
    func textViewEndEditing(_ textView: UITextView)
}

class GTPlaceOrderNotesCell: UITableViewCell, UITextViewDelegate {

    var delagate: GTPlaceOrderNotesCellDelegate?
    var textView: UITextView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.init(hex: "#f3f3f3")
        self.selectionStyle = .none
        self.setGTPlaceOrderNotesCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGTPlaceOrderNotesCell() {
        
        let containerView = UIView.init()
        containerView.backgroundColor = .white
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-8)
            make.height.equalTo(80)
        }
        
        let notesLabel = UILabel.init(UIColor.init(hex: "#666666"), UIFont.systemFont(ofSize: 16))
        notesLabel.text = "备注"
        containerView.addSubview(notesLabel)
        notesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(20)
        }
        
        textView = UITextView.init()
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(notesLabel.snp.right).offset(15)
            make.right.equalTo(-20)
            make.bottom.equalTo(0)
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delagate?.textViewEndEditing(textView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
