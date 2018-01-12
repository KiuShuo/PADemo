//
//  LRxSwiftViewController.swift
//  PADemo
//
//  Created by shuo on 2018/1/5.
//  Copyright © 2018年 shuo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// map share combineLatest

class LRxSwiftViewController: RXBaseViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func begin(_ sender: UIButton) {
        //perform(Selector(textField.text!))
//        observableLearn()
        //subjectLearn()
        rxMapLearn()
    }
    
    func observableLearn() {
        // just 创建一个sequence 只能发出一种特定事件，能正常结束
        /*
        let justObservable = Observable.just("呵呵")
        let disposable = justObservable.subscribe { (event) in
            print("event.element = \(String(describing: event.element))")
            print("event = \(event)")
        }
        disposable.disposed(by: disposeBag)
        */
        Observable.just("呵呵").subscribe { event in
            //print("event.element = \(String(describing: event.element))")
            print("event = \(event)")
        }.disposed(by: disposeBag)
    }
    

}

// ... Map 变换操作
extension LRxSwiftViewController {
    
    func rxMapLearn() {
        //mapLearn()
        //flatMapLearn()
        flatMapLatestLearn()
    }
    
    func mapLearn() {
        // 通过一个转换函数，将Observable中的每一个元素转换一遍
        // 通过传入一个函数闭包 将一个sequence转换成一个新的sequence
        let observable = Observable.of(1, 2, 3).map { $0 * $0 }
        observable.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        // 可省写为
        Observable.of(1, 2, 3).map { $0 * $0 }.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
    }
    // map和flatMap的区别：flatMap是将每一个元素都转换成了Observable，map转换成的不一定是Observable
    func flatMapLearn() {
        // 将Observable的元素转换为其他的Observable，然后将这些Observable合并
        struct Player {
            var score: Variable<Int>
        }
        let 🐶 = Player(score: Variable(80))
        let 🐱 = Player(score: Variable(90))
        let 🐭 = Player(score: Variable(100))
        let player = Variable(🐶) // 将player转换成Variable
        // 将Observable<Player> player转换成了Observable<Int>，即被监听对象由Player变成了Int
        let observable = player.asObservable().flatMap { $0.score.asObservable() }
        observable.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        🐶.score.value = 81
        player.value = 🐱 // 更换了value 相当于有添加了一个sequence 两个sequence都可以接收。
        🐶.score.value = 85
        🐶.score.value = 90
        player.value = 🐭
        🐱.score.value = 110
    }
    
    func flatMapLatestLearn() {
        let first = BehaviorSubject(value: "1")
        let second = BehaviorSubject(value: "2")
        let variable = Variable(first)
        
        let newObservable = variable.asObservable().flatMapLatest { return $0 }
        newObservable.subscribe(onNext: { print($0) } ).disposed(by: disposeBag)
        
        first.onNext("a")
        second.onNext("b")
        variable.value = second
        first.onNext("c")
        second.onNext("d")
    }
    
}

// ... Subject
extension LRxSwiftViewController {
    
    func subjectLearn() {
        //asyncSubjectLearn()
        //publishSubjectLearn()
        //replaySubjectLearn()
        //        behaviorSubjectLearn()
        //        variableLearn()
        
    }
    
    func asyncSubjectLearn() {
        // AsyncSubject 将在源Observable产生完成事件后发出最后一个元素和完成事件；如果源Observable没有发出任何元素，只有一个完成事件，那么AsyncSubject也只有一个完成事件。
        let subject = AsyncSubject<String>()
        // subject.subcribe subject作为Observable被订阅
        subject.subscribe { (event) in
            print("subscription 1 Event \(event)")
            }.disposed(by: disposeBag)
        // subject作为Observer发出事件
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        subject.onCompleted()
        subject.onNext("d")
    }
    
    func publishSubjectLearn() {
        // PublishSubject 将对观察者发送订阅后产生的元素，而在订阅前发出的元素将不会发送给观察者。
        let subject = PublishSubject<String>()
        subject.asObservable().subscribe { event in
            print("subscription: 1 Event = \(event)")
            }.disposed(by: disposeBag)
        subject.onNext("a")
        subject.onNext("b")
        
        subject.asObservable().subscribe { event in
            print("subscription: 2 Event = \(event)")
            }.disposed(by: disposeBag)
        subject.onNext("c")
        subject.onNext("d")
    }
    
    func replaySubjectLearn() {
        /*
         ReplaySubject 将对观察者发送所有元素，无论观察者是何时进行订阅的。
         (bufferSize: n) 用来控制将最新的n个元素发送给观察者
         */
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.asObservable().subscribe { print("subscription: 1 Event = \($0)") }.disposed(by: disposeBag)
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.asObserver().subscribe { print("subscription: 2 Event = \($0)") }.disposed(by: disposeBag)
        subject.onNext("d")
        subject.onNext("e")
        subject.onNext("f")
    }
    
    func behaviorSubjectLearn() {
        /*
         当观察者对BehaviorSubject进行订阅时 它会将最新的元素发送出来(如果不存在最新的元素，就发出默认元素)。然后将随后产生的元素发送出来。
         当订阅了BehaviorSubject，会接受到订阅之前的最后一个事件。
         
         如果源Obserable因为产生了一个error事件而终止，BehaviorSubject就不会发出任何元素，而是将这个error事件发送出来。
         */
        let subject = BehaviorSubject(value: "O")
        subject.asObserver().subscribe { print("subscribtion: 1 Event = \($0)") }.disposed(by: disposeBag)
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        subject.asObserver().subscribe { print("subscribtion: 2 Event = \($0)") }.disposed(by: disposeBag)
        subject.onNext("d")
        subject.onError(RxError.unknown)
        subject.onNext("e")
        subject.onNext("f")
        subject.onCompleted()
    }
    
    func variableLearn() {
        /*
         Variable 是BehaviorSubject的一个封装，使用的时候需要调用 asObservable()进行拆箱。里面的value是一个BehaviorSubject，他不会发出error事件，但是会自动发出completed事件。
         */
        let subject = Variable("O")
        subject.asObservable().subscribe { print("Subscribtion: 1 Event = \($0)") }.disposed(by: disposeBag)
        subject.value = "a"
        subject.value = "b"
        subject.value = "c"
        subject.asObservable().subscribe { print("Subscribtion: 2 Event = \($0)") }.disposed(by: disposeBag)
        subject.value = "d"
        subject.value = "e"
        subject.value = "f"
    }
    
}
