//
//  ViewExtensions.swift
//  Plato
//
//  Created by Eric Conner on 4/29/15.
//  Copyright (c) 2015 com.platoapp. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UITextField {
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor)
        }
        set {
            println(newValue?.CGColor)
            layer.borderColor = newValue?.CGColor
        }
    }
}