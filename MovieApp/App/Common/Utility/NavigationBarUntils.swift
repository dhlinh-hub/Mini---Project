//
//  NavigationBarGradiant.swift
//  MovieApp
//
//  Created by Ishipo on 17/09/2021.
//

import UIKit

extension UINavigationBar  {
    func setGradientBackground() {
        let gradient: CAGradientLayer = CAGradientLayer()
        let leftColor = UIColor.init(hex: "#FA7100").cgColor
        let rightColor = UIColor.init(hex: "#FD9C00").cgColor
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        gradient.colors = [leftColor, rightColor]
        self.setBackgroundImage(self.image(fromLayer: gradient), for: .default)
    }
    
    
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
}
