 `Closures` framework adds closures to many features of `UIControl` subclasses.
 Below are some common actions on some common controls.
 
## UIButton Tap
 
 A common target-action used is a button tap event. This one is
 really simple:

```swift
button.onTap {
    log("Button tapped")
}
```
## Value Changed Events
 Most other `UIControl` types are only interesting for their
 value changes. The following are examples of how to observe
 value changes on other popular `UIControl`s.

### UISlider

```swift
slider.onChange { value in
    log("slider: \(value)")
}
```

 * * * *
### UISegmentedControl

```swift
segmentedControl.onChange { index in
    log("segment: \(index)")
}
```

 * * * *
### UIStepper

```swift
stepper.onChange { value in
    log("stepper: \(value)")
}
```

 * * * *
### UIPageControl

```swift
pageControl.onChange { index in
    log("page: \(index)")
}
```

 * * * *
### UISwitch

```swift
uiSwitch.onChange { isOn in
    log("swith is: \(isOn ? "on" : "off")")
}
```

 * * * *
### UIDatePicker

```swift
datePicker.onChange { date in
    log(date)
}
```

 * * * *
### UITextField
 
 In addtion to text changes, `UITextField` has some other convenient wrappers
 around some commonly needed actions. Below are examples of some events that
 can you can observe. Notice the use of daisy chaining in order to keep it
 concise and organized.

```swift
textfield
    .onChange { newText in
        log(newText)
    }.onEditingBegan {
        log("Editing began")
    }.onEditingEnded {
        log("Editing ended")
    }.onReturn {
        log("Return key tapped")
}
```

## Delegation
 `UITextField` also employs delegation to help define its behavior. Below
 is how you would implement `UITextFieldDelegate` methods using closures.

```swift
textfield
    .didBeginEditing {
        log("Did begin editing delegate")
    }.shouldClear {
        log("Text clearing")
        return true
    }.shouldChangeCharacters { range, string in
        return true
}
```

 Although these convenience closures are not exhaustive, there is a way to
 use a closure for any `UIControlEvents`.

```swift
button.on(.touchDragInside) { sender, event in
    log("Dragging inside button")
}
```