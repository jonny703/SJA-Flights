//
//  AdminBaseController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class AdminBaseController: UIViewController {
    
    let lineView = UIView()
    
    let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick Aircraft"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.check.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = StyleGuideManager.mainYellowColor
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.leftArrow.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(handleDismissController), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: AssetName.cross.rawValue)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @objc func handleDelete() {
        
        self.showJHTAlertDefaultWithIcon(message: "Are you sure you want to cancel, all data will be lost?", firstActionTitle: "Continue Leg", secondActionTitle: "Cancel Leg") { (action) in
            self.navigationController?.popToRootViewController(animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                NotificationCenter.default.post(name: .HandlePoppingToRootNav, object: nil)
            })
        }
        
    }
    
    @objc func handleDismissController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNext() {
        
    }
    
    func setupViews() {
        setupBackgrounds()
    }
    
    private func setupBackgrounds() {
        
        view.backgroundColor = StyleGuideManager.mainBackgroundColor
        
        view.addSubview(titleLabel)
        _ = titleLabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 30)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        lineView.backgroundColor = .lightGray
        view.addSubview(lineView)
        
        _ = lineView.anchor(titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 1)
        lineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(deleteButton)
        _ = deleteButton.anchor(nil, left: lineView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 85, heightConstant: 45)
        deleteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        view.addSubview(backButton)
        _ = backButton.anchor(nil, left: lineView.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 65)
        
        view.addSubview(checkButton)
        _ = checkButton.anchor(nil, left: nil, bottom: nil, right: lineView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 65)
        checkButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        
        view.addSubview(bottomLineView)
        
        _ = bottomLineView.anchor(nil, left: lineView.leftAnchor, bottom: backButton.topAnchor, right: lineView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        
    }
    
}
