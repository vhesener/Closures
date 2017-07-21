## Delegate and DataSource
 
 `UIPickerView` closures make it easy to implement `UIPickerViewDelegate` and
 `UIPickerViewDataSource` protocol methods in an organized way. The following
 is an example of a simple collection view that displays strings in each row.

```swift
func loadPickerView() {
    pickerView
        .numberOfRowsInComponent() { _ in
            countries.count
        }.titleForRow() { row, component in
            countries[row]
        }.didSelectRow { row, component in
            log("\(countries[row]) selected")
        }.reloadAllComponents()
}
```

## Arrays
 These operations are common. Usually, they involve populating the `UIPickerView`
 with the values from an array. `Closures` framework gives you a convenient
 way to pass your collection to the table view, so that it can perform the boilerplate
 operations for you, especially the ones that are required to make the picker
 view perform at a basic level.

 * Important:
 Please remember that Swift `Array`s are value types. This means that they
 are copied when mutaded. When the values or sequence of your array changes, you will
 need to call one of the `add` methods again, just before you
 call reloadData().
 
 ```swift
func loadPickerView(countries: [String]) {
    let reversed = Array(countries.reversed())
    pickerView
        .addStrings(reversed) { country,component,row in
            log("\(country) selected from array")
        }.reloadAllComponents()
}
```

* Note:
 Be sure to note that most of the closure callbacks in these array binding
 methods switch the order of the parameters of row and component. Most of the
 `UIPickerView` delegate/datasource method parameters pass `row,component`. The
 parameters on the `add` methods switch the order and send `component,row`
 
### Multiple Components
 And finally, you can just as easily show mutliple components by binding a
 2-dimensional array. When using this method, the outer dimension of the array is the
 component (columns) and the inner dimension are the rows in that component.
 
```swift
let anElement = myTwoDArray[component][row]
```
 
 In this example, the more verbose row handler is provided just to show the
 different variations. Adding multiple components has a convenient method to
 deal with string only arrays also.
 
```swift
func loadPickerView(components: [[String]]) {
    pickerView.addComponents(
        components,
        rowTitle: { country,component,row in
            country},
        didSelect: { country,component,row in
            log("\(country) selected from 2D Array")
    })
    
    /**
     This also allows you to override any default behavior so
     you aren't overly committed, even though you're initially binding everything
     to the `Array`.
     */
    pickerView.widthForComponent { component in
        component ==  0 ? 200 : 100
    }.reloadAllComponents()
}
```
