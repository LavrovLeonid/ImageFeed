//
//  GradientView.swift
//  ImageFeed
//
//  Created by Леонид Лавров on 5/7/24.
//

import UIKit

@IBDesignable
public class GradientView: UIView {
    // MARK: Inspectable properties
    @IBInspectable var startColor: UIColor = .clear {
        didSet {
            updateColors()
        }
    }
    @IBInspectable var endColor: UIColor = .clear {
        didSet {
            updateColors()
        }
    }
    
    // MARK: Properties
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    // MARK: Override properties
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateColors()
    }
    
    // MARK: Private methods
    private func updateColors() {
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
