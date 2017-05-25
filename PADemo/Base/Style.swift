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
            shadow.shadowColor = UIColor.paGrayColor()
            shadow.shadowOffset = CGSize(width: 0, height: 0)
            return shadow
        }()
        
        let textAttributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: UIColor.paBlackColor(),
            NSShadowAttributeName: shadow,
            NSFontAttributeName: UIFont.systemFont(ofSize: 17)
        ]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().barTintColor = UIColor.white
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.paOrangeColor(),NSFontAttributeName:UIFont.systemFont(ofSize: 15)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.paBlackColor()], for: .highlighted)
        
        UISearchBar.appearance().barStyle = .black
        UISearchBar.appearance().barTintColor = UIColor.paBackgroundColor()
        UISearchBar.appearance().setBackgroundImage(UIImage(color: UIColor.paBackgroundColor()), for: .any, barMetrics: .default)
        UISearchBar.appearance().setImage(UIImage(named: "search_bar_btn_search_highlight"), for: .search, state: UIControlState())
        UISearchBar.appearance().setImage(UIImage(named:"search_bar_btn_search_highlight"), for: .search, state: .highlighted)
        UISearchBar.appearance().setImage(UIImage(named: "search_bar_btn_clear"), for: .clear, state: UIControlState())
        let image = UIImage(color: UIColor.white,size:CGSize(width: 35, height: 28))
        let backgroundImage = image!.stretchableImage(withLeftCapWidth: Int(image!.size.width*0.5), topCapHeight: Int(image!.size.height*0.5))
        UISearchBar.appearance().setSearchFieldBackgroundImage(backgroundImage, for: .normal)
        UISearchBar.appearance().searchTextPositionAdjustment = UIOffsetMake(8, 0)
    }
}
