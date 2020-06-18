//
//  ViewController.swift
//  TipViewSample
//
//  Created by Saddam Akhtar on 6/18/20.
//  Copyright © 2020 personal. All rights reserved.
//

import UIKit
import TipView

class ViewController: UIViewController {

    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var leftTopView: UIView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var leftBottomView: UIView!
    @IBOutlet weak var rightBottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.applyGlobalTipViewConfiguration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let msg = "Lorem ipsum dolor sit amet, consect adipiscing elit."
        
        self.tipViewWithCustomView(msg: msg)


        let centerTip = TipView()
        centerTip.anchorSize = CGSize(width: 14, height: 10)
        centerTip.color = UIColor.black
        centerTip.textPadding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        centerTip.showAnimation = TipViewAnimation.showWithFadeIn
        centerTip.dismissAnimation = TipViewAnimation.dismissWithFadeOut
        centerTip.show(message: msg,
                       sourceView: self.centerView,
                       containerView: self.view,
                       direction: .left) { (tipView) in
                        TipView().show(message: msg,
                                       sourceView: self.centerView,
                                       containerView: self.view,
                                       direction: .top,
                                       dismissClosure: { (tipView) in
                                        let tipV = TipView()
                                        tipV.showAnimation = TipViewAnimation.showWithFadeIn
                                        tipV.dismissAnimation = TipViewAnimation.dismissWithFadeOut
                                        tipV.show(message: msg,
                                                       sourceView: self.centerView,
                                                       containerView: self.view,
                                                       direction: .right,
                                                       dismissClosure: { (tipView) in
                                                        TipView().show(message: msg,
                                                                       sourceView: self.centerView,
                                                                       containerView: self.view,
                                                                       direction: .bottom,
                                                                       dismissClosure: { (tipView) in
                                                                        //
                                                        })
                                        })
                        })
        }
                        
        
        let rightBottomView = TipView()
        rightBottomView.dismissClosure = { tipview in
            TipView().show(message: msg,
                           sourceView: self.leftBottomView,
                           containerView: self.view,
                           direction: .right)
        }
        // Dismiss after spwcified duration
        rightBottomView.show(message: msg,
                       sourceView: self.rightBottomView,
                       containerView: self.view,
                       direction: .top, dismissAfterDuration: 5.0)
        
    }
    
    func applyGlobalTipViewConfiguration() {
        // Global configuration
        TipView.maxWidth = 270
        TipView.color = UIColor.darkGray
        TipView.font = UIFont(name: "Arial-ItalicMT", size: 18.0)
        TipView.enableDismissOnTapOverTip = true
        TipView.showAnimation = TipViewAnimation.showWithScale
        TipView.dismissAnimation = TipViewAnimation.dismissWithScale
        //TipView.enableDismissOnTapOutsideTipInContainer = true
    }
    
    func tipViewWithCustomView(msg: String) {
        let topLeftTip = TipView()
        topLeftTip.margin = UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 0)
        
        // Most of the styling properties doesn't have any impact on custom
        //topLeftTip.maxWidth = 300 // doesn't have any impact
        
        let customMessageView = UIView(frame: CGRect.zero)
        customMessageView.translatesAutoresizingMaskIntoConstraints = false
        customMessageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        customMessageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        customMessageView.backgroundColor = UIColor.darkGray
        
        // Don't set customAnchorView if you want to show the default
        // anchorView.
        topLeftTip.customAnchorView = UIView(frame: CGRect.zero)
        topLeftTip.customAnchorView!.translatesAutoresizingMaskIntoConstraints = false
        topLeftTip.customAnchorView!.widthAnchor.constraint(equalToConstant: 10).isActive = true
        topLeftTip.customAnchorView!.heightAnchor.constraint(equalToConstant: 10).isActive = true
        topLeftTip.customAnchorView!.backgroundColor = UIColor.darkGray
        
        topLeftTip.show(messageView: customMessageView,
                        sourceView: self.leftTopView,
                        containerView: self.view,
                        direction: .bottom,
                        dismissClosure: { (tipView) in
                            TipView().show(message: msg,
                                           sourceView: self.rightTopView,
                                           containerView: self.view,
                                           direction: .bottom)
        })
    }

}
