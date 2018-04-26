//
//  TipViewTransition.swift
//  TipView
//
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class TipViewAnimation {
    
    static let showWithScale: TipView.AnimationClosureType = { messageView, anchorView, completion in
        messageView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.3, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [.beginFromCurrentState], animations: {
                        messageView.transform = .identity
        }) { (_) in            
            completion()
        }
    }
    
    static let dismissWithScale: TipView.AnimationClosureType = { messageView, anchorView, completion in
        messageView.transform = .identity
        anchorView.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0.0,
                       options: [.beginFromCurrentState], animations: {
                        messageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (_) in
            completion()
        }
    }
    
    static let showWithFadeIn: TipView.AnimationClosureType = { messageView, anchorView, completion in
        messageView.alpha = 0.0
        anchorView.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, delay: 0.0,
                       options: [.beginFromCurrentState], animations: {
                        messageView.alpha = 1
                        anchorView.alpha = 1
        }) { (_) in
            completion()
        }
    }
    
    static let dismissWithFadeOut: TipView.AnimationClosureType = { messageView, anchorView, completion in
        messageView.alpha = 1
        anchorView.alpha = 1
        
        UIView.animate(withDuration: 0.3, delay: 0.0,
                       options: [.beginFromCurrentState], animations: {
                        messageView.alpha = 0
                        anchorView.alpha = 0
        }) { (_) in
            completion()
        }
    }
}
