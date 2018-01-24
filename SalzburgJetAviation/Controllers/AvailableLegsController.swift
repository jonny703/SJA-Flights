//
//  AvailableLegsController.swift
//  SalzburgJetAviation
//
//  Created by John Nik on 12/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import KRPullLoader

class AvailableLegsController: UIViewController {
    
    let cellId = "cellId"
    
    var emptyLegs = [EmptyLeg]()
    
    let legsLabel = UILabel()
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.delegate = self
        tv.dataSource = self
        return tv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        handleFetchEmptyLegs()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
    }
    
}

//MARK: handle fetch empty legs
extension AvailableLegsController {
    
    fileprivate func handleFetchEmptyLegs() {
        
        self.emptyLegs.removeAll()
        
        APIService.sharedInstance.fetchEmptyLegs { (emptyLegs: [EmptyLeg]) in
            self.emptyLegs = emptyLegs
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: handle krpullloader delegate
extension AvailableLegsController: KRPullLoadViewDelegate {
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        
        if type == .loadMore {
            switch state {
                
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    
                }
                
            default:
                break
            }
            
            return
        }
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = "Pull more."
            } else {
                pullLoadView.messageLabel.text = "Release to refresh."
            }
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "Updating..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
                self.handleFetchEmptyLegs()
            }
        }
        
    }
}

//MARK: handle table view
extension AvailableLegsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.emptyLegs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeEmptyLegCell
        
        let emptyLeg = self.emptyLegs[indexPath.section]
        cell.emptyLeg = emptyLeg
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

//MARK: handle call
extension AvailableLegsController {
    
    @objc fileprivate func handleCall() {
        let strPhoneNumber = "+4366285809090"
        if let phoneCallURL = URL(string: "tel://\(strPhoneNumber)") {
            let application = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
}

extension AvailableLegsController {
    
    fileprivate func setupViews() {
        
        setupBackgrounds()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView.register(HomeEmptyLegCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        _ = tableView.anchor(legsLabel.bottomAnchor, left: view.leftAnchor, bottom: self.bottomLayoutGuide.topAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        
        let refreshView = KRPullLoadView()
        refreshView.delegate = self
        tableView.addPullLoadableView(refreshView, type: .refresh)
    }
        
        
    
    private func setupBackgrounds() {
        
        view.backgroundColor = StyleGuideManager.mainBackgroundColor
        
        let topContrainerView = UIView()
        topContrainerView.backgroundColor = StyleGuideManager.mainDarkBackgroundColor
        
        let logoImageView = UIImageView()
        let logoImage = UIImage(named: AssetName.logo.rawValue)
        logoImageView.image = logoImage
        
        let logoImageViewWidth: CGFloat = 180
        let logoImageViewHeight = logoImageViewWidth * logoImage!.size.height / logoImage!.size.width
        let topContainerViewHeight = 30 + logoImageViewHeight + 10 + 25 + 20 + 0.5 + 10 + 20 + 10 + 30
        
        view.addSubview(topContrainerView)
        _ = topContrainerView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: topContainerViewHeight)
        
        view.addSubview(logoImageView)
        
        _ = logoImageView.anchor(view.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: logoImageViewWidth, heightConstant: logoImageViewHeight)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 25).isActive = true
        
        let scoutLabel = UILabel()
        scoutLabel.text = "Empty Leg Scout"
        scoutLabel.textColor = .lightGray
        scoutLabel.font = UIFont.systemFont(ofSize: 22)
        scoutLabel.textAlignment = .center
        
        view.addSubview(scoutLabel)
        
        _ = scoutLabel.anchor(logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 25)
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = StyleGuideManager.mainLineBackgroundColor
        
        view.addSubview(bottomLine)
        
        _ = bottomLine.anchor(scoutLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 0.5)
        
        let bookLabel = UILabel()
        bookLabel.text = "To book a flight, please call us anytime at"
        bookLabel.textColor = .gray
        bookLabel.textAlignment = .center
        bookLabel.font = UIFont.systemFont(ofSize: 17)
        
        view.addSubview(bookLabel)
        
        _ = bookLabel.anchor(bottomLine.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        let phoneButton = UIButton()
        phoneButton.setTitle("+43 662 8580 9090", for: .normal)
        phoneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        phoneButton.setTitleColor(StyleGuideManager.mainYellowColor, for: .normal)
        phoneButton.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        
        view.addSubview(phoneButton)
        
        _ = phoneButton.anchor(bookLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        let lineView = UIView()
        lineView.backgroundColor = StyleGuideManager.mainLineBackgroundColor
        
        view.addSubview(lineView)
        
        _ = lineView.anchor(phoneButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        
        legsLabel.text = "Currently available legs:"
        legsLabel.textColor = .gray
        legsLabel.font = UIFont.systemFont(ofSize: 16)
        
        view.addSubview(legsLabel)
        
        _ = legsLabel.anchor(lineView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)
    }
    
    fileprivate func setupNavBar() {
        
        navigationController?.isNavigationBarHidden = true
        
        
    }
    
}

