//
//  NDFillButton.swift
//  NDFillButton
//
//  Created by Neil Dwyer on 7/28/15.
//  Copyright (c) 2015 Neil Dwyer. All rights reserved.
//

import UIKit


@IBDesignable public class NDFillButton: UIControl {
    
    let backgroundLayer = CALayer()
    let foregroundLayer = CALayer()
    let fillAnimationLayer = CALayer()
    @IBInspectable var fillColor: UIColor {
        didSet {
            fillAnimationLayer.backgroundColor = fillColor.CGColor
        }
    }
    @IBInspectable var emptyColor: UIColor = UIColor.clearColor()
    @IBInspectable var borderColor: UIColor = UIColor.redColor()
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            updateLayers()
        }
    }
    @IBInspectable var pressedCornerRadius: CGFloat = 5.0
    @IBInspectable var borderWidth: CGFloat = 2
    @IBInspectable var activeFontName: String = "Helvetica"
    @IBInspectable var activeFontColor: UIColor = UIColor.blackColor()
    @IBInspectable var activeFontSize: CGFloat = 14.0
    @IBInspectable var normalFontName: String = "Helvetica"
    @IBInspectable var normalFontColor: UIColor = UIColor.blackColor()
    @IBInspectable var normalFontSize: CGFloat = 14.0
    var textLabel: UILabel = UILabel()
    @IBInspectable var activeText: String = "Active" {
        didSet {
            setupLabel()
        }
    }
    @IBInspectable var normalText: String = "Inactive" {
        didSet {
            setupLabel()
        }
    }
    @IBInspectable var animateTextChange: Bool = true
    
    var animateEnabled: Bool = true
    @objc public var active: Bool = false {
        didSet {
            self.animateFill(active, animated: animateEnabled)
            updateLabel(animateTextChange && animateEnabled)
        }
    }
    
    var pressed: Bool = false {
        didSet {
            let duration = 0.1
            if pressed {
                CATransaction.begin()
                CATransaction.setAnimationDuration(duration)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
                self.backgroundLayer.cornerRadius = pressedCornerRadius
                CATransaction.commit()
            } else {
                CATransaction.begin()
                CATransaction.setAnimationDuration(duration)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
                self.backgroundLayer.cornerRadius = cornerRadius
                CATransaction.commit()               
            }
        }
    }
    
    
    override public var frame: CGRect {
        didSet {
            println("Frame Updated")
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        fillColor = UIColor.redColor()
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clearColor()
        setupLayers()
        setupLabel()
        self.setActive(false, animated: false)
    }
    
    override init(frame: CGRect) {
        fillColor = UIColor.redColor()
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        setupLayers()
        setupLabel()
        self.setActive(false, animated: false)
    }
    
    convenience init() {
        self.init(frame:CGRectZero)
    }
   
    override public func prepareForInterfaceBuilder() {
        setupLayers()
    }
    
    @objc public func toggle() {
        active = !active
    }
    
    func setupLayers() {
        self.layer.addSublayer(backgroundLayer)
        self.backgroundLayer.addSublayer(fillAnimationLayer)
        self.layer.addSublayer(foregroundLayer)
        
        var midPoint = CGPoint(x: backgroundLayer.bounds.size.width / 2, y: backgroundLayer.bounds.size.height / 2)
        fillAnimationLayer.backgroundColor = fillColor.CGColor
        fillAnimationLayer.frame = CGRect(origin: midPoint, size: CGSize.zeroSize)
        
        updateLayers()
    }
    
    func updateLayers() {
        backgroundLayer.frame = CGRect(origin: CGPointZero, size: frame.size)
        backgroundLayer.cornerRadius = cornerRadius
        backgroundLayer.borderWidth = borderWidth
        backgroundLayer.borderColor = borderColor.CGColor
        backgroundLayer.masksToBounds = true
        foregroundLayer.frame = frame
    }
    
    func setupLabel() {
        updateLabel(false)
        self.addSubview(textLabel)
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        var centerX = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        var centerY = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
        self.addConstraints([centerX, centerY])
    }
    
    private func updateLabel(animated: Bool) {
        if(!animated) {
            self.changeLabelText()
            return
        }
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.textLabel.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (anim) -> Void in
            self.changeLabelText()
            UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                self.textLabel.transform = CGAffineTransformMakeScale(1, 1)
            }, completion:nil)
        }
    }
    
    private func animateFill(active: Bool, animated: Bool) {
        var scale = UIScreen.mainScreen().scale
        var R = sqrt(backgroundLayer.bounds.size.height * backgroundLayer.bounds.size.height + backgroundLayer.bounds.size.width * backgroundLayer.bounds.size.width) / 2
        var duration = 0.15 * Double(animated)
        if active {
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            self.fillAnimationLayer.bounds = CGRect(origin: CGPoint.zeroPoint, size: CGSize(width: R * 2, height: R * 2))
            self.fillAnimationLayer.cornerRadius = R
            CATransaction.commit()
        } else {
            var midPoint = CGPoint(x: backgroundLayer.bounds.size.width / 2, y: backgroundLayer.bounds.size.height / 2)
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            self.fillAnimationLayer.bounds = CGRect(origin: midPoint, size: CGSize.zeroSize)
            self.fillAnimationLayer.position = midPoint
            self.fillAnimationLayer.cornerRadius = 0
            CATransaction.commit()
        }
    }
    
    private func changeLabelText() {
        var fontName: String
        var fontSize: CGFloat
        var fontText: String
        var textColor: UIColor
        if(self.active) {
            fontName = self.activeFontName
            fontSize = self.activeFontSize
            fontText = self.activeText
            textColor = self.activeFontColor
        } else {
            fontName = self.normalFontName
            fontSize = self.normalFontSize
            fontText = self.normalText
            textColor = self.normalFontColor
        }
        self.textLabel.font = UIFont(name: fontName, size: fontSize)
        self.textLabel.text = fontText
        self.textLabel.textColor = textColor
        self.textLabel.sizeToFit()
    }
    
    @objc public func setActive(active: Bool, animated: Bool) {
        animateEnabled = animated
        self.active = active
        animateEnabled = true

    }
    
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        pressed = true
        return true
    }
    
    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        return true
    }
    
    override public func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        pressed = false
    }
    
    override public func cancelTrackingWithEvent(event: UIEvent?) {
        pressed = false
    }
}
