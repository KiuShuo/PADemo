//
//  UIViewController+PAExtension.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/5/17.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - dismissKeyboard
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

