//
//  SimpleValidationViewController.swift
//  PADemo
//
//  Created by shuo on 2017/12/27.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleValidationViewController: RXBaseViewController {

    @IBOutlet weak var userNameOutlet: UITextField!
    @IBOutlet weak var userNameValidOutlet: UILabel!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passworkValidOutlet: UILabel!
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    let minimalUsernameLength = 5
    let minimalPasswordLength = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 有户名是否有效
        let userNameValid = userNameOutlet.rx.text.orEmpty.map { [weak self] text -> Bool in
            guard let `self` = self else { return false }
            return text.count >= self.minimalUsernameLength
        }.share(replay: 1)
        // share 共享资源的意思
        // 用户名是否有效 -> 用户名提示信息是否显示、 密码输入框是否有效
        userNameValid.bind(to: userNameValidOutlet.rx.isHidden).disposed(by: disposeBag)
        userNameValid.bind(to: passwordOutlet.rx.isEnabled).disposed(by: disposeBag)
        
        // 密码是否有效
        let passwordValid = passwordOutlet.rx.text.orEmpty.map { [weak self] text -> Bool in
            guard let `self` = self else { return false }
            return text.count >= self.minimalPasswordLength
        }.share(replay: 1)
        passwordValid.bind(to: passworkValidOutlet.rx.isHidden).disposed(by: disposeBag)
        
        // 所有输入是否有效
        let everythingValid = Observable.combineLatest(userNameValid, passwordValid) { $0 && $1 }.share(replay: 1)
        // 所有输入是否有效 -> 绿色按钮是否可点击
        everythingValid.bind(to: doSomethingOutlet.rx.isEnabled).disposed(by: disposeBag)
        
        doSomethingOutlet.rx.tap.subscribe(onNext: { [weak self] in self?.showAlertView() }).disposed(by: disposeBag)
    }
    
    func showAlertView() {
        let alertViewController = UIAlertController(title: "登录", message: "是否确定登录？", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "好的", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
    func showLearnRxSwiftViewController() {
        performSegue(withIdentifier: "toLRxSwiftViewController", sender: nil)
    }
    
    @IBAction func clickLearnButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toLRxSwiftViewController", sender: nil)
    }

}
