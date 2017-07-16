## Delegate and DataSource
 
 `UICollectionView` closures make it easy to implement `UICollectionViewDelegate` and
 `UICollectionViewDataSource` protocol methods in an organized way. The following
 is an example of a simple collection view that displays strings in a basic cell.

```swift
func loadCollectionView() {
    collectionView.register(MyCustomCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    
    collectionView
        .numberOfItemsInSection { _ in
            countries.count
        }.cellForItemAt { indexPath in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCustomCollectionViewCell
            cell.textLabel.text = countries[indexPath.item]
            return cell
        }.didSelectItemAt {
            print("\(countries[$0.item]) selected")
        }.reloadData()
}
```

## Arrays
 These operations are common. Usually, they involve populating the `UICollectionView`
 with the values from an array. `Closures` framework gives you a convenient
 way to pass your array to the collection view, so that it can perform the boilerplate
 operations for you, especially the ones that are required to make the collection
 view perform at a basic level.

 * Important:
 Please remember that Swift `Array`s are value types. This means that they
 are copied when mutated. When the values or sequence of your array changes, you will
 need to call `addFlowElements` again, just before you call reloadData().

```swift
func loadCollectionView(countries: [String]) {
    collectionView
        .addFlowElements(countries, cell: MyCustomCollectionViewCell.self) { country, cell, index in
            cell.textLabel.text = country
    }.reloadData()
    
    /**
     This also allows you to override any default behavior so
     you aren't overly committed, even though you're initially binding everything
     to the `Array`.
     */
    collectionView.didSelectItemAt {
        print("\(countries[$0.item]) selected from array")
    }
}
```
