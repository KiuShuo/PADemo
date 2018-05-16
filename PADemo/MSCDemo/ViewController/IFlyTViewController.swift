//
//  IFlyTViewController.swift
//  PADemo
//
//  Created by shuo on 2018/5/10.
//  Copyright © 2018年 shuo. All rights reserved.
//  科大讯飞语音听写测试界面

import UIKit

class IFlyTViewController: BaseViewController {
    // 不带界面的识别对象
    fileprivate var iFlySpeechReconizer: IFlySpeechRecognizer?
    fileprivate let reconizerResultView = UITextView()
    fileprivate var result: String = ""
    fileprivate var isStart: Bool = false
    fileprivate var reconizerResult: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "科大讯飞语音听写"
        IFlySpeechUtility.createUtility("appid=5aeff098")
        setupUI()
        setupIFlySpeechReconizer()
    }
    
    func setupUI() {
        let startButton = UIButton()
        startButton.frame = CGRect(x: 10, y: 100, width: 50, height: 30)
        startButton.setTitle("开始", for: .normal)
        startButton.backgroundColor = UIColor.green
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        view.addSubview(startButton)
        
        let finishButton = UIButton()
        finishButton.frame = CGRect(x: 70, y: 100, width: 50, height: 30)
        finishButton.setTitle("完成", for: .normal)
        finishButton.backgroundColor = UIColor.green
        finishButton.addTarget(self, action: #selector(finished), for: .touchUpInside)
        view.addSubview(finishButton)
        
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 130, y: 100, width: 50, height: 30)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.backgroundColor = UIColor.green
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        reconizerResultView.frame = CGRect(x: 10, y: 150, width: UIScreen.width - 20, height: 100)
        reconizerResultView.backgroundColor = UIColor.orange
        view.addSubview(reconizerResultView)
    }
    
    @objc func start() {
        reconizerResultView.text = ""
        if iFlySpeechReconizer == nil {
            setupIFlySpeechReconizer()
        }
        isStart = true
        // 启动识别服务
        if let result = iFlySpeechReconizer?.startListening() {
            print("result = \(result)")
        }
    }
    
    @objc func finished() {
        isStart = false
        // 停止录音
        iFlySpeechReconizer?.stopListening()
    }
    
    @objc func cancel() {
        isStart = false
        // 取消本次会话
        iFlySpeechReconizer?.cancel()
    }
    
    func setupIFlySpeechReconizer() {
        iFlySpeechReconizer = IFlySpeechRecognizer.sharedInstance()
        iFlySpeechReconizer?.delegate = self
        // 设置为听写模式
        iFlySpeechReconizer?.setParameter("iat", forKey: IFlySpeechConstant.ifly_DOMAIN())
        iFlySpeechReconizer?.setParameter("10000", forKey: IFlySpeechConstant.vad_BOS())
        iFlySpeechReconizer?.setParameter("10000", forKey: IFlySpeechConstant.vad_EOS())
        iFlySpeechReconizer?.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
        // 返回结果的数据格式
        iFlySpeechReconizer?.setParameter("plain", forKey: IFlySpeechConstant.result_TYPE())
        // 识别录音保存路径 默认保存在Library/cache路径下 设置为nil或空取消保存
//        iFlySpeechReconizer?.setParameter("iat.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
    }

}

extension IFlyTViewController: IFlySpeechRecognizerDelegate {
    
    // 识别结果回调
    func onError(_ errorCode: IFlySpeechError!) {
        print("errorCode = \(errorCode.errorCode, errorCode.errorDesc)")
    }
    
    // 识别结果回调
    func onResults(_ results: [Any]!, isLast: Bool) {
        print("results = \(results)")
        var resultString = ""
        if results == nil {
            return
        }
        guard let dic = results.first as? [String: String] else {
            return
        }
        dic.forEach { (key, _) in
            resultString.append(key)
        }
        reconizerResult += resultString
    }
    
    // 开始录音
    func onBeginOfSpeech() {
        print("开始录音")
    }
    
    // 停止录音
    func onEndOfSpeech() {
        // 为避免超过10s没有声音自动停止，可作如下判断：如果还没有手动停止/或者还没有达到60s时间，则重新调用开始录音
        if isStart {
            start()
        } else {
            reconizerResultView.text = reconizerResultView.text + reconizerResult
            reconizerResult = ""
        }
        print("停止录音")
    }
    
    // 取消识别 取消识别后执行 执行完后还会执行停止录音回调
    func onCancel() {
        print("取消识别")
        reconizerResult = ""
    }
    
    // 音量变化回调
    func onVolumeChanged(_ volume: Int32) {
        print("音量变化 === \(Int(volume))")
    }
    
}
