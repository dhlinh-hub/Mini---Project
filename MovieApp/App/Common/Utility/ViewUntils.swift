//
//  ViewUntils.swift
//  MovieApp
//
//  Created by Ishipo on 18/09/2021.
//

import UIKit

extension UIView {
    
    
    @IBInspectable var lCornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            if newValue == -1 {
                layer.cornerRadius = frame.width < frame.height ? frame.width * 0.5 : frame.height * 0.5
            } else {
                layer.cornerRadius = newValue
            }
            clipsToBounds = true
            layer.masksToBounds = true

        }
    }
    
    @IBInspectable var lBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var lBorderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
   
    func setGradientView() {
        let gradient: CAGradientLayer = CAGradientLayer()
        let leftColor = UIColor.init(hex: "#36D1DC").cgColor
        let rightColor = UIColor.init(hex: "#5B86E5").cgColor
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        gradient.colors = [leftColor, rightColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    enum ViewCorner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    func makeCorner(radius: CGFloat, corners: [ViewCorner]) {
        var corners = corners
        
        if corners.isEmpty {
            corners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        }
        
        let maskedCorners = corners.map { corner -> CACornerMask in
            switch corner {
            case .topLeft:
                return .layerMinXMinYCorner
            case .topRight:
                return .layerMaxXMinYCorner
            case .bottomLeft:
                return .layerMinXMaxYCorner
            case .bottomRight:
                return .layerMaxXMaxYCorner
            }
        }

        layer.maskedCorners = CACornerMask(maskedCorners)
        layer.cornerRadius = radius
    }

}
