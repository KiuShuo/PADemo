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
//        perform(Selector(textField.text!))
//        observableLearn()
//        subjectLearn()
//        rxMapLearn()
//        rxShareReplayLearn2()
        learnUnitOperator()
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


// 联合操作 把多个Observable流合成单个Observable流
extension LRxSwiftViewController {
    
    func learnUnitOperator() {
//        rxCombineLatest()
//        rxStartWith()
//        rxMerge()
//        rxZip()
        rxSwitchLastest()
    }
    
    // startWith 将一些元素插入到序列的头部 会在Observable的头部插入一些元素
    func rxStartWith() {
        Observable.of("1", "2", "3", "4")
            .startWith("a")
            .startWith("b")
            .startWith("c")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // merge 将多个Observables合并成一个，根据时间轴发出对应的事件
    func rxMerge() {
        let first = PublishSubject<Int>()
        let second = PublishSubject<Int>()
        Observable.merge(first, second)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        first.onNext(10)
        second.onNext(20)
        first.onNext(13)
        second.onNext(1)
    }
    /*
     zip 操作符将多个(最多不超过8个) Observables 的元素通过一个函数组合起来，然后将这个组合的结果发出来。它会严格的按照序列的索引数进行组合。例如，返回的 Observable 的第一个元素，是由每一个源 Observables 的第一个元素组合出来的。它的第二个元素 ，是由每一个源 Observables 的第二个元素组合出来的。它的第三个元素 ，是由每一个源 Observables 的第三个元素组合出来的，以此类推。它的元素数量等于源 Observables 中元素数量最少的那个。
     */
    func rxZip() {
        let first = PublishSubject<String>()
        let second = PublishSubject<String>()
        Observable.zip(first, second) { $0 + $1 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        first.onNext("1")
        first.onNext("2")
        second.onNext("A")
        first.onNext("3")
        second.onNext("B")
    }
    
    /*
     combineLatest 操作符将多个(最多不超过8个) Observables 中最新的元素通过一个函数组合起来，然后将这个组合的结果发出来。这些源 Observables 中任何一个发出一个元素，他都会发出一个元素（前提是，这些 Observables 曾经发出过元素）
     */
    func rxCombineLatest() {
        let first = PublishSubject<String>()
        let second = PublishSubject<String>()
        Observable.combineLatest(first, second) { $0 + $1 }.subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        first.onNext("1")
        second.onNext("A")
        first.onNext("2")
        first.onNext("3")
        second.onNext("B")
        second.onNext("C")
        second.onNext("D")
    }
    
    /*
     switchLatest可以对事件流进行转换，本来监听的subject1，我可以通过更改variable里面的value更换事件源。变成监听subject2了
     */
    func rxSwitchLastest() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        variable.asObservable()
            .switchLatest()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        subject1.onNext("C")
        subject2.onNext("2")
        subject2.onNext("3")
        
        variable.value = subject2
        subject1.onNext("D")
        subject1.onNext("E")
        subject2.onNext("4")
        subject2.onNext("5")
        /*
         打印结果： A B C 3 4 5
         */
    }
    
}

// shareReplay、replay
extension LRxSwiftViewController {
    
