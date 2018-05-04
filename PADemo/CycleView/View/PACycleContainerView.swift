//
//  PACycleContainerView.swift
//  feng
//
//  Created by shuoliu on 16/5/23.
//  Copyright © 2016年 shuo. All rights reserved.
//

import UIKit

protocol PACycleCacheProtocol {
    var bufferDic: [Int: UIView?] { get set }
    var maxBufferCount: Int { get set }
    
    mutating func show(showView view: UIView, showViewIndex index: Int)
}

extension PACycleCacheProtocol where Self: UIScrollView {
    
    mutating func show(showView view: UIView, showViewIndex index: Int) {
        view.frame = bounds
        
        bufferDic[index] = view
        for (_, var view) in bufferDic {
            view?.removeFromSuperview()
            view = nil
        }
        
        let cacheCount = (maxBufferCount - 1) / 2
        for i in index - cacheCount...index + cacheCount {
            if let view = bufferDic[i] {
                addSubview(view!)
            }
        }
    }
    
}

class PACycleContainerView: UIScrollView, PACycleCacheProtocol {
    var bufferDic: [Int: UIView?] = [:]
    var maxBufferCount: Int = 3
}
