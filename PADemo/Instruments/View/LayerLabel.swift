//
//  LayerLabel.swift
//  PADemo
//
//  Created by shuo on 2018/5/5.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit

class LayerLabel: UILabel {

    //    API说明：The class used to create the layer for instances of this class.
    override class var layerClass: AnyClass {
        return CATextLayer.classForCoder()
    }
    //    获得本身转变成CATextLayer的对象
    var textLayer: CATextLayer {
        return self.layer as! CATextLayer
    }
    //    设置textLayer
    func setUp() {
        text = super.text
        textColor = super.textColor
        font = super.font
        textLayer.alignmentMode = CATextLayerAlignmentMode.justified
        textLayer.isWrapped = true
        self.layer.display()
    }
    
    //    初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    //   xib初始化
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    //    重写相关属性text
    override var text: String? {
        didSet {
            // 001
            super.text = text
            // 002
            textLayer.string = text
        }
    }
    //    重写相关属性textColor
    override var textColor: UIColor? {
        didSet {
            super.textColor = textColor
            textLayer.foregroundColor = UIColor.blue.cgColor
        }
    }
    //    重写相关属性font
    override var font: UIFont? {
        didSet {
            super.font = font
            let fontRef = CGFont.init(font!.fontName as CFString)
            textLayer.font = fontRef
            textLayer.fontSize = font?.pointSize ?? 12
        }
    }

}


