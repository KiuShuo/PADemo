#### UICollecTionView

先提炼出两条比较重要的结论：  
1. `collectionView`的几个代理函数都会异步执行；  
2. 当先执行`reloadRow`再执行`reloadData`后，会导致`reloadData`中的`allItemNumber`次`cellForItemAt`函数不会执行。

一. 代理函数的执行顺序：  

```
"file: CollectionViewController, line: 65, func: numberOfSections(in:)"
"file: CollectionViewController, line: 71, func: collectionView(_:numberOfItemsInSection:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"  

```
不同与`UITableView`的代码执行顺序，`collectionView`在执行完 `allItemNumber`次`func: collectionView(_:layout:sizeForItemAt:)`获取到每个`item`大小后，不会再执行该函数来获取`item`的大小。

二. reload后的代码执行顺序：  

* reloadData

```
func refresh_1() {
    debugLog("begin reloadData")
    collectionView?.reloadData()
    debugLog("end reloadData")
}

// 运行结果：
"file: CollectionViewController, line: 36, func: refresh_1()"
["begin reloadData"]
"file: CollectionViewController, line: 38, func: refresh_1()"
["end reloadData"]
"file: CollectionViewController, line: 65, func: numberOfSections(in:)"
"file: CollectionViewController, line: 71, func: collectionView(_:numberOfItemsInSection:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
```
结论：全都异步执行。

* reloadItems

```
func refresh_2() {
   debugLog("begin reloadData")
   let indexPath = IndexPath(item: 0, section: 0)
   collectionView?.reloadItems(at: [indexPath])
   debugLog("end reloadData")
}

// 运行结果：
"file: CollectionViewController, line: 43, func: refresh_2()"
["begin reloadData"]
"file: CollectionViewController, line: 65, func: numberOfSections(in:)"
"file: CollectionViewController, line: 71, func: collectionView(_:numberOfItemsInSection:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 46, func: refresh_2()"
["end reloadData"]

```
结论：全都同步执行。

* reloadData + reloadItems

```
func refresh_3() {
  refresh_1()
  refresh_2()
}

// 运行结果： 
"file: CollectionViewController, line: 36, func: refresh_1()"
["begin reloadData"]
"file: CollectionViewController, line: 38, func: refresh_1()"
["end reloadData"]
"file: CollectionViewController, line: 43, func: refresh_2()"
["begin reloadData"]
"file: CollectionViewController, line: 65, func: numberOfSections(in:)"
"file: CollectionViewController, line: 71, func: collectionView(_:numberOfItemsInSection:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 65, func: numberOfSections(in:)"
"file: CollectionViewController, line: 71, func: collectionView(_:numberOfItemsInSection:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 46, func: refresh_2()"
["end reloadData"]

```
结论：reloadItems除了cellForItems的执行顺序 + reloadData的所有执行顺序。少执行代码，但是不会造成影响，可以看作是一种优化。


* reloadItems + reloadData

```
func refresh_4() {
    refresh_2()
    refresh_1()
}
    
// 运行结果：
"file: CollectionViewController, line: 43, func: refresh_2()"
["begin reloadData"]
"file: CollectionViewController, line: 65, func: numberOfSections(in:)"
"file: CollectionViewController, line: 71, func: collectionView(_:numberOfItemsInSection:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 76, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 46, func: refresh_2()"
["end reloadData"]
"file: CollectionViewController, line: 36, func: refresh_1()"
["begin reloadData"]
"file: CollectionViewController, line: 38, func: refresh_1()"
["end reloadData"]
"file: CollectionViewController, line: 65, func: numberOfSections(in:)"
"file: CollectionViewController, line: 71, func: collectionView(_:numberOfItemsInSection:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 91, func: collectionView(_:layout:sizeForItemAt:)"
```
结论：reloadItems的执行顺序 + reloadData丢失了cellForItem代码的执行顺序。少执行代码，并且少了后会引起问题。

* reloadItems + 异步延迟的reloadData

```
func refresh_4() {
    refresh_2()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        self.refresh_1()
    }
}

// 运行结果：
"file: CollectionViewController, line: 43, func: refresh_2()"
["begin reloadData"]
"file: CollectionViewController, line: 67, func: numberOfSections(in:)"
"file: CollectionViewController, line: 73, func: collectionView(_:numberOfItemsInSection:)"
"file: CollectionViewController, line: 93, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 93, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 93, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 78, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 46, func: refresh_2()"
["end reloadData"]
"file: CollectionViewController, line: 36, func: refresh_1()"
["begin reloadData"]
"file: CollectionViewController, line: 38, func: refresh_1()"
["end reloadData"]
"file: CollectionViewController, line: 67, func: numberOfSections(in:)"
"file: CollectionViewController, line: 73, func: collectionView(_:numberOfItemsInSection:)"
"file: CollectionViewController, line: 93, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 93, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 93, func: collectionView(_:layout:sizeForItemAt:)"
"file: CollectionViewController, line: 78, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 78, func: collectionView(_:cellForItemAt:)"
"file: CollectionViewController, line: 78, func: collectionView(_:cellForItemAt:)"
```
结论：reloadItems 执行顺序 + reloadItems 执行顺序 不会少执行代码。
