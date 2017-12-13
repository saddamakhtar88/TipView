//
//  MessageView.swift
//  TipView
//
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class MessageView: UIView {
    
    var textPadding: UIEdgeInsets = UIEdgeInsets.zero
    
    private var lblMsg: UILabel?
    var label: UILabel? {
        return lblMsg
    }
    
    // MARK: - UIView Overrides
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, textPadding: UIEdgeInsets) {
        super.init(frame: CGRect.zero)
        
        self.textPadding = textPadding
        
        translatesAutoresizingMaskIntoConstraints = false        
        clipsToBounds = true
        
        self.lblMsg = addLabel()        
        
    }
    
    override var intrinsicContentSize: CGSize {
        var labelSize: CGSize = lblMsg?.intrinsicContentSize ?? CGSize.zero
        labelSize.width = labelSize.width + textPadding.left + textPadding.right
        labelSize.height = labelSize.height + textPadding.top + textPadding.bottom
        
        return labelSize
    }                        
    
    private func addLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false        
        label.isUserInteractionEnabled = true
        
        self.addSubview(label)
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                       constant: textPadding.left).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                        constant: -textPadding.right).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor,
                                   constant: textPadding.top).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                      constant: -textPadding.bottom).isActive = true
        
        label.setContentCompressionResistancePriority(UILayoutPriority.required,
                                                      for: UILayoutConstraintAxis.vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh,
                                                      for: UILayoutConstraintAxis.horizontal)
        
        label.numberOfLines = 0
        
        return label
    }
}
