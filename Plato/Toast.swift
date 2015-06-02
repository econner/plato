/*
 * Toast.swift
 * SwiftToast
 *
 * Some of the original code is by Su Yeol Jeon 2013-2014.
 * Branched and modified by Fahim Farook 2014 to simplify and add additional functionality which did
 * not meet with original author's requirements/specifications
 *
 */

import UIKit
import QuartzCore

@objc public class Toast: UIView {
    private var vwBG = UIView()
    private var lblToast = UILabel(frame:CGRectMake(0, 0, 100, 100))
    private var insetText = UIEdgeInsetsMake(6, 10, 6, 10)
	private var position:Int!
	private var offset:CGFloat = 0
	private var delay: NSTimeInterval?
	private var duration: NSTimeInterval?
	
	init(text:String, position:Int, offset:CGFloat, duration:NSTimeInterval, delay:NSTimeInterval) {
        super.init(frame: CGRectMake(0, 0, 100, 100))
		let opt = ToastConfig.sharedInstance()
		self.position = position == ToastConfig.positionDefault ? opt.position : position
		self.offset = offset == -1 ? opt.offset : offset
		self.duration = duration == ToastConfig.durationDefault ? opt.duration : duration
		self.delay = delay == ToastConfig.delayDefault ? opt.delay : delay
		// Background
        vwBG.frame = self.bounds
        vwBG.backgroundColor = opt.bgColour
		vwBG.layer.cornerRadius = 5
		vwBG.layer.borderColor = opt.borderColour.CGColor
		vwBG.layer.borderWidth = opt.borderWidth
		if opt.showShadow {
			vwBG.layer.shadowOffset = CGSize(width:2.0, height:2.0)
			vwBG.layer.shadowOpacity = opt.shadowOpacity
		}
        self.addSubview(vwBG)
        // Toast text
        lblToast.textColor = opt.textColour
        lblToast.backgroundColor = UIColor.clearColor()
        lblToast.font = UIFont.systemFontOfSize(opt.textSize)
        lblToast.numberOfLines = 0
        lblToast.textAlignment = NSTextAlignment.Center;
		lblToast.text = text
        self.addSubview(lblToast)
    }

	required public init(coder aDecoder:NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	// MARK:- Class Methods
	public class func makeToast(text:String, duration:NSTimeInterval = ToastConfig.durationDefault, delay:NSTimeInterval = ToastConfig.delayDefault, position:Int, offset:CGFloat) -> Toast {
		let toast = Toast(text:text, position:position, offset:offset, duration:duration, delay:delay)
		return toast
	}
	
	// For calling from Objective-C
	public class func makeToast(text:String) -> Toast {
		return makeToast(text, duration: ToastConfig.durationDefault, delay: ToastConfig.delayDefault, position:ToastConfig.positionDefault, offset:-1)
	}
	
	public class func makeToast(text:String, duration:NSTimeInterval) -> Toast {
		return makeToast(text, duration:duration, delay: ToastConfig.delayDefault, position:ToastConfig.positionDefault, offset:-1)
	}

	public class func makeToast(text:String, duration:NSTimeInterval, delay:NSTimeInterval) -> Toast {
		return makeToast(text, duration:duration, delay:delay, position:ToastConfig.positionDefault, offset:-1)
	}
	
	public class func makeToast(text:String, duration:NSTimeInterval, delay:NSTimeInterval, position:Int) -> Toast {
		return makeToast(text, duration:duration, delay:delay, position:position, offset:-1)
	}
	
	// MARK:- Public Methods
	public func show() {
		// Add orientation observer
		NSNotificationCenter.defaultCenter().addObserver(self, selector:"orientationChanged:", name:UIDeviceOrientationDidChangeNotification, object:nil)
		// Show view
		updateView()
		alpha = 0
		UIApplication.sharedApplication().keyWindow?.subviews.first?.addSubview(self)
		UIView.animateWithDuration(0.5,
			delay: delay!,
			options: UIViewAnimationOptions.BeginFromCurrentState,
			animations: { () in self.alpha = 1 },
			completion: { (completed: Bool) in
				UIView.animateWithDuration(self.duration!,
					animations: { () in self.alpha = 1.0001 },
					completion: { (completed: Bool) in
						self.hide()
				})
		})
	}
	
	// MARK:- Private Methods
    func updateView() {
        let deviceWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let font = self.lblToast.font
        let constraintSize = CGSizeMake(deviceWidth * (280.0 / 320.0), CGFloat.max)
        var textLabelSize = self.lblToast.sizeThatFits(constraintSize)
        self.lblToast.frame = CGRect(
            x: self.insetText.left,
            y: self.insetText.top,
            width: textLabelSize.width,
            height: textLabelSize.height
        )
        self.vwBG.frame = CGRect(
            x: 0,
            y: 0,
            width: self.lblToast.frame.size.width + self.insetText.left + self.insetText.right,
            height: self.lblToast.frame.size.height + self.insetText.top + self.insetText.bottom
        )
        
		var x: CGFloat
		var y:CGFloat = 0
		var wd:CGFloat
		var ht:CGFloat
		
		var width = vwBG.frame.size.width
		var height = vwBG.frame.size.height
		let sz = UIScreen.mainScreen().bounds.size
		let orientation = UIApplication.sharedApplication().statusBarOrientation
		let sver = UIDevice.currentDevice().systemVersion as NSString
		let ver = sver.floatValue
		if UIInterfaceOrientationIsLandscape(orientation) && ver < 8.0 {
			wd = sz.height
			ht = sz.width
		} else {
			wd = sz.width
			ht = sz.height
		}
		x = (wd - width) * 0.5
		if position == ToastConfig.positionBottom {
			y = ht - (height + offset)
		} else if position == ToastConfig.positionCenter {
			y = ((ht - height) * 0.5) + offset
		} else if position == ToastConfig.positionTop {
			y = offset
		}
        self.frame = CGRectMake(x, y, width, height);
    }
	
	func orientationChanged(sender: AnyObject?) {
		updateView()
	}
	
	func hide() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
		UIView.animateWithDuration(0.5, animations: { () in self.alpha = 0 })
	}
	
//    override public func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView? {
//        return nil
//    }
}
