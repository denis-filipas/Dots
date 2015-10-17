//
//  CoinView.swift
//  Dots
//
//  Created by Denis Filipas on 10/10/15.
//  Copyright © 2015 Denis Filipas. All rights reserved.
//

import UIKit

class Coin_View: UIView {
    
    enum CoinType {
        case Blue
        case Red
        case Empty
        
        func getColor() -> UIColor {
            switch(self) {
            case .Blue: return UIColor.blueColor()
            case .Red: return UIColor.redColor()
            case .Empty: return UIColor.grayColor()
            }
        }
    }
    
    var coinType = CoinType.Empty
    lazy var coinPath: UIBezierPath = {
        let coinSize = self.bounds.insetBy(dx: 5, dy: 5)
        return UIBezierPath(ovalInRect: coinSize)
    }()
    
    init(type: CoinType) {
        coinType = type
        
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor(white: 0.5, alpha: 1)
        self.clipsToBounds = true
        self.layer.cornerRadius = 35
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override func drawRect(rect: CGRect) {
        coinType.getColor().setFill()
        coinPath.fill()
        
        let line = UIBezierPath()
        line.moveToPoint(CGPoint(x: bounds.midX, y: 0))
        line.addLineToPoint(CGPoint(x: bounds.midX, y: bounds.midY))
        UIColor.blackColor().setStroke()
        line.stroke()
        
    }


}
