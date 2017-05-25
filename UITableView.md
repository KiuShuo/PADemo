#### UITableView

###### 注释：一下讨论都是有个小小的前提，tableView设置过预估高度。

一、代理函数的执行顺序：
 
 ``` Swift
    1. func: numberOfSections(in:)
    2. func: tableView(_:numberOfRowsInSection:)
    3. allCellNumbers次 func: tableView(_:heightForRowAt:)
    4. allCellNumbers次 func: tableView(_:cellForRowAt:) + func: tableView(_: heightForRowAt:)
 ```
 
 二、tableView.reload后cellForRaw的执行时机：

情况1. reloadData：

``` Swift
func refresh_1() {
     debugLog("begin reloadData")
     tableView.reloadData()
     debugLog("end reloadData")
}

// 运行结果：
"file: TableViewController, line: 41, func: refresh_1()"
["begin reloadData"]
"file: TableViewController, line: 59, func: numberOfSections(in:)"
"file: TableViewController, line: 64, func: tableView(_:numberOfRowsInSection:)"
"file: TableViewController, line: 43, func: refresh_1()"
["end reloadData"]
"file: TableViewController, line: 69, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 69, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 69, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"

```
 
结论：cellForRowAt + heightForRowAt 异步执行。

```
 1. 一次 func: numberOfSections(in:)
 2. 一次 func: tableView(_:numberOfRowsInSection:)
 3. ... other code
 4. allCellNumbers次 func: tableView(_:cellForRowAt:) + func: tableView(_: heightForRowAt:)
 5. allCellNumbers次 func: tableView(_: heightForRowAt:)
```

即：！！！！cellForRowAt的执行在reloadData后面的代码全都执行完成之后。    

基于上述执行顺序，可能造成的问题： 在reloadData之后更改数据源，就会引起错误，特别是数据个数减少后，会导致数组越界引起闪退；

情况2. reloadRows(at: with:)：

```
func refresh_2() { 
    debugLog("begin reloadData")
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.reloadRows(at: [indexPath], with: .automatic)
    debugLog("end reloadData")  
}

// 执行结果：
"file: TableViewController, line: 48, func: refresh_2()"
["begin reloadData"]
"file: TableViewController, line: 59, func: numberOfSections(in:)"
"file: TableViewController, line: 59, func: numberOfSections(in:)"
"file: TableViewController, line: 64, func: tableView(_:numberOfRowsInSection:)"
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 69, func: tableView(_:cellForRowAt:)"
2017-05-12 10:03:41.202 PADemo[2811:69037] 执行(null)
"file: TableViewController, line: 88, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 51, func: refresh_2()"
["end reloadData"]

```
结论： 一次 cellForRowAt + heightForRowAt 同步执行

```
1. 两次 func: numberOfSections(in:)
2. 一次 func: tableView(_:numberOfRowsInSection:)
3. allCellNumbers次 func: tableView(_:heightForRowAt:)
4. 一次 func: tableView(_:cellForRowAt:) + func: tableView(_: heightForRowAt:)

```

情况3.reloadData + reloadRows

```
func refresh_3() {
    refresh_1()
    refresh_2()
}

// 执行结果：
"file: TableViewController, line: 41, func: refresh_1()"
["begin reloadData"]
"file: TableViewController, line: 65, func: numberOfSections(in:)"
"file: TableViewController, line: 70, func: tableView(_:numberOfRowsInSection:)"
"file: TableViewController, line: 43, func: refresh_1()"
["end reloadData"]
"file: TableViewController, line: 48, func: refresh_2()"
["begin reloadData"]
"file: TableViewController, line: 65, func: numberOfSections(in:)"
"file: TableViewController, line: 65, func: numberOfSections(in:)"
"file: TableViewController, line: 70, func: tableView(_:numberOfRowsInSection:)"
"file: TableViewController, line: 90, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 90, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 90, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 75, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 90, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 75, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 90, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 75, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 90, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 51, func: refresh_2()"
["end reloadData"]

```
即代码执行顺序为：reloadData的cellForRowAt + heightForRowAt异步执行，并夹杂在了reloadForRows原本的cellForRowAt执行处 使得reloadForRows的cellForRows方法不在执行。

情况3.1: reloadData + 异步延迟的relodForRows:

```
func refresh_3() {
    refresh_1()
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        self.refresh_2()
    }
}

// 运行结果：
"file: TableViewController, line: 41, func: refresh_1()"
["begin reloadData"]
"file: TableViewController, line: 77, func: numberOfSections(in:)"
"file: TableViewController, line: 82, func: tableView(_:numberOfRowsInSection:)"
"file: TableViewController, line: 43, func: refresh_1()"
["end reloadData"]
"file: TableViewController, line: 87, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 87, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 87, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 51, func: refresh_2()"
["begin reloadData"]
"file: TableViewController, line: 77, func: numberOfSections(in:)"
"file: TableViewController, line: 77, func: numberOfSections(in:)"
"file: TableViewController, line: 82, func: tableView(_:numberOfRowsInSection:)"
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 87, func: tableView(_:cellForRowAt:)"
2017-05-13 23:07:03.984 PADemo[5733:387854] 执行(null)
"file: TableViewController, line: 102, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 54, func: refresh_2()"
["end reloadData"]
```
结论：reloadData执行顺序 + reloadForRows执行顺序


情况4: reloadRows + reloadData:  

```
func refresh_4() {
    refresh_2()
    refresh_1()
}

// 运行结果：
"file: TableViewController, line: 48, func: refresh_2()"
["begin reloadData"]
"file: TableViewController, line: 72, func: numberOfSections(in:)"
"file: TableViewController, line: 72, func: numberOfSections(in:)"
"file: TableViewController, line: 77, func: tableView(_:numberOfRowsInSection:)"
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 82, func: tableView(_:cellForRowAt:)"
2017-05-12 10:20:47.305 PADemo[3133:84792] 执行(null)
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 51, func: refresh_2()"
["end reloadData"]
"file: TableViewController, line: 41, func: refresh_1()"
["begin reloadData"]
"file: TableViewController, line: 72, func: numberOfSections(in:)"
"file: TableViewController, line: 77, func: tableView(_:numberOfRowsInSection:)"
"file: TableViewController, line: 43, func: refresh_1()"
["end reloadData"]
"file: TableViewController, line: 82, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 82, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 82, func: tableView(_:cellForRowAt:)"
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"
"file: TableViewController, line: 97, func: tableView(_:heightForRowAt:)"


```
即代码的执行顺序为： relodRow的执行顺序 + reloadData的执行顺序。
