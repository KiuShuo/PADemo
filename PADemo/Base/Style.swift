//
//  Style.swift
//  PADemo
//
//  Created by shuo on 2017/5/17.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

struct Style {
    
    static func setupStyle()  {
        let shadow: NSShadow = {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.paGray
            shadow.shadowOffset = CGSize(width: 0, height: 0)
            return shadow
        }()
        
        let textAttributes: [NSAttributedString.Key: AnyObject] = [
            NSAttributedString.Key.foregroundColor: UIColor.paBlack,
            NSAttributedString.Key.shadow: shadow,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().barTintColor = UIColor.white

        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.paOrange, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.paBlack, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.1)], for: .highlighted)

        
        UISearchBar.appearance().barStyle = .black
        UISearchBar.appearance().barTintColor = UIColor.paBackground
        UISearchBar.appearance().setBackgroundImage(UIImage(color: UIColor.paBackground), for: .any, barMetrics: .default)
        UISearchBar.appearance().setImage(UIImage(named: "search_bar_btn_search_highlight"), for: .search, state: UIControl.State())
        UISearchBar.appearance().setImage(UIImage(named:"search_bar_btn_search_highlight"), for: .search, state: .highlighted)
        UISearchBar.appearance().setImage(UIImage(named: "search_bar_btn_clear"), for: .clear, state: UIControl.State())
        let image = UIImage(color: UIColor.white,size:CGSize(width: 35, height: 28))
        let backgroundImage = image!.stretchableImage(withLeftCapWidth: Int(image!.size.width*0.5), topCapHeight: Int(image!.size.height*0.5))
        UISearchBar.appearance().setSearchFieldBackgroundImage(backgroundImage, for: .normal)
        UISearchBar.appearance().searchTextPositionAdjustment = UIOffset(horizontal: 8, vertical: 0)
    }
}