    func rxShareReplayLearn2() {
        let sequenceOfInts = PublishSubject<Int>()
        let a = sequenceOfInts.map { i -> Int in
            print("MAP")
            return i * 2
            } //.share(replay: 2)
        _ = a.subscribe(onNext: { print("--1---\($0)") })
        sequenceOfInts.on(.next(1))
        sequenceOfInts.on(.next(2))
        _ = a.subscribe(onNext: { print("--2---\($0)") })
        sequenceOfInts.on(.next(3))
        sequenceOfInts.on(.next(4))
        _ = a.subscribe(onNext: { print("--3---\($0)") })
        sequenceOfInts.on(.next(5))
        sequenceOfInts.on(.next(6))
        
        sequenceOfInts.on(.completed)
        /*
         // share(replay: 1) replay值为1时的执行结果
         MAP
         --1---2
         MAP
         --1---4
         --2---4
         MAP
         --1---6
         --2---6
         MAP
         --1---8
         --2---8
         --3---8
         MAP
         --1---10
         --2---10
         --3---10
         MAP
         --1---12
         --2---12
         --3---12
         
         // share(replay: 2) replay值为2时的执行结果
         MAP
         --1---2
         MAP
         --1---4
         --2---2
         --2---4
         MAP
         --1---6
         --2---6
         MAP
         --1---8
         --2---8
         --3---6
         --3---8
         MAP
         --1---10
         --2---10
         --3---10
         MAP
         --1---12
         --2---12
         --3---12
         
         // share(replay: replayCount)
         replayCount类似于ReplaySubject中buffersize的作用，通过设置replayCount的值来控制将最新的replayCount个元素发送给观察者。
         同时，无论replayCount的值是多少，都可以看出Map的打印次数是不变的，即只和事件的发出次数有关，也就再次验证了share的主要作用：共享资源。
         */
    }
    
    /*
     replay(n) 操作符将Observable转换成可连接的Observable,并且这个可被连接的Observable将缓存最新的n个元素。当有新的观察者对他进行订阅时，他就把这些被缓存的元素发送给观察者。
     
     可被连接的Observable和普通的Observable非常相似，不过在被订阅后不会发出元素，直到connect操作符被应用为止，这样一来你可以控制Observable在什么时候开始发出元素。
     
     share(replay: n) 该操作符将使的观察者共享资源Observable，并且缓存最新的n个元素，将这些元素直接发送给新的观察者。
     
     */
    
    func rxShareReplayLearn() {
        // shareReplay 表示共享最后几次的结果
        let sequenceOfInts = PublishSubject<Int>()
        let a = sequenceOfInts.map { i -> Int in
            print("MAP")
            return i * 2
        }.share(replay: 1)
        _ = a.subscribe(onNext: { print("--1---\($0)") })
        _ = a.subscribe(onNext: { print("--2---\($0)") })
        _ = a.subscribe(onNext: { print("--3---\($0)") })
        sequenceOfInts.on(.next(5))
        sequenceOfInts.on(.next(6))
        sequenceOfInts.on(.completed)
        /*
         // 没有share(replay: 1)
         MAP
         --1---10
         MAP
         --2---10
         MAP
         --3---10
         MAP
         --1---12
         MAP
         --2---12
         MAP
         --3---12
         
         // 有share(replay: 1)
         /*
         使用share后，对多次订阅者Observer 同一次事件发出时map中的转换代码仅执行了一次；
         如果不使用share(replay: 1)，则同一事件发出时，每个Observer都会执行一次map中的代码。
         */
         MAP
         --1---10
         --2---10
         --3---10
         MAP
         --1---12
         --2---12
         --3---12
         */
    }
    
}

// ... Map 变换操作
extension LRxSwiftViewController {
    
    func rxMapLearn() {
//        mapLearn()
//        flatMapLearn()
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
//        🐱.score.value = 91
//        🐭.score.value = 101
        player.value = 🐱 // 更换了value 相当于又添加了一个sequence 两个sequence都可以接收。
        🐶.score.value = 82
        🐱.score.value = 93
//        🐭.score.value = 104
        player.value = 🐭
        🐶.score.value = 83
        🐱.score.value = 93
        🐭.score.value = 103
    }
    
    // 相较于flatMap，flatMapLatest只会接受最新的value事件
    /*
     将Observable的元素转换成其他的Observable，然后取这些Observables中的最新一个。
     */
    func flatMapLatestLearn() {
        let first = BehaviorSubject(value: "1")
        let second = BehaviorSubject(value: "2")
        let variable = Variable(first)
        
        let newObservable = variable.asObservable().flatMapLatest { return $0 }
        newObservable.subscribe(onNext: { print($0) } ).disposed(by: disposeBag)
        
        first.onNext("a")
//        second.onNext("b")
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
