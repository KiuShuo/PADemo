//
//  LearnAFViewController.swift
//  PADemo
//
//  Created by shuo on 2018/11/27.
//  Copyright © 2018 shuo. All rights reserved.
//

import UIKit

class LearnAFViewController: BaseViewController {

    let httpsImageUrl = "https://github.com/KiuShuo/imageSource/blob/master/HTTP/HTTPS%E9%80%9A%E4%BF%A1.png?raw=true"
    let httpImageUrl = "http://www.hangge.com/blog_uploads/201512/2015121920180529333.png"
    var data: NSMutableData?
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var showImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func clear() {
        activityIndicatorView.stopAnimating()
        showImageView.image = nil
    }
    
    @IBAction func clickLeftButton(_ sender: UIButton) {
        clear()
        activityIndicatorView.startAnimating()
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        let request = URLRequest(url: URL(string: httpImageUrl)!)
        let dataTask = session.dataTask(with: request)
        dataTask.resume()
    }
    
    @IBAction func clickCenterButton(_ sender: UIButton) {
        clear()
        activityIndicatorView.startAnimating()
        weak var weakSelf = self
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: weakSelf, delegateQueue: OperationQueue())
        let dataTask = session.downloadTask(with: URL(string: httpImageUrl)!)
        dataTask.resume()
    }
    
    @IBAction func clickRightButton(_ sender: UIButton) {
        clear()
        activityIndicatorView.startAnimating()
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = session.dataTask(with: URL(string: httpImageUrl)!) { (data, response, error) in
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                if let data = data {
                    self.showImageView.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
    }
    
}

extension LearnAFViewController: URLSessionDelegate {

    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("error = \(error?.localizedDescription ?? "didBecomeInvalid")")
    }
    
    // 当请求需要认证、或者https证书认证的时候，我们就需要在这个方法里面处理
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential? = nil
        if let trust = challenge.protectionSpace.serverTrust {
            credential = URLCredential(trust: trust)
            disposition = URLSession.AuthChallengeDisposition.useCredential
        }
        completionHandler(disposition, credential)
        print("didReceive")
    }

    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("urlSessionDidFinishEvents")
    }
}

extension LearnAFViewController: URLSessionTaskDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
        if let data = data as Data? {
            DispatchQueue.main.async {
                self.showImageView.image = UIImage(data: data)
            }
        }
    }
    
}

extension LearnAFViewController: URLSessionDataDelegate {

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        data = nil
        data = NSMutableData()
        completionHandler(URLSession.ResponseDisposition.allow)
//        dataTask.cancel()
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data?.append(data)
    }
    
}

extension LearnAFViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
        let path = location.absoluteString
        if let imageData = try? Data(contentsOf: URL(string: path)!) {
            DispatchQueue.main.async {
                self.showImageView.image = UIImage(data: imageData)
            }
        }
//        downloadTask.cancel()
    }
    
}
