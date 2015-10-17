//
//  MainBoard_ViewController.swift
//  Dots
//
//  Created by Denis Filipas on 10/9/15.
//  Copyright © 2015 Denis Filipas. All rights reserved.
//

import UIKit

class MainBoard_ViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet var rootView: UIView! {
        didSet {
            animator = UIDynamicAnimator(referenceView: rootView)
            gravity = UIGravityBehavior()
            collision = UICollisionBehavior()
            collision.translatesReferenceBoundsIntoBoundary = true
            
            dynamic = UIDynamicItemBehavior()
            //dynamic.allowsRotation = false
            dynamic.elasticity = 0
            dynamic.resistance = 1
            dynamic.friction = 0
            
            animator.addBehavior(gravity)
            animator.addBehavior(collision)
            animator.addBehavior(dynamic)
            animator.delegate = self
        }
    }
    //@IBOutlet weak var mainView: UIView!
    
    var cellCount: Int = 6
    private var cellSize: CGSize?
    private var lastCoin: Coin_View?
    private var cells = [Cell_View]()
    private var pairs = [[Cell_View]]()
    
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!
    private var dynamic: UIDynamicItemBehavior!
    
    private var locked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawCells()
    }

    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
//        let cell = getHittedCell(CGPoint(x: lastCoin!.frame.midX, y: lastCoin!.frame.midY))
//        cell.coin = lastCoin
//        //print("h:\(cell.horizontalIndex), v:\(cell.verticalIndex)")
//        
//        var modifiers = [CGPoint]()
//        for var x = -1; x < 2; x++ {
//            for var y = -1; y < 2; y++ {
//                modifiers.append(CGPoint(x: x, y: y))
//            }
//        }
//        
//        main: for var modifier in modifiers {
//            if let neighbour = getCell(cell.horizontalIndex + Int(modifier.x), verticalIndex: cell.verticalIndex + Int(modifier.y)) where neighbour.coin?.coinType == lastCoin?.coinType {
//                let tmpPairs = getAllPairs(withCell: neighbour)
//                if tmpPairs.count == 0 {
//                    self.pairs.append([cell, neighbour])
//                } else {
//                    for var i = 0; i < self.pairs.count; i++ {
//                        let pair = self.pairs[i]
//                        if pair.contains(neighbour) {
//                            var newArr = pair
//                            newArr.append(cell)
//                            self.pairs[i] = newArr
//                            
//                            if checkWin() { break main }
//                        }
//                    }
//                }
//            }
//        }
        self.locked = false
    }
    
    @IBAction func tapGesture(sender: UITapGestureRecognizer) {
        
        guard !self.locked else { return }
        self.locked = true
        
        let tap = sender.locationInView(rootView)
        let cell = getCellWillHit(tap)
        
        let viewSize = self.cellSize!
        let coin = nextCoin()
        coin.frame = CGRect(
            origin: CGPoint(x: tap.x, y: CGFloat(0)),//cell.frame.midX
            size: viewSize)
        
        rootView.addSubview(coin)
        coin.setNeedsDisplay()
        

        
        let pin = UISnapBehavior(item: coin, snapToPoint: CGPoint(x: cell.frame.midX, y: cell.frame.midY))
        //pin.damping = 1
        //animator.addBehavior(pin)
        
        //collision.addBoundaryWithIdentifier("coin", fromPoint: CGPoint(x: coin.frame.maxX, y: <#T##CGFloat#>), toPoint: <#T##CGPoint#>)
        
        collision.addItem(coin)
        gravity.addItem(coin)
//        gravity.action = {
//            let collisionKey = "coin\(cell.horizontalIndex)\(cell.verticalIndex)"
//            
//            self.collision.removeBoundaryWithIdentifier(collisionKey)
//            let coinPath = UIBezierPath(rect: coin.frame) //UIBezierPath(ovalInRect: coin.frame.insetBy(dx: 5, dy: 5))
//            self.collision.addBoundaryWithIdentifier(collisionKey, forPath: coinPath)
//        }
        
        cell.coin = coin
    }

    private func drawCells() {
        let cellWidth = rootView.bounds.width / CGFloat(cellCount)
        let cellHorizontalCount = rootView.bounds.height / cellWidth
        let topMargin = rootView.bounds.height - (cellWidth * CGFloat(Int(cellHorizontalCount)))
        
        for var hIndex = 0; hIndex < Int(cellHorizontalCount); hIndex++ {
            for var wIndex = 0; wIndex < cellCount; wIndex++ {
                let view = Cell_View(horizontalIndex: wIndex, verticalIndex: hIndex)
                view.frame = CGRect(
                    origin: CGPoint(x: cellWidth * CGFloat(wIndex), y: cellWidth * CGFloat(hIndex) + topMargin),
                    size: CGSize(width: cellWidth, height: cellWidth))

                rootView.addSubview(view)
                view.setNeedsDisplay()
                
                self.cells.append(view)
            }
            
//            collision.addBoundaryWithIdentifier("vertical\(hIndex)",
//                fromPoint: CGPoint(x: cellWidth * CGFloat(hIndex), y: CGFloat(0)),
//                toPoint: CGPoint(x: cellWidth * CGFloat(hIndex), y: rootView.frame.maxY))
        }
        
        self.cellSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    private func nextCoin() -> Coin_View {
        let lastCoinType = lastCoin?.coinType
        let coinType = lastCoinType == Coin_View.CoinType.Blue ? Coin_View.CoinType.Red : Coin_View.CoinType.Blue;
        let coin = Coin_View(type: coinType)
        self.lastCoin = coin
        
        return coin
    }
    private func getCellWillHit(point: CGPoint) -> Cell_View {
        let views = self.cells.filter { return $0.frame.contains(CGPoint(x: point.x, y: $0.frame.midY)) && $0.coin == nil }
        return views.sort { return $0.0.verticalIndex > $0.1.verticalIndex }.first!
    }
    
    private func getHittedCell(point: CGPoint) -> Cell_View {
        let views = cells.filter { return $0.frame.contains(point) }
        return views.first!
    }
    private func getCell(horizontalIndex: Int, verticalIndex: Int) -> Cell_View? {
        let views = cells.filter { return $0.horizontalIndex == horizontalIndex && $0.verticalIndex == verticalIndex }
        
        return views.first
    }
    
    private func getAllPairs(withCell cell: Cell_View) -> [[Cell_View]] {
        return self.pairs.filter { return $0.contains(cell) }
    }
    
    private func checkWin() -> Bool {
        if pairs.contains({ return $0.count >= 3 }) {
            print("win")
            return true
        }
        
        return false
    }
}
