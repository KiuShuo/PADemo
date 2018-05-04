//
//  UIViewController+PAExtension.swift
//  feng
//
//  Created by luozhijun on 2017/5/17.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - dismissKeyboard
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

