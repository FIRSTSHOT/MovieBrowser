//
//  CustomUIView.swift
//  MovieBrowser
//
//  Created by Abdellah LHASSANI on 3/2/18.
//  Copyright © 2018 Abdellah LHASSANI. All rights reserved.
//

import UIKit
@IBDesignable
class CustomUIView: UIView {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}
