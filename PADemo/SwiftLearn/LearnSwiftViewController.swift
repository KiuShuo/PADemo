//
//  LearnSwiftViewController.swift
//  PADemo
//
//  Created by shuo on 2018/9/10.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

class LearnSwiftViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func codableAlamofire() {
        let url = URL(string: "https://raw.githubusercontent.com/otbivnoe/CodableAlamofire/master/keypathArray.json")!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970 // It is necessary for correct decoding. Timestamp -> Date.
        Alamofire.request(url).responseDecodableObject(keyPath: "result.libraries", decoder: decoder) { (response: DataResponse<[Repo]>) in
            if let repo = response.result.value {
                print(repo)
            }
        }
    }
    
    @IBAction func codableLearn1() {
        let jsonData = """
        {
        "short_name": "Shanghai",
        "pop": 21000000,
        "level": "large",
        "location": {
          "latitude": 30.40,
          "longitude": 120.51
        }
        }
        """.data(using: .utf8)!
        
        do {
            let city = try JSONDecoder().decode(City.self, from: jsonData)
            print("city:", city)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func request(_ sender: UIButton) {
        provider.request(AModuleNetworkAPI.wjRequest(params: ["pageNo": 1, "pageSize": 20, "pageId": "11", "activityTypeId": "4","app_code":"15006"])) { (result) in
            switch result {
            case let .success(response):
                print("response = \(response)")
            case let .failure(error):
                print("error = \(error)")
            }
        }
    }
}

