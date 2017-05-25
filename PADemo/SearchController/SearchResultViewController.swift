//
//  SearchResultViewController.swift
//  PADemo
//
//  Created by shuo on 2017/5/17.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }


}
