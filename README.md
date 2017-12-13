# TipView
An autolayout based ready to use tool tip library with maximum customization.

[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

![](header.gif)

## Features

- [x] Ready to use tip view
- [x] Orientation support provided by autolayout engine
- [x] Global styling configuration
- [x] Override specific instance styling configuration
- [x] Supports custom views
- [x] Animation on show/dismiss
- [x] Supports custom animation
- [x] Dismiss on tap
- [x] Dismiss on tap outside within the container
- [x] Dismiss after specified duration

## Requirements

- iOS 9.0+
- Xcode 9.0

## Installation

#### Manually
1. Download and drop ```TipViewSource``` in your project.
2. Congratulations!  

## Usage example

```swift

TipView().show(message: <tip message>, sourceView: <source view>, containerView: <container view>, direction: .right)

// Global configurations
TipView.maxWidth = 270
TipView.color = UIColor.darkGray
TipView.font = UIFont(name: "Arial-ItalicMT", size: 18.0)
TipView.enableDismissOnTapOverTip = true
TipView.showAnimation = TipViewAnimation.showWithScale
TipView.dismissAnimation = TipViewAnimation.dismissWithScale
//TipView.enableDismissOnTapOutsideTipInContainer = true

let customTip = TipView()
customTip.margin = UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 0)

// Most of the styling properties doesn't have any impact on custom
//customTip.maxWidth = 300 // doesn't have any impact

// message in show() method will be ignored if customMessageView is being set
customTip.customMessageView = UIView(frame: CGRect.zero)
customTip.customMessageView?.translatesAutoresizingMaskIntoConstraints = false
customTip.customMessageView!.widthAnchor.constraint(equalToConstant: 100).isActive = true
customTip.customMessageView!.heightAnchor.constraint(equalToConstant: 100).isActive = true
customTip.customMessageView?.backgroundColor = UIColor.darkGray

customTip.customAnchorView = UIView(frame: CGRect.zero)
customTip.customAnchorView!.translatesAutoresizingMaskIntoConstraints = false
customTip.customAnchorView!.widthAnchor.constraint(equalToConstant: 10).isActive = true
customTip.customAnchorView!.heightAnchor.constraint(equalToConstant: 10).isActive = true
customTip.customAnchorView!.backgroundColor = UIColor.darkGray

// message will be ignored here as customMessageView is being set on the tipview instance
customTip.show(message: msg, sourceView: <source view>, containerView: <container view>, direction: .bottom)

```

## Contribute

We would love you for the contribution to **TipView**.

[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
