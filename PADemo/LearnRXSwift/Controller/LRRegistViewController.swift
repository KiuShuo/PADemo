//
//  LRRegistViewController.swift
//  PADemo
//
//  Created by shuo on 2018/1/5.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class LRRegistViewController: RXBaseViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var againPasswordTextField: UITextField!
    @IBOutlet weak var usernameValidLabel: UILabel!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var againPasswordValidLabel: UILabel!
    
    @IBOutlet weak var registButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = RegisterViewModel()
        /**
         usernameTextField.rx.text.orEmpty 是RxCocoa中的东西，他把textField中的text变成了一个Observable。
         bind(to:) 绑定，也就是监听，viewMolel.username此时作为Observer来监听Observable usernameTextField的text的变化。
         因为有了监听，就要有监听资源的回收，所以我们创建了一个disposeBag来盛放我们这些监听的资源。
         bbb
         
         */
        usernameTextField.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: disposeBag)
        
        viewModel.usernameUsable.bind(to: usernameValidLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.usernameUsable.bind(to: passwordTextField.rx.inputEnable).disposed(by: disposeBag)
        
        // passwordTextField.text -> viewModel.password
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        viewModel.passwordUsable.bind(to: passwordValidLabel.rx.validationResult).disposed(by: disposeBag)
        viewModel.passwordUsable.bind(to: againPasswordTextField.rx.inputEnable).disposed(by: disposeBag)
        
    }

    @IBAction func clickCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
