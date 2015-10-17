//
//  Cell_View.swift
//  Dots
//
//  Created by Denis Filipas on 10/9/15.
//  Copyright © 2015 Denis Filipas. All rights reserved.
//

import UIKit

class Cell_View: UIView {
    
    var horizontalIndex: Int
    var verticalIndex: Int
    var coin: Coin_View?
    
    init(horizontalIndex: Int, verticalIndex: Int) {
        self.horizontalIndex = horizontalIndex
        self.verticalIndex = verticalIndex
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        self.horizontalIndex = 0
        self.verticalIndex = 0
        super.init(coder:aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let background = UIBezierPath(rect: self.bounds)
        UIColor.whiteColor().setFill()
        background.fill()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blackColor().CGColor
    }

}
