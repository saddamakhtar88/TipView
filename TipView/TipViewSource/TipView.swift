//
//  TipView.swift
//  TipView
//
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class TipView: NSObject {
    
    // MARK: - Enums
    
    enum Direction {
        case left
        case right
        case top
        case bottom
        case none
    }
    
    // MARK: -
    
    typealias DismissClosureType = ((TipView) -> Void )
    typealias AnimationClosureType = (_ messageView: UIView, _ anchorViewUIView: UIView, _ completion: @escaping () -> Void) -> Void
    
    // This is to retain self for functionality like dismissOnTapOverTip
    private var holdMyself: TipView?
    
    // MARK: - Global properties
    
    static var maxWidth: CGFloat = 200.0
    static var color: UIColor = UIColor.red
    static var textColor: UIColor = UIColor.white
    static var font: UIFont?
    static var textPadding: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0,
                                                        bottom: 8.0, right: 8.0)
    static var margin: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8.0,
                                                        bottom: 0, right: 8.0)
    static var cornerRadius: CGFloat = 6.0
    static var anchorSize: CGSize = CGSize(width: 10, height: 8)
    
    static var enableDismissOnTapOverTip: Bool = false
    static var enableDismissOnTapOutsideTipInContainer: Bool = false
    
    static var showAnimation: AnimationClosureType?
    static var dismissAnimation: AnimationClosureType?        
    
    // MARK: - Instance properties
    
    var uniqueID: String?
    var maxWidth: CGFloat?
    var color: UIColor?
    var textColor: UIColor?
    var font: UIFont?
    var textPadding: UIEdgeInsets?
    var margin: UIEdgeInsets?
    var cornerRadius: CGFloat?
    var anchorSize: CGSize?
    
    var enableDismissOnTapOverTip: Bool?
    var enableDismissOnTapOutsideTipInContainer: Bool?
    
    var dismissClosure: DismissClosureType?
    
    var showAnimation: AnimationClosureType?
    var dismissAnimation: AnimationClosureType?
    
    var tapOverTipGesture: UITapGestureRecognizer?
    var tapOverTipContainerGesture: UITapGestureRecognizer?
    
    var customMessageView: UIView?
    var customAnchorView: UIView?
    
    // MARK: - Private properties
    
    private var direction: TipView.Direction = .none
    private var sourceView: UIView?
    private var containerView: UIView?
    private var message: String?
    
    // MARK: - Instance methods
    
    func show(message msg: String,
              sourceView: UIView,
              containerView: UIView?,
              direction: Direction = .none) {
        self.message = msg
        show(sourceView: sourceView,
             containerView: containerView,
             direction: direction)
    }
    
    func show(message msg: String,
              sourceView: UIView,
              containerView: UIView?,
              direction: Direction = .none,
              dismissAfterDuration dismissAfter: TimeInterval) {
        show(message: msg,
             sourceView: sourceView,
             containerView: containerView,
             direction: direction)
        
        Timer.scheduledTimer(timeInterval: dismissAfter, target: self,
                             selector: #selector(TipView.dismiss), userInfo: nil,
                             repeats: false)
    }
    
    func show(message msg: String,
              sourceView: UIView,
              containerView: UIView?,
              direction: Direction = .none,
              dismissClosure: DismissClosureType?) {
        
        self.dismissClosure = dismissClosure
        show(message: msg,
             sourceView: sourceView,
             containerView: containerView,
             direction: direction)
    }
    
    func show(messageView: UIView,
              sourceView: UIView,
              containerView: UIView?,
              direction: Direction = .none,
              dismissAfterDuration dismissAfter: TimeInterval) {
        
        self.customMessageView = messageView
        show(sourceView: sourceView,
             containerView: containerView,
             direction: direction)
        
        Timer.scheduledTimer(timeInterval: dismissAfter, target: self,
                             selector: #selector(TipView.dismiss), userInfo: nil,
                             repeats: false)
    }
    
    func show(messageView: UIView,
              sourceView: UIView,
              containerView: UIView?,
              direction: Direction = .none,
              dismissClosure: DismissClosureType?) {
        
        self.customMessageView = messageView
        self.dismissClosure = dismissClosure
        show(sourceView: sourceView,
             containerView: containerView,
             direction: direction)
    }
    
    @objc func dismiss() {
        
        if let dismissAnimation = dismissAnimation ?? TipView.dismissAnimation {
            dismissAnimation(tipView, tipViewAnchor, { [weak self] in
                if self != nil {
                    self!.tipView.removeFromSuperview()
                    self!.tipViewAnchor.removeFromSuperview()
                    self!.dismissClosure?(self!)
                    
                    self!.dismissClosure = nil
                    self!.holdMyself = nil
                }
            })
        } else {
            self.tipView.removeFromSuperview()
            self.tipViewAnchor.removeFromSuperview()
            self.dismissClosure?(self)
            
            self.dismissClosure = nil
            self.holdMyself = nil
        }                
        
        if tapOverTipGesture != nil {
            tipView.removeGestureRecognizer(tapOverTipGesture!)
        }
        
        if tapOverTipContainerGesture != nil {
            self.containerView?.removeGestureRecognizer(tapOverTipContainerGesture!)
        }
    }
    
    deinit {
        //debugPrint("TipView released from memory")
    }
    
    // MARK: - Private methods
    
    private func show(sourceView: UIView,
                      containerView: UIView?,
                      direction: Direction = .none) {
        
        self.direction = direction
        self.sourceView = sourceView
        
        if let prContainerView: UIView = containerView ?? UIApplication.shared.keyWindow {
            self.containerView = prContainerView
            
            prContainerView.addSubview(tipViewAnchor)
            prContainerView.addSubview(tipView)
            
            switch direction {
            case .left:
                addOnTheLeft(sourceView: sourceView, containerView: prContainerView)
            case .right:
                addOnTheRight(sourceView: sourceView, containerView: prContainerView)
            case .top:
                addOnTheTop(sourceView: sourceView, containerView: prContainerView)
            case .bottom:
                addOnTheBottom(sourceView: sourceView, containerView: prContainerView)
            case .none:
                tipViewAnchor.removeFromSuperview()
                addInTheCentre(containerView: prContainerView)
            }
            
            if self.enableDismissOnTapOutsideTipInContainer == true || TipView.enableDismissOnTapOutsideTipInContainer {
                tapOverTipContainerGesture = UITapGestureRecognizer(target: self, action: #selector(TipView.dismiss))
                self.containerView!.addGestureRecognizer(tapOverTipContainerGesture!)
                tapOverTipContainerGesture?.delegate = self
                
                holdMyself = self
            }
            
            if let showAnimation = showAnimation ?? TipView.showAnimation {
                showAnimation(tipView, tipViewAnchor, {
                    //
                })
            }
        }
    }
    
    private func applyMessageViewStyle(messageView: MessageView) {
        messageView.backgroundColor = self.color ?? TipView.color
        messageView.layer.cornerRadius = self.cornerRadius ?? TipView.cornerRadius
        
        messageView.label?.font = self.font ?? TipView.font ?? messageView.label?.font
        messageView.label?.textColor = self.textColor ?? TipView.textColor
    }
    
    private func applyAnchorViewStyle(anchorView: AnchorView) {
        anchorView.color = self.color ?? TipView.color
    }

    // MARK: - Private methods
    
    private var prtipViewAnchor: UIView!
    private var tipViewAnchor: UIView {
        
        guard prtipViewAnchor == nil else {
            return prtipViewAnchor
        }
        
        if customAnchorView != nil {
            prtipViewAnchor = customAnchorView!
        } else {
            let anchorView = AnchorView(frame: CGRect.zero,
                                        direction: self.direction)
            
            applyAnchorViewStyle(anchorView: anchorView)
            
            var swapWidthWithHeight: Bool = false
            if self.direction == .left || self.direction == .right {
                swapWidthWithHeight = true
            }
            
            let anchorSize: CGSize = self.anchorSize ?? TipView.anchorSize
            let width: CGFloat = swapWidthWithHeight ? anchorSize.height : anchorSize.width
            let height: CGFloat = swapWidthWithHeight ? anchorSize.width : anchorSize.height
            
            anchorView.widthAnchor.constraint(equalToConstant: width).isActive = true
            anchorView.heightAnchor.constraint(equalToConstant: height).isActive = true
            
            prtipViewAnchor = anchorView
        }
        
        return prtipViewAnchor
    }
    
    private var prTipView: UIView!
    private var tipView: UIView {
        
        guard prTipView == nil else {
            return prTipView
        }
        
        if customMessageView != nil {
            prTipView = customMessageView!
        } else {
            let messageView = MessageView(frame: CGRect.zero,
                                          textPadding: self.textPadding ?? TipView.textPadding)
            messageView.label?.text = self.message
            applyMessageViewStyle(messageView: messageView)
            
            messageView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth ?? TipView.maxWidth).isActive = true
            
            prTipView = messageView
        }
        
        if self.enableDismissOnTapOverTip ?? TipView.enableDismissOnTapOverTip {
            tapOverTipGesture = UITapGestureRecognizer(target: self, action: #selector(TipView.dismiss))
            prTipView.addGestureRecognizer(tapOverTipGesture!)
            
            holdMyself = self
        }
        
        return prTipView
    }
    
    private func addInTheCentre(containerView: UIView) {
        tipView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        tipView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        addCommonConstraints(containerView: containerView)
    }
    
    private func addOnTheBottom(sourceView: UIView, containerView: UIView) {
        
        let margin: UIEdgeInsets = self.margin ?? TipView.margin
        
        tipViewAnchor.topAnchor.constraint(equalTo: sourceView.bottomAnchor,
                                           constant: margin.top).isActive  = true
        tipViewAnchor.centerXAnchor.constraint(equalTo: sourceView.centerXAnchor).isActive = true
        
        tipViewAnchor.bottomAnchor.constraint(equalTo: tipView.topAnchor).isActive  = true
        let centerX = tipViewAnchor.centerXAnchor.constraint(equalTo: tipView.centerXAnchor)
        centerX.priority = .defaultHigh
        centerX.isActive = true
        
        addCommonConstraints(containerView: containerView)
    }
    
    private func addOnTheTop(sourceView: UIView, containerView: UIView) {
        
        let margin: UIEdgeInsets = self.margin ?? TipView.margin
        
        tipViewAnchor.bottomAnchor.constraint(equalTo: sourceView.topAnchor,
                                              constant: -margin.bottom).isActive  = true
        tipViewAnchor.centerXAnchor.constraint(equalTo: sourceView.centerXAnchor).isActive = true
        
        
        tipViewAnchor.topAnchor.constraint(equalTo: tipView.bottomAnchor).isActive  = true
        let centerX = tipViewAnchor.centerXAnchor.constraint(equalTo: tipView.centerXAnchor)
        centerX.priority = .defaultHigh
        centerX.isActive = true
        
        addCommonConstraints(containerView: containerView)
    }
    
    private func addOnTheLeft(sourceView: UIView, containerView: UIView) {
        tipViewAnchor.trailingAnchor.constraint(equalTo: sourceView.leadingAnchor).isActive  = true
        tipViewAnchor.centerYAnchor.constraint(equalTo: sourceView.centerYAnchor).isActive = true
        
        tipViewAnchor.leadingAnchor.constraint(equalTo: tipView.trailingAnchor).isActive  = true
        let centerY = tipViewAnchor.centerYAnchor.constraint(equalTo: tipView.centerYAnchor)
        centerY.priority = .defaultHigh
        centerY.isActive = true        
        
        addCommonConstraints(containerView: containerView)
    }
    
    private func addOnTheRight(sourceView: UIView, containerView: UIView) {
        tipViewAnchor.leadingAnchor.constraint(equalTo: sourceView.trailingAnchor).isActive  = true
        tipViewAnchor.centerYAnchor.constraint(equalTo: sourceView.centerYAnchor).isActive = true
        
        tipViewAnchor.trailingAnchor.constraint(equalTo: tipView.leadingAnchor).isActive = true
        let centerY = tipViewAnchor.centerYAnchor.constraint(equalTo: tipView.centerYAnchor)
        centerY.priority = .defaultHigh
        centerY.isActive = true
        
        addCommonConstraints(containerView: containerView)
    }
    
    private func addCommonConstraints(containerView: UIView) {
        
        let margin: UIEdgeInsets = self.margin ?? TipView.margin
        
        tipView.topAnchor.constraint(greaterThanOrEqualTo:
            containerView.topAnchor, constant: -margin.top).isActive = true
        tipView.bottomAnchor.constraint(lessThanOrEqualTo:
            containerView.bottomAnchor, constant: margin.bottom).isActive = true
        
        tipView.trailingAnchor.constraint(lessThanOrEqualTo:
            containerView.trailingAnchor, constant: -margin.right).isActive  = true
        tipView.leadingAnchor.constraint(greaterThanOrEqualTo:
            containerView.leadingAnchor, constant: margin.left).isActive  = true
    }
    
}

extension TipView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var allowGesture: Bool = true
        
        // Avoid dismiss when tapped over the tipview on tapOverTipContainerGesture
        if gestureRecognizer == tapOverTipContainerGesture {
            allowGesture = !tipView.frame.contains(touch.location(in: containerView!))
        }
        
        return allowGesture
    }
    
}
