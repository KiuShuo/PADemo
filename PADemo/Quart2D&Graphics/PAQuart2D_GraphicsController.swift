//
//  PAQuart2D_GraphicsController.swift
//  PADemo
//
//  Created by shuo on 2017/8/4.
//  Copyright © 2017年 shuo. All rights reserved.
//

/*
 [iOS Quart2D绘图之UIGraphicsGetCurrentContext基础](http://www.jianshu.com/p/8cf8d4b724d2)
 [iOS Quart2D绘图之UIGraphicsBeginImageContextWithOptions基础](http://www.jianshu.com/p/4e22c6ac114d)
 */

import UIKit

class PAQuart2D_GraphicsController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        learnQuart2D_Graphics()
    }
    
    func learnQuart2D_Graphics() {
        let view01 = PAView01(frame: CGRect(x: 10, y: 74, width: 50, height: 50))
        view01.backgroundColor = UIColor.green
        view.addSubview(view01)
        
        let view02 = PAView02(frame: CGRect(x: 70, y: 74, width: 50, height: 50))
        view02.backgroundColor = UIColor.green
        view.addSubview(view02)
        
        let view03 = PAView03(frame: CGRect(x: 130, y: 74, width: 50, height: 50))
        view03.backgroundColor = UIColor.green
        view.addSubview(view03)
        
        let view04 = PAView04(frame: CGRect(x: 190, y: 74, width: 100, height: 200))
        view04.backgroundColor = UIColor.green
        view.addSubview(view04)
    }
    
}

class PAView04: UIView {
    
    var progress: CGFloat = 0
    // 画圆形度条
    override func draw(_ rect: CGRect) {
        let startArc = -CGFloat.pi / 2
        let endArc = 2 * CGFloat.pi * progress - CGFloat.pi / 2
        let arcCenter = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = min(frame.width, frame.height) / 2 - 5
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startArc, endAngle: endArc, clockwise: true)
        path.close()
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(path.cgPath)
        let color = UIColor(red: progress, green: 0, blue: 1 - progress, alpha: 1)
        color.set()
        //context?.strokePath()
        context?.drawPath(using: .fillStroke)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let slider = UISlider()
        slider.frame = CGRect(x: 3, y: frame.height - 20, width: frame.width - 6, height: 10)
        addSubview(slider)
        slider.addTarget(self, action: #selector(sliderSlid(sender:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sliderSlid(sender: UISlider) {
        progress = CGFloat(sender.value)
        setNeedsDisplay()
    }
    
}

class PAView03: UIView {
    // 画五角星
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath()
        let size = self.frame.size
        let centerPoint = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) / 2 - 5
        let dertW = centerPoint.x
        let dertH = centerPoint.y
        
        let point1 = CGPoint(x: dertW, y: dertH - radius)
        
        /*
        let point2 = CGPoint(x: dertW + radius * cosV(18), y: dertH - radius * sinV(18))
        let point3 = CGPoint(x: dertW + radius * cosV(54), y: dertH + radius * sinV(54))
        let point4 = CGPoint(x: dertW - radius * cosV(54), y: dertH + radius * sinV(54))
        let point5 = CGPoint(x: dertW - radius * cosV(18), y: dertH - radius * sinV(18))
        
        path.move(to: point1)
        path.addLine(to: point3)
        path.addLine(to: point5)
        path.addLine(to: point2)
        path.addLine(to: point4)
        //path.addLine(to: point1)
        path.close()
         */
        
        path.move(to: point1)
        let angle = 4 * CGFloat.pi / 5
        for i in 1..<6 {
            let x = centerPoint.x - sin(angle * CGFloat(i)) * radius
            let y = centerPoint.y - cos(angle * CGFloat(i)) * radius
            let nextPoint = CGPoint(x: x, y: y)
            path.addLine(to: nextPoint)
        }
        
        UIColor.red.set()
        context?.addPath(path.cgPath)
//        context?.strokePath()
        context?.drawPath(using: .fillStroke)
        
    }
    
    private func cosV(_ param: CGFloat) -> CGFloat {
        return cos(param * CGFloat.pi / 180)
    }
    
    private func sinV(_ param: CGFloat) -> CGFloat {
        return sin(param * CGFloat.pi / 180)
    }
    
}


class PAView02: UIView {
    // 画圆
    override func draw(_ rect: CGRect) {
        // 获取图形上下文
        let context = UIGraphicsGetCurrentContext()
        let size = self.frame.size
        let arcCenterPoint = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) / 2 - 5
        
        // clockwise是否顺时针
        let path = UIBezierPath(arcCenter: arcCenterPoint, radius: radius, startAngle: CGFloat.pi / (-2), endAngle: CGFloat.pi * 3 / 2, clockwise: true)
        context?.addPath(path.cgPath)
        UIColor.red.set()
        // context?.strokePath() // 显示路径
        context?.drawPath(using: .fillStroke)
    }
    
}

class PAView01: UIView {
    // 划线
    override func draw(_ rect: CGRect) {
        // 获取图形上下文
        let context = UIGraphicsGetCurrentContext()
        // 描述路径
        let path = UIBezierPath()
        let sourcePoint = CGPoint(x: 10, y: 10)
        let endPoint = CGPoint(x: 40, y: 40)
        path.move(to: sourcePoint)
        path.addLine(to: endPoint)
        
        context?.addPath(path.cgPath)
//        UIColor.white.setStroke() // 设置路径的颜色
//        UIColor.red.setFill() // 设置填充颜色
        UIColor.yellow.set()  // 设置路径和填充颜色
        context?.setLineWidth(5) // 设置线宽
        context?.strokePath() // 显示路径
    }
    
}
