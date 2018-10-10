//
//  SettingViewController.swift
//  PADemo
//
//  Created by shuo on 2017/12/22.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    var tableView: UITableView = UITableView()
    
    fileprivate lazy var consigneeNameItem: SettingTextFieldItem = {
        return (self.configSettingItem(palceholder: "收货人姓名", settingItem: SettingTextFieldItem()) as! SettingTextFieldItem)
    }()
    
    fileprivate lazy var consigneePhoneNumItem: SettingTextFieldItem = {
        return (self.configSettingItem(palceholder: "手机号码", settingItem: SettingTextFieldItem()) as! SettingTextFieldItem)
    }()
    
    fileprivate lazy var pickAddressItem: SettingArrowItem = {
        let item = SettingArrowItem(title: "省、市、区", enable: true, isUserInteractionEnabled: true)
        item.action = { [weak self] item in
            guard let `self` = self else { return }
            self.view.endEditing(true)
            print("选择省市区")
        }
        return item
    }()
    
    fileprivate lazy var consigneePostCodeItem: SettingTextFieldItem = {
        return (self.configSettingItem(palceholder: "邮政编码", settingItem: SettingTextFieldItem()) as! SettingTextFieldItem)
    }()
    
    fileprivate lazy var detailAddressItem: SettingTextViewItem = {
        return (self.configSettingItem(palceholder: "详细地址", settingItem: SettingTextViewItem()) as! SettingTextViewItem)
    }()
    
    private func configSettingItem(palceholder: String, settingItem: SettingItem) -> SettingItem {
        if settingItem is SettingTextFieldItem {
            (settingItem as! SettingTextFieldItem).isCoverTitle = true
        }
        if settingItem is SettingTextViewItem {
            SettingFullTextItem.horizontalIndent = 12
            (settingItem as! SettingTextViewItem).cellInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
            (settingItem as! SettingTextViewItem).textHeight = 88
            (settingItem as! SettingTextViewItem).textViewBackgroundColor = UIColor.white
            (settingItem as! SettingTextViewItem).placeholderX = 3
            (settingItem as! SettingTextViewItem).placeholderY = 7
        }
        settingItem.subtitlePlaceholder = palceholder
        settingItem.subtitlePlaceholderFont = UIFont.systemFont(ofSize: 15)
        settingItem.subtitlePlaceholderColor = UIColor.paGray
        settingItem.subtitlePlaceholderAlignment = NSTextAlignment.left
        settingItem.subtitleAlignment = NSTextAlignment.left
        settingItem.subtitleColor = UIColor.paBlack
        return settingItem
    }
    
    fileprivate lazy var groupItems: [SettingItem] = [consigneeNameItem, consigneePhoneNumItem, pickAddressItem, consigneePostCodeItem, detailAddressItem]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.mas_makeConstraints { (make) in
            make!.edges.equalTo()(UIEdgeInsets(top: UIScreen.navigationHeight, left: 0, bottom: 0, right: 0))
        }
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.reuseIdentifier)
        tableView.separatorInset = .zero
        tableView.separatorColor = .paDividing
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.paBackground
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        // footerView...
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 71))
        footerView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footerView
        let btn = UIButton.orangeBtn2("保存", fontSize: 16)
        btn.frame = CGRect(x: 14, y: 31, width: UIScreen.width - 28, height: 40)
        footerView.addSubview(btn)
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
    @objc private func save() {
        let name = consigneeNameItem.subtitle.noneNull
        let phoneNumber = consigneePhoneNumItem.subtitle.noneNull
        let postCode = consigneePostCodeItem.subtitle.noneNull
        let detailAddress = detailAddressItem.subtitle.noneNull
        print("name = \(name) \n phoneNumber = \(phoneNumber) \n postCode = \(postCode) \n detailAddress = \(detailAddress)")
        
    }
    
}

extension SettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier, for: indexPath)
        if cell is SettingCell {
            let settingItem = groupItems[indexPath.row]
            (cell as! SettingCell).item = settingItem
        }
        return cell
    }
    
}

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return groupItems[indexPath.row].supposedCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = groupItems[indexPath.row]
        guard item.enable else { return }
        item.action?(item)
    }
    
}
