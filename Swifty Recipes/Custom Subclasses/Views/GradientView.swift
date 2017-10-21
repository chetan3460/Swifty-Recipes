//
//  GradiantView.swift
//  Swifty Recipes
//
//  Created by Frank Ehlers on 14.10.17.
//  Copyright © 2017 Frank Ehlers. All rights reserved.
//
import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable
    var startColor: UIColor = UIColor.white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var endColor: UIColor = UIColor.white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var startPoint: CGPoint = CGPoint.zero {
        didSet {
            gradientLayer.startPoint = startPoint
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var endPoint: CGPoint = CGPoint.zero {
        didSet {
            gradientLayer.endPoint = endPoint
            setNeedsDisplay()
        }
    }


    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        gradientLayer.frame = self.bounds
        return gradientLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        gradientLayer.frame = bounds
    }
}

