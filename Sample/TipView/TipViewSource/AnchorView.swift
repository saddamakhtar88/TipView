//
//  AnchorView.swift
//  TipView
//
//  Copyright © 2017 Personal. All rights reserved.
//

import UIKit

class AnchorView: UIView {
    
    let direction: TipView.Direction
    var color: UIColor = UIColor.red
    
    init(frame: CGRect, direction: TipView.Direction) {
        self.direction = direction
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false        
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        
        switch direction {
        case .top: //
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxX))
        case .bottom: // ^
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        case .left:  // >
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY / 2.0))
            context.addLine(to: CGPoint(x: (rect.minX), y: rect.maxY))
        case .right: // <
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY / 2.0))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: (rect.maxX), y: rect.maxY))
        case .none:
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        
        context.closePath()
        
        context.setFillColor(self.color.cgColor)
        context.fillPath()
    }
    
}
