`Closures` framework adds closures for `UIBarButtonItem` tap events, usually
found in a UINavigationBar.

All initializers that support the target-action pattern now have an equivalent
initialier that contains a `handler` parameter.

```swift
navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left item", style: .plain) {
    // left bar button item tapped
}
```

To add the closure handler to an existing `UIBarButtonItem`, simply call the
`onTap(handler:)` method. For instance, if you created your button
in a storyboard, you could call the following in your `viewDidLoad` method.

```swift
let myRightBarButton = navigationItem.rightBarButtonItem!
myRightBarButton.onTap {
    // right bar button item tapped
}
```

