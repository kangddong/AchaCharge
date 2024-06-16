//
//  CircularProgressBarView.swift
//  Controllers-macOS
//
//  Created by 강동영 on 5/21/24.
//

import Cocoa

class CircularProgressBarView: NSView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
//    private var startPoint = CGFloat(-Double.pi / 2)
//    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    private var startPoint = CGFloat(3 * Double.pi / 2)
    private var endPoint = CGFloat(-Double.pi / 2)
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CircularProgressBarView {
    
    private func createCircularPath() {
//        let layer = makeBackingLayer()
        layer?.sublayers = []
        print(layer)
        // created circularPath for circleLayer and progressLayer
        let circularPath = NSBezierPath()
        circularPath.appendArc(withCenter: NSPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 40, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = NSColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = NSColor.systemGreen.withAlphaComponent(0.3).cgColor
        // added circleLayer to layer
        layer?.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = NSColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 20.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = NSColor.systemGreen.cgColor
        
        // added progressLayer to layer
        layer?.addSublayer(progressLayer)
        progressAnimation(value: 0.5)
    }
    
    func progressAnimation(duration: TimeInterval = 0.5, value: Float) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
