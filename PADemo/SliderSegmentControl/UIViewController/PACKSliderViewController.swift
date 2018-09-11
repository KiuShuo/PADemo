//
//  PACKSliderViewController.swift
//  PADemo
//
//  Created by shuo on 2017/9/1.
//  Copyright © 2017年 shuo. All rights reserved.
//

import UIKit

class PACKSliderViewController: BaseViewController {
    
    let sliderView = CKSlideSwitchView(frame: CGRect(x: 0, y: 64, width: UIScreen.width, height: UIScreen.height - 64))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSliderView()
        solveGestureConflict()
    }
    
    private func solveGestureConflict() {
        if let screenEdgePanGestureRecognizer = (self.navigationController as? PABaseNavigationController)?.getScreenEdgePanGestureRecognizer() {
            sliderView.topScrollView.panGestureRecognizer.require(toFail: screenEdgePanGestureRecognizer)
            sliderView.rootScrollView.panGestureRecognizer.require(toFail: screenEdgePanGestureRecognizer)
        }
    }
    
    private func setupSliderView() {
        sliderView.backgroundColor = UIColor.white
        sliderView.tabItemTitleNormalColor = UIColor.black
        sliderView.tabItemTitleSelectedColor = UIColor.paOrange
        view.addSubview(sliderView)
        sliderView.slideSwitchViewDelegate = self
        sliderView.reloadData()
    }
    
//    let arrTitles = ["呵呵"]
//    let arrTitles = ["呵呵", "嘿嘿"]
//    let arrTitles = ["呵呵", "嘿嘿", "哈哈"]
    let arrTitles = ["呵呵", "嘿嘿", "哈哈", "嗯嗯"]
//    let arrTitles = ["呵呵", "嘿嘿", "哈哈", "嗯嗯", "好的"]

}

extension PACKSliderViewController: CKSlideSwitchViewDelegate {
    
    /// topscrollview中tabitem的个数
    func slideSwitchView(_ view: CKSlideSwitchView, numberOfTabItemsForTopScrollView topScrollView: UIScrollView) -> Int {
        return arrTitles.count
    }
    
    /// topscrollview中tabitem所对应的title的值
    func slideSwitchView(_ view: CKSlideSwitchView, titleForTabItemForTopScrollViewAt index: Int) -> String? {
        return "\(arrTitles[index])_\(index + 1)/\(arrTitles.count)"
    }
    
    /// rootscrollview中的子view
    func slideSwitchView(_ view: CKSlideSwitchView, viewForRootScrollViewAt index: Int) -> UIView? {
        let view = UIView()
        let colors = [UIColor.red, UIColor.yellow]
        view.backgroundColor = colors[index % 2]
        view.bounds.size = CGSize(width: UIScreen.width, height: UIScreen.height - 64 - 44)
        let label = UILabel()
        label.text = "第\(index + 1)/\(arrTitles.count)张"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.green
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 20)
        view.addSubview(label)
        return view
    }
    
    /// 设置每个tabitem的高度
    func slideSwitchView(_ view: CKSlideSwitchView, heightForTabItemForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return 44
    }
    
    func slideSwitchView(_ view: CKSlideSwitchView, widthForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return UIScreen.width
    }
    
    
    func slideSwitchView(_ view: CKSlideSwitchView, tabItemWidthForTopScrollView topScrollView: UIScrollView) -> CGFloat {
        return UIScreen.width / 3
    }
    
}
