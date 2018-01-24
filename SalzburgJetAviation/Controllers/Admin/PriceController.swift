//
//  PriceController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/13/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class PriceController: AdminBaseController {
    
    var publishMode: PublishMode?
    
    var publishDelegate: PublishControllerDelegate?
    var fromWhereController: FromWhereController?
    var emptyLeg: EmptyLeg? {
        didSet {
            
            self.priceTextField.text = self.emptyLeg?.price
            
        }
    }
    
    let priceTextField: UITextField = {
        
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.textColor = .white
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
        
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "€"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.titleLabel.text = "Price"
        
        setupPriceTextField()
        
        priceTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func handleNext() {
        
        if !checkInvalid() {
            return
        }
        
        self.emptyLeg?.price = self.priceTextField.text
        
        if self.fromWhereController == .publish {
            if let price = self.emptyLeg?.price {
                self.publishDelegate?.resetPrice(price)
                self.handleDismissController()
            }
        } else {
            let publishController = PublishController()
            publishController.emptyLeg = self.emptyLeg
            publishController.publishMode = self.publishMode
            navigationController?.pushViewController(publishController, animated: true)
        }
    }
    
    fileprivate func checkInvalid() -> Bool {
        
        if (priceTextField.text?.isEmptyStr)! {
            self.showJHTAlerttOkayWithIcon(message: "Please type the price")
            return false
        }
        return true
    }
    
}

extension PriceController {
    fileprivate func setupPriceTextField() {
    
        
        
        view.addSubview(priceTextField)
        
        _ = priceTextField.anchor(lineView.bottomAnchor, left: lineView.leftAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        view.addSubview(symbolLabel)
        _ = symbolLabel.anchor(lineView.bottomAnchor, left: nil, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        let anotherLineView = UIView()
        anotherLineView.backgroundColor = .lightGray
        
        view.addSubview(anotherLineView)
        _ = anotherLineView.anchor(priceTextField.bottomAnchor, left: lineView.leftAnchor, bottom: nil, right: lineView.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    
    }
}











