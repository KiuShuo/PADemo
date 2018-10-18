//
//  Wireframe.swift
//  PADemo
//
//  Created by shuo on 2018/10/18.
//  Copyright © 2018年 shuo. All rights reserved.
//

import RxSwift
import UIKit

protocol Wireframe {
    func open(url: URL)
    func promptFor<Action: CustomStringConvertible>(_ messahe: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

class DefaultWireframe: Wireframe {
    
    static let share = DefaultWireframe()
    
    func open(url: URL) {
        UIApplication.shared.openURL(url)
    }
    
    func promptFor<Action>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> where Action : CustomStringConvertible {
        return Observable.create({ (observer) -> Disposable in
            let alertView = UIAlertController(title: "PADemo", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel, handler: { (_) in
                observer.on(.next(cancelAction))
            }))
            for action in actions {
                alertView.addAction(UIAlertAction(title: action.description, style: .default, handler: { (_) in
                    observer.on(.next(action))
                }))
            }
            DefaultWireframe.rootViewController().present(alertView, animated: true, completion: nil)
            return Disposables.create {
                alertView.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    private static func rootViewController() -> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
}
