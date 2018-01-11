//
//  LRProtocol.swift
//  PADemo
//
//  Created by shuoliu on 2018/1/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UILabel {
    
    var validationResult: Binder<Result> {
        return Binder(self.base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
    
}

extension Reactive where Base: UITextField {
    
    var inputEnable: Binder<Result> {
        return Binder(self.base) { textField, result in
            textField.isEnabled = result.isValid
        }
    }
    
}
