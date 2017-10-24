![Closures logo](https://raw.githubusercontent.com/vhesener/Closures/assets/assets/logo3.1.png)

[![Language](https://img.shields.io/badge/Swift-4.0-blue.svg?style=plastic&colorB=68B7EB)]()
[![License](https://img.shields.io/github/license/vhesener/Closures.svg?style=plastic&colorB=68B7EB)]()
[![Release](https://img.shields.io/github/release/vhesener/Closures.svg?style=plastic&colorB=68B7EB)]()

`Closures` is an iOS Framework that adds [closure](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Closures.html) handlers to many of the popular UIKit and Foundation classes. Although this framework is a substitute for some Cocoa Touch design patterns, such as [Delegation & Data Sources](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/Delegation.html) and [Target-Action](https://developer.apple.com/library/content/documentation/General/Conceptual/Devpedia-CocoaApp/TargetAction.html), the authors make no claim regarding which is a *better* way to accomplish the same type of task. Most of the time it is a matter of style, preference, or convenience that will determine if any of these closure extensions are beneficial.

Whether you're a functional purist, dislike a particular API, or simply just want to organize your code a little bit, you might enjoy using this library.

> ***<sub>note</sub>*** <br/>
> `Closures` currently only supports projects written in **Swift 4.0**+. 

***
## [Usage Overview](#usage-overview)

### **Convenient Closures**

Some days, you just feel like dealing with [UIControl](https://vhesener.github.io/Closures/Controls.html)'s target-action using a closure instead.

```swift
button.onTap {
    // UIButton tapped code
}
```

```swift
mySwitch.onChange { isOn in
    // UISwitch value changed code
}
```

***

Adding a [gesture recognizer](https://vhesener.github.io/Closures/Gesture%20Recognizers.html) can be compacted into one method.

```swift
view.addPanGesture() { pan in
    // UIPanGesutreRecognizer recognized code
}
```

***

Populating views with an array? I gotchu.

```swift
tableView.addElements(myArray, cell: MyTableViewCell.self) { element, cell, index in
    cell.textLabel!.text = "\(element)"
}
```

```swift
collectionView.addFlowElements(myArray, cell: MyCustomCollectionViewCell.self) { element, cell, index in
    cell.myImageViewProperty.image = element.thumbImage
}
```

```swift
pickerView.addStrings(myStrings) { title, component, row in
    // UIPickerView item selected code
}
```
***
### **Daisy Chaining**

Almost all convenience methods allow for the use of [daisy chaining](https://en.wikipedia.org/wiki/Method_chaining). This allows us to have some nice syntax sugar while implementing optional delegate methods in a concise way. Using [UITextField](https://vhesener.github.io/Closures/Extensions/UITextField.html) as an example, we can organize and visualize all of the `UITextFieldDelegate` behavior.

```swift
textField
    .didBeginEditing {
        // UITextField did begin editing code
    }.shouldClear {
        true
    }.shouldChangeCharacters { range, string in
        // some custom character change code
        return false
}
```
***
### **Retain Control**

At no time are you locked into using these convenience methods. For instance, [UITableView](https://vhesener.github.io/Closures/Extensions/UITableView.html) does not need to be populated with an array. You can just as easily provide your own `UITableViewDelegate` and `UITableViewDataSource` handlers.

```swift
tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "Cell")
tableView
    .numberOfRows { _ in
        myArray.count
    }.cellForRow { indexPath in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = myArray[indexPath.row]
        return cell
    }.didSelectRowAt { indexPath in
        // IndexPath selected code
}
```

***

You aren't limited to which delegate/dataSource methods you wish to implement. Similarly, you can act on any
[UIControl](https://vhesener.github.io/Closures/Extensions/UIControl.html#/s:So9UIControlC8ClosuresE2onABXDSC0A6EventsV_yAB_So7UIEventCSgtc7handlertF) events.

```swift
anyControl.on(.touchDown) { control, event in
    // UIControlEvents.touchDown event code
}
```

***

These two [UIImagePickerController](https://vhesener.github.io/Closures/Extensions/UIImagePickerController.html) snippets are equivalent. As you can see, there are lots of ways to provide more granular control by mixing and match various convenience methods and closure handlers.
	
```swift
UIImagePickerController(source: .camera, allow: .image) { result, picker in
    myImageView.image = result.editedImage
}.present(from: self)
```
```swift
let pickerController = UIImagePickerController()
pickerController.sourceType = .camera
pickerController.mediaTypes = [kUTTypeImage]
pickerController.didFinishPickingMedia { [weak self] info in
    myImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
    self?.dismiss(animated: true)
}.didCancel { [weak self] in
    self?.dismiss(animated: true)
}
self.present(pickerController, animated: true)
```
***
## [Dive Deeper](#dive-deeper)

There are several ways to learn more about the `Closures` API, depending on your learning style. Some just like to open up Xcode and use autocomplete to view the various properties/functions. Others prefer a more documented approach. Below are some documentation options.

***
### <img src="https://raw.githubusercontent.com/vhesener/Closures/assets/assets/playground_Icon.png" width="50" height="50"/> &nbsp;&nbsp; **Playground**

To play with the <a href="https://developer.apple.com/swift/blog/?id=35">Playground</a> demo, open the `Closures` workspace (Closures.xcworkspace file), build the `Closures` framework target, then click on the `Closures Demo` playground. Be sure to show the Assistant Editor and Live View as shown below:

![Playgrounds](https://raw.githubusercontent.com/vhesener/Closures/assets/assets/playground_general.gif)

***
### <img src="https://raw.githubusercontent.com/vhesener/Closures/assets/assets/reference_Icon.png" width="50" height="50"/> &nbsp;&nbsp; **Class Reference Documentation**

The [Reference Documentation](https://vhesener.github.io/Closures) has all of the detailed usage information including all the public methods, parameters, and convenience initializers.

[![Class Reference Documentation](https://raw.githubusercontent.com/vhesener/Closures/assets/assets/reference_large.png)](https://vhesener.github.io/Closures)

***
## [Installation](#installation)

### **CocoaPods**

If using [CocoaPods](https://cocoapods.org/), add the following to your Podfile:

```ruby
pod 'Closures'
```

### **Carthage**

If using [Carthage](https://github.com/Carthage/Carthage), add the following to your Cartfile:

```shell
github "vhesener/Closures"
```

### **Manual**

Download or clone the project files found in the [master branch](https://github.com/vhesener/Closures). Drag and drop
all .swift files located in the 'Closures/Source' subdirectory into your Xcode project. Check the option *Copy items
if needed*. 

***
## [Background](#background)

Inspired by [BlocksKit](https://github.com/BlocksKit/BlocksKit), there was a need for a more *Swifty* version
of the same library. The goal of this library was to provide similar usefulness, but with the following
constraints:

* Use Swift's strong-typed system as much as possible in the API.
* Not use the [Objective-C runtime](https://github.com/BlocksKit/BlocksKit/search?utf8=%E2%9C%93&q=objc_setAssociatedObject&type=). 
There are many reasons for this, but mostly because 
	* It was arbitrarily challenging.
	* It was in the spirit of Swift.
* Create a scalable mechanism to easily add additional closure wrappers in the future.

It is our goal to become irrelevant via [sherlock](http://www.urbandictionary.com/define.php?term=sherlocked).
In addition to not having to support this library anymore, it would actually be flattering
to have been validated by the API folks at Apple.

***
## [Want more?](#want-more)

If you were hoping to see an API converted using closures and came up empty handed, there's a
chance all can be right. [Simply vote on a feature](https://github.com/vhesener/Closures/labels/Closure%20API%20Request) by adding a 👍 reaction.

***
## [License](#license)

Closures is provided under the [MIT License](https://github.com/vhesener/Closures/blob/master/LICENSE).

```text
The MIT License (MIT)
Copyright (c) 2017 Vincent Hesener
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
is furnished to do so, subject to the following conditions:
 
The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
