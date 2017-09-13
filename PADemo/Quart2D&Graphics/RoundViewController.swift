//
//  RoundViewController.swift
//  PADemo
//
//  Created by shuo on 2017/9/7.
//  Copyright © 2017年 shuo. All rights reserved.
//  [【iOS】一种获取圆/弧上等分点的思路](http://www.jianshu.com/p/045a43666cbc)

import UIKit

class RoundViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let squareView = SquareView(frame: CGRect(x: 10, y: 80, width: 200, height: 200))
//        squareView.backgroundColor = UIColor.green
//        view.addSubview(squareView)
        
        one()
//        three()
    }
    
    fileprivate func one()
    {
        
        let roundView = UIView()
        roundView.frame = CGRect(x: 10, y: 80, width: 400, height: 400)
        roundView.backgroundColor = UIColor.green
        view.addSubview(roundView)
        let N = 10, R: CGFloat = 100
        let angle = 360.0/CGFloat(N) * CGFloat.pi/180.0
        
        for i in 0..<N
        {
            let start = CGFloat(i)*angle - 90*CGFloat.pi/180
            let end = start + angle
            
            // 可以利用贝塞尔path获取圆弧终点的位置CGPoint
            let path = UIBezierPath(arcCenter: roundView.center, radius: R, startAngle: start, endAngle: end, clockwise: true)
            // 等分点
            let position = path.currentPoint
            // 在相应等分点上绘制元素
            let p = UIBezierPath(arcCenter: position, radius: 10, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.blue.cgColor
            layer.path = p.cgPath
            roundView.layer.addSublayer(layer)
            
            // 等分弧线段
            let circleLayer = CAShapeLayer()
            circleLayer.lineWidth = 4
            circleLayer.fillColor = nil
            circleLayer.strokeColor = CGFloat(i).remainder(dividingBy: 2) == 0 ? UIColor.red.cgColor : UIColor.green.cgColor
            circleLayer.path = path.cgPath
            roundView.layer.addSublayer(circleLayer)
        }
    }
    
    
    fileprivate func three() {
        let roundView = UIView()
        roundView.frame = CGRect(x: 10, y: 80, width: 400, height: 400)
        roundView.backgroundColor = UIColor.green
        view.addSubview(roundView)
        
        let W: CGFloat = 60, N = 8
        let angle = 2*CGFloat.pi / CGFloat(N)
        var R = W //默认让半径等于W
        
        // 计算 x 是否 <= w/2
        var x = R * sin(angle/2)
        while x < W/2+10 { //10为间距
            R += 1
            x = R * sin(angle/2) //重叠的最小间距
        }
        for i in 0..<N
        {
            let start = CGFloat(i)*angle
            let end = start + angle
            
            // 可以利用贝塞尔path获取圆弧终点的位置CGPoint
            let path = UIBezierPath(arcCenter: roundView.center, radius: R, startAngle: start, endAngle: end, clockwise: true)
            // 等分点
            let position = path.currentPoint
            // 在相应等分点上绘制元素
            let p = UIBezierPath(arcCenter: position, radius: W/2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.blue.cgColor
            layer.path = p.cgPath
            roundView.layer.addSublayer(layer)
            
            // 等分弧线段
            let circleLayer = CAShapeLayer()
            circleLayer.lineWidth = 4
            circleLayer.fillColor = nil
            circleLayer.strokeColor = CGFloat(i).remainder(dividingBy: 2) == 0 ? UIColor.red.cgColor : UIColor.green.cgColor
            circleLayer.path = path.cgPath
            roundView.layer.addSublayer(circleLayer)
        }
    }

}


class SquareView: UIView {
    
    override func draw(_ rect: CGRect) {
        // 获取图形上下文
        let context = UIGraphicsGetCurrentContext()
        let size = self.frame.size
        let arcCenterPoint = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) / 2
        
        // clockwise是否顺时针
        let path = UIBezierPath(arcCenter: arcCenterPoint, radius: radius, startAngle: CGFloat.pi / (-2), endAngle: CGFloat.pi * 3 / 2, clockwise: true)
        context?.addPath(path.cgPath)
        UIColor.red.set()
        // context?.strokePath() // 显示路径
        context?.drawPath(using: .fillStroke)
        
        
        
        
    }
    
}
